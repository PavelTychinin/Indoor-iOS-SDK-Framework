//
//  ViewController.swift
//  Swift Example
//
//  Created by Pavel Tychinin on 15/12/2017.
//  Copyright © 2017 Pavel Tychinin. All rights reserved.
//

import UIKit
import Navigine

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(
            red: (hex >> 16) & 0xFF,
            green: (hex >> 8) & 0xFF,
            blue: hex & 0xFF
        )
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var sv: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    var current:UIImageView?
    var isRouting = false
    var navigineCore: NavigineCore?
    
    var uipath:UIBezierPath?
    var routeLayer:CAShapeLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sv.frame = view.frame
        sv.delegate = self
        sv.pinchGestureRecognizer?.isEnabled = true
        sv.minimumZoomScale = 1.0
        sv.zoomScale = 1.0
        sv.maximumZoomScale = 2.0
        sv.addSubview(imageView)
        let userHash = "0000-0000-0000-0000" // your personal security key in the profile
        let server = "https://api.navigine.com" // your API server
        navigineCore = NavigineCore(userHash: userHash, server: server)
        navigineCore?.delegate = self
        
        // Point on map
        current = UIImageView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        current?.backgroundColor = UIColor.red
        current?.layer.cornerRadius = (current?.frame.size.height)! / 2.0
        imageView?.addSubview(current!)
        imageView.isUserInteractionEnabled = true
        
        
        Timer.scheduledTimer(timeInterval: 0.1,
                             target: self,
                             selector: #selector(ViewController.navigationTick(_:)),
                             userInfo: nil,
                             repeats: true)
        
        navigineCore?.downloadLocation(byId: 1286,
                                       forceReload: true,
                                       processBlock: { (_ loadProcess: Int) in
                                        print("load process: \(loadProcess)")
                                        
        },
                                       successBlock: { (_ userInfo:[AnyHashable : Any]?) in
                                        self.setupNavigine()
        },
                                       fail: { (_ error: Error?) in
                                        print("error: \(error.debugDescription)")
        })
//        navigineCore?.setTarget(<#T##target: NCLocationPoint!##NCLocationPoint!#>)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavigine() {
        navigineCore?.startNavigine()
        navigineCore?.startPushManager()
        imageView.subviews.forEach({ $0.removeFromSuperview() })
        imageView.layer.sublayers = nil
        imageView.addSubview(current!)
        
        let location = navigineCore?.location
        let sublocation = location?.sublocations[0] as! NCSublocation
        let imageData: Data? = sublocation.pngImage
        let image = UIImage(data: imageData ?? Data())
        var scale: CGFloat = 1.0
        if (image?.size.width)! / (image?.size.height)! > view.frame.size.width / view.frame.size.height {
            scale = (view.frame.size.height / (image?.size.height)!)
        }
        else {
            scale = (view.frame.size.width / (image?.size.width)!)
        }
        imageView.frame = CGRect(x: 0, y: 0, width: (image?.size.width)! * scale, height: (image?.size.height)! * scale)
        imageView.image = image
        sv.contentSize = imageView.frame.size
        drawZones()
    }
    
    @objc func navigationTick(_ timer: Timer) {
        let res: NCDeviceInfo? = navigineCore?.deviceInfo
        if ((res?.error) == nil) {
            self.current?.isHidden = false
            current?.center = CGPoint(x: imageView.frame.size.width / sv.zoomScale * CGFloat((res?.kx)!),
                                      y: imageView.frame.size.height / sv.zoomScale * CGFloat(1.0 - (res?.ky)!))
        }
        else {
            current?.isHidden = true
        }
        if isRouting {
            let devicePath = res?.paths.first as! NCRoutePath
            let path = devicePath.points
            let distance: Float? = devicePath.lenght
            drawRoute(withPath: path!, andDistance: distance!)
        }
    }
    
    func drawRoute(withPath path: [Any], andDistance distance: Float) {
        //    // We check that we are close to the finish point of the route
        if distance <= 3.0 {
            stopRoute()
        }
        else {
            routeLayer?.removeFromSuperlayer()
            uipath?.removeAllPoints()
            uipath = UIBezierPath()
            routeLayer = CAShapeLayer()
            
            for i in 0..<path.count {
                let point = path[i] as! NCLocationPoint
                let sublocation = navigineCore?.location.sublocations[0] as! NCSublocation
                let imageSizeInMeters = CGSize(width: CGFloat(sublocation.width),
                                               height: CGFloat(sublocation.height))
                let xPoint = CGFloat(((CGFloat(point.x.floatValue) / imageSizeInMeters.width) *
                    (imageView.frame.size.width / CGFloat(sv.zoomScale))))
                
                let yPoint = CGFloat(((CGFloat(1.0 - point.x.floatValue) / imageSizeInMeters.height) *
                    (imageView.frame.size.height / CGFloat(sv.zoomScale))))
                
                if i == 0 {
                    uipath?.move(to: CGPoint(x: xPoint, y: yPoint))
                }
                else {
                    uipath?.addLine(to: CGPoint(x: xPoint, y: yPoint))
                }
            }
        }
        routeLayer?.isHidden = false
        routeLayer?.path = uipath?.cgPath
        routeLayer?.strokeColor = UIColor(hex: 0x4AADD4).cgColor
        routeLayer?.lineWidth = 2.0
        routeLayer?.lineJoin = kCALineJoinRound
        routeLayer?.fillColor = UIColor.clear.cgColor
        imageView.layer.addSublayer(routeLayer!)
        imageView.bringSubview(toFront: current!)
    }
    
    func stopRoute() {
        isRouting = false
        routeLayer?.removeFromSuperlayer()
        routeLayer = nil
        uipath?.removeAllPoints()
        uipath = nil
        navigineCore?.cancelTargets()
    }
    
    func drawZones() {
        let sublocation = navigineCore?.location.sublocations[0] as! NCSublocation
        let zones = sublocation.zones as! [NCZone]
        for zone: NCZone in zones {
            let zonePath = UIBezierPath()
            let zoneLayer = CAShapeLayer()
            let points = zone.points as! [NCLocationPoint]
            let point0 = points[0]
            zonePath.move(to: CGPoint(x: imageView.frame.size.width * CGFloat(point0.x.floatValue / sublocation.width),
                                      y: imageView.frame.size.height * CGFloat(1.0 - point0.y.floatValue / sublocation.height)))
            
            for point in points  {
                zonePath.addLine(to: CGPoint(x: imageView.frame.size.width * CGFloat(point.x.floatValue / sublocation.width),
                                             y: imageView.frame.size.height * CGFloat(1.0 - point.y.floatValue / sublocation.height)))
            }
            zonePath.addLine(to: CGPoint(x: imageView.frame.size.width * CGFloat(point0.x.floatValue / sublocation.width),
                                         y: imageView.frame.size.height * CGFloat(1.0 - point0.y.floatValue / sublocation.height)))
            
            var result: UInt32 = 0
            let scanner = Scanner(string: zone.color)
            scanner.scanLocation = 1
            scanner.scanHexInt32(&result)
            zoneLayer.isHidden = false
            zoneLayer.path = zonePath.cgPath
            zoneLayer.strokeColor = UIColor(hex: Int(result)).cgColor
            zoneLayer.lineWidth = 2.0
            zoneLayer.lineJoin = kCALineJoinRound
            zoneLayer.fillColor = UIColor(hex: Int(result)).withAlphaComponent(0.5).cgColor
            imageView.layer.addSublayer(zoneLayer)
        }
    }
}

extension ViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension ViewController: NavigineCoreDelegate {
    func didRangePush(withTitle title: String!, content: String!, image: String!, id: Int) {
        // your code
    }
}
