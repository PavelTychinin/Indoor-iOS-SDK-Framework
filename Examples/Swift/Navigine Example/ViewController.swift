//
//  ViewController.swift
//  Swift-New
//
//  Created by Dmitry Stavitsky on 08/07/2018.
//  Copyright © 2018 Navigine. All rights reserved.
//

import UIKit
import Navigine

class ViewController: UIViewController {
  // Constraints
  @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
  
  // UI elements
  @IBOutlet weak var mImageView: UIImageView!
  @IBOutlet weak var mScrollView: UIScrollView!
  @IBOutlet weak var mLblCurrentFloor: UILabel!
  @IBOutlet weak var mBtnStackFloor: UIStackView!
  
  var mEventView = RouteEventView()
  var mErrorView = ErrorView()
  
  // Map elements
  var mPressedPin  = MapPin(venue: NCVenue()) // Selected venue
  var mCurPosition = CurrentLocation() // Current position
  var mFloor = 0
  
  // Path
  var mRoutePath  = UIBezierPath()
  var mRouteLayer = CAShapeLayer()
  var mIsRouting  = false

  // Navigine core attributes
  var mNavigineCore = NavigineCore()
  var mLocation = NCLocation()
  var mSublocation = NCSublocation() // Current sublocation
  
  // Login options
  let userHash   = "0000-0000-0000-0000" // Your user hash
  let serverName = "https://api.navigine.com"
  let locationId = 2872
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mScrollView.delegate = self
    mScrollView.pinchGestureRecognizer?.isEnabled = true
    mScrollView.minimumZoomScale = 1.0
    mScrollView.maximumZoomScale = 2.0
    mScrollView.zoomScale = 1.0
    
    // Create gesture regignizers for long tap and single tap
    let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapOnMap))
    let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapOnMap))
    mScrollView.addGestureRecognizer(singleTapGesture)
    mScrollView.addGestureRecognizer(longTapGesture)
    
    // Add navigation bar
    mEventView = RouteEventView(frame: CGRect(x: 0.0, y: view.statusBarFrame().size.height, width: view.frame.size.width, height: 80.0))
    view.addSubview(mEventView)
    mEventView.mCancelBtn.addTarget(self, action: #selector(stopRoute), for: .touchUpInside)
    
    // Error view
    let xPos = 0
    let yPos = view.frame.size.height - view.frame.size.height / 8.0
    let width = view.frame.size.width
    let height = view.frame.size.height / 8.0
    mErrorView = ErrorView(frame: CGRect(x: CGFloat(xPos), y: CGFloat(yPos), width: CGFloat(width), height: CGFloat(height)))
    view.addSubview(mErrorView)
    
    // Add current position on map
    mImageView.addSubview(mCurPosition)
    view.bringSubview(toFront: mBtnStackFloor!)
    
    // Add loading progress bar while map is downloading
    let spinnerActivity = MBProgressHUD.showAdded(to: view, animated: true)
    spinnerActivity.mode = .determinateHorizontalBar
    spinnerActivity.label.text = "Loading"
    spinnerActivity.detailsLabel.text = "Please Wait!"
    spinnerActivity.isUserInteractionEnabled = false
    
    // Initialize navigation core
    mNavigineCore = NavigineCore(userHash: userHash, server: serverName)
    mNavigineCore.navigationDelegate = self
    
    mNavigineCore.downloadLocation(byId: locationId,
                                   forceReload: true,
                                   processBlock: {(_ loadProcess: Int) in
                                    print("load process: \(loadProcess)")
                                    spinnerActivity.progress = Float(loadProcess)
                                  },
                                   successBlock: {(_ userInfo:[AnyHashable : Any]?) in
                                    self.mNavigineCore.startNavigine()
                                    self.mNavigineCore.startPushManager()
                                    self.setupFloor(self.mFloor)
                                    spinnerActivity.hide(animated: true)
                                    self.mImageView.isUserInteractionEnabled = true },
                                   fail: {(_ error: Error?) in
                                    print("error: \(error.debugDescription)")})
    // Add beacon generators if needed
    mNavigineCore.addBeaconGenerator("F7826DA6-4FA2-4E98-8024-BC5B71E0893E", major: 65463, minor: 38214, timeout: 50, rssiMin: -100, rssiMax: -70)
    // [_navigineCore addBeaconGenerator: @"F7826DA6-4FA2-4E98-8024-BC5B71E0893E" major: 63714 minor:8737 timeout:50 rssiMin:-100 rssiMax:-x70];
    // [_navigineCore addBeaconGenerator: @"8EEB497E-4928-44C6-9D92-087521A3547C" major: 9001  minor:36 timeout:10 rssiMin:-90 rssiMax:-70];
  }
  
  func setupFloor(_ floor: Int) {
    mImageView.removeFromSuperview()
    removeVenuesFromMap() // Remove venues from map
    removeZonesFromMap() // Remove zones from map
    mScrollView.zoomScale = 1.0 // Reset zoom
    mLocation = mNavigineCore.location
    mSublocation = mNavigineCore.location.sublocations[floor] as! NCSublocation
    mImageView.image = UIImage(data: mSublocation.pngImage)
    mScrollView.addSubview(mImageView)
    mBtnStackFloor.isHidden = mLocation.sublocations.count == 1 // Hide buttons if count of sublocations = 0
    mLblCurrentFloor.text = String(floor)
    let imgSize: CGSize = mImageView.image!.size
    let viewSize: CGSize = view.frame.size
    var scale: CGFloat = 1.0
    if (imgSize.width / imgSize.height) > (viewSize.width / viewSize.height) {
      scale = CGFloat(viewSize.height / imgSize.height)
    } else {
      scale = CGFloat(imgSize.width / imgSize.width)
    }
    mScrollView.contentSize = CGSize(width: imgSize.width * CGFloat(scale),
                                     height: imgSize.height * CGFloat(scale))
    // Add constraints
    imageViewWidthConstraint.constant = imgSize.width * CGFloat(scale)
    imageViewHeightConstraint.constant = imgSize.height * CGFloat(scale)
    
    view.layoutIfNeeded()
    drawZones()
    drawVenues()
  }
}

// MARK: - Button actions
extension ViewController {
  
  @IBAction func singleTapOnMap(gesture: UITapGestureRecognizer) {
    if mPressedPin.isSelected {
      mPressedPin.mPopUp.isHidden = true
    }
  }
  
  // Draw route by long tap
  @IBAction func longTapOnMap(gesture: UITapGestureRecognizer) {
    if gesture.state != .began {
      return
    }
    mImageView.viewWithTag(1)?.removeFromSuperview() // Remove destination pin from map
    mNavigineCore.cancelTarget()
    let touchPtInPx = gesture.location(ofTouch: 0, in: mScrollView) // Touch point in pixels
    let touchPtInM = convertPixelsToMeters(srcX: touchPtInPx.x, srcY: touchPtInPx.y, scale: 1) // Touch point in meters
    let targetPt = NCLocationPoint(location: mLocation.id,
                                   sublocation: mSublocation.id,
                                   x: NSNumber(value: Float(touchPtInM.x)),
                                   y: NSNumber(value: Float(touchPtInM.y)))
    mNavigineCore.addTarget(targetPt)
    // Create destination pin on map
    if let imgMarker = UIImage(named: "elmMapPin") {
      let destinationMarker = UIImageView(image: imgMarker)
      destinationMarker.tag = 1
      destinationMarker.transform = CGAffineTransform(scaleX: 1.0 / mScrollView.zoomScale, y: 1.0 / mScrollView.zoomScale)
      destinationMarker.setCenterX(touchPtInPx.x / mScrollView.zoomScale)
      destinationMarker.setCenterY((touchPtInPx.y - imgMarker.size.height / 2.0) / mScrollView.zoomScale)
      destinationMarker.layer.zPosition = 5.0
      mImageView.addSubview(destinationMarker)
      mIsRouting = true
    }
  }
  
  @objc func stopRoute() {
    mImageView.viewWithTag(1)?.removeFromSuperview() // Remove current pin from map
    mRouteLayer.removeFromSuperlayer()
    mRoutePath.removeAllPoints()
    mNavigineCore.cancelTargets()
    mIsRouting = false
    mEventView.isHidden = true
  }
  
  @IBAction func btnIncreaseFloorPressed() {
    let sublocCnt = mLocation.sublocations.count - 1
    if mFloor == sublocCnt {
      return
    }
    else {
      mFloor += 1
      setupFloor(mFloor)
    }
  }
  
  @IBAction func btnDecreaseFloorPressed() {
    if mFloor == 0 {
      return
    }
    else {
      mFloor -= 1
      setupFloor(mFloor)
    }
  }
  
  @IBAction func mapPinTap(_ pinBtn: MapPin) {
    if pinBtn.isSelected {
      pinBtn.isSelected = false
    } else {
      mPressedPin.mPopUp.isHidden = true // Hide last selected pin
      mPressedPin = pinBtn
      pinBtn.mPopUp.isHidden = false // Show currently selected pin
      pinBtn.mPopUp.setCenterX(pinBtn.centerX())
      pinBtn.isSelected = true
      pinBtn.resizeMapPinWithZoom(mScrollView.zoomScale)
      mImageView.addSubview(pinBtn.mPopUp)
    }
  }
}

// MARK: - Draw functions
extension ViewController {
  
  func drawRoute(withPath path: NCRoutePath, andDistance distance: Float) {
    if distance <= 3.0 { // Check that we are close to the finish point of the route
      stopRoute()
    } else {
      mRouteLayer.removeFromSuperlayer()
      mRoutePath.removeAllPoints()
      mRouteLayer = CAShapeLayer()
      mRoutePath = UIBezierPath()
      for obj in path.points {
        if let curPoint = obj as? NCLocationPoint {
          if curPoint.sublocation != mSublocation.id { // If path between different sublocations
            continue
          }
          else {
            let cgPoint: CGPoint = convertMetersToPixels(srcX: CGFloat(truncating: curPoint.x),
                                                         srcY: CGFloat(truncating: curPoint.y),
                                                         scale: mScrollView.zoomScale)
            if mRoutePath.isEmpty {
              mRoutePath.move(to: cgPoint)
            } else {
              mRoutePath.addLine(to: cgPoint)
            }
          }
        }
      }
      mRouteLayer.isHidden = false
      mRouteLayer.path = mRoutePath.cgPath
      mRouteLayer.strokeColor = UIColor(hex: 0x4aadd4).cgColor
      mRouteLayer.lineWidth = 2.0
      mRouteLayer.lineJoin = kCALineJoinRound
      mRouteLayer.fillColor = UIColor.clear.cgColor
      mImageView.layer.addSublayer(mRouteLayer) // Add route layer on map
      mImageView.bringSubview(toFront: mCurPosition)
    }
  }

  func drawVenues() {
    for obj in mSublocation.venues {
      if let curVenue = obj as? NCVenue {
        let mapPin = MapPin(venue: curVenue)
        let xPt = CGFloat(truncating: curVenue.x)
        let yPt = CGFloat(truncating: curVenue.y)
        mapPin.center = convertMetersToPixels(srcX: xPt, srcY: yPt, scale: 1)
        mapPin.addTarget(self, action: #selector(mapPinTap(_:)), for: .touchUpInside)
        mapPin.sizeToFit()
        mImageView.addSubview(mapPin)
        mScrollView.bringSubview(toFront: mapPin)
      }
    }
  }
  
  func drawZones() {
    for obj in mSublocation.zones {
      if let curZone = obj as? NCZone {
        let zonePath = UIBezierPath()
        let zoneLayer = CAShapeLayer()
        var firstPoint = CGPoint(x: 0, y: 0)
        for obj in curZone.points {
          if let curPoint = obj as? NCLocationPoint {
            let xPt = curPoint.x
            let yPt = curPoint.y
            let cgCurPoint: CGPoint = convertMetersToPixels(srcX: CGFloat(truncating: xPt),
                                                            srcY: CGFloat(truncating: yPt),
                                                            scale: 1)
            if zonePath.isEmpty {
              firstPoint = cgCurPoint
              zonePath.move(to: cgCurPoint)
            } else {
              zonePath.addLine(to: cgCurPoint)
            }
          }
        }
        zonePath.addLine(to: firstPoint) // Add first point again to close path
        let hexColor:UInt32 = stringToHex(srcStr: curZone.color) // Parse zone color
        zoneLayer.name = "Zone"
        zoneLayer.path = zonePath.cgPath
        zoneLayer.strokeColor = UIColor(hex: Int(hexColor)).cgColor
        zoneLayer.lineWidth = 2.0
        zoneLayer.lineJoin = kCALineJoinRound
        zoneLayer.fillColor = UIColor(hex: Int(hexColor)).withAlphaComponent(0.5).cgColor
        mImageView.layer.addSublayer(zoneLayer)
      }
    }
  }
  
  func removeVenuesFromMap() {
    for obj in mImageView.subviews {
      if let pin = obj as? MapPin {
        pin.removeFromSuperview()
        pin.mPopUp.removeFromSuperview()
      }
    }
  }
  
  func removeZonesFromMap() {
    for layer in mImageView.layer.sublayers! { // Unsafe code!!!
      if layer.name == "Zone" {
        layer.removeFromSuperlayer()
      }
    }
  }
}

// MARK: - Helper functions
extension ViewController {
  
  // Convert from pixels to meters
  func convertPixelsToMeters(srcX: CGFloat, srcY: CGFloat, scale: CGFloat) -> CGPoint {
    let dstX = (srcX / (mImageView.width() / scale) * CGFloat(mSublocation.width))
    let dstY = ((1.0 - srcY / (mImageView.height() / scale)) * CGFloat(mSublocation.height))
    return CGPoint(x: dstX, y: dstY)
  }
  
  // Convert from meters to pixels
  func convertMetersToPixels(srcX: CGFloat, srcY: CGFloat, scale: CGFloat) -> CGPoint {
    let dstX = CGFloat(mImageView.width() / scale * srcX / CGFloat(mSublocation.width))
    let dstY = CGFloat(mImageView.height() / scale * (1.0 - srcY / CGFloat(mSublocation.height)))
    return CGPoint(x: dstX, y: dstY)
  }
  
  func stringToHex(srcStr: String) -> uint {
    var hexStr: UInt32 = 0
    let strScanner = Scanner(string: srcStr)
    strScanner.scanLocation = 1
    strScanner.scanHexInt32(&hexStr)
    return hexStr
  }
}

extension ViewController: NavigineCoreNavigationDelegate {
  
  func navigineCore(_ navigineCore: NavigineCore, didUpdate deviceInfo: NCDeviceInfo) {
    if let navError = deviceInfo.error {
      // If some error
      mCurPosition.isHidden = true
      mErrorView.mError = navError as NSError
      mErrorView.isHidden = false
    }
    else {
      mErrorView.isHidden = true
      mCurPosition.isHidden = deviceInfo.sublocation != mSublocation.id // Hide current position pin
      let radScale = mImageView.width() / CGFloat(mSublocation.width)
      mCurPosition.center = convertMetersToPixels(srcX: CGFloat(deviceInfo.x), srcY: CGFloat(deviceInfo.y), scale: mScrollView.zoomScale)
      mCurPosition.mRadius = CGFloat(deviceInfo.r) * radScale
      if mIsRouting {
        if let devicePath:NCRoutePath = deviceInfo.paths?.first as? NCRoutePath {
          let lastPoint = devicePath.points.last as? NCLocationPoint // Last point from route
          mImageView.viewWithTag(1)?.isHidden = lastPoint?.sublocation != mSublocation.id // Hide destination pin
          mEventView.isHidden = deviceInfo.sublocation != mSublocation.id // Hide event bar
          let distance = devicePath.lenght
          if distance < 1 {
            mEventView.setFinishTitle()
          }
          else {
            if let firstEvent = devicePath.events.first as? NCRouteEvent {
              mEventView.mEvent = firstEvent
            }
          }
          drawRoute(withPath: devicePath, andDistance: distance)
        }
      }
    }
  }
  
  func navigineCore(_ navigineCore: NavigineCore, didEnterZone zone: NCZone) {
    print("You are enter in zone ", zone.id)
  }
  
  func navigineCore(_ navigineCore: NavigineCore, didExitZone zone: NCZone) {
    print("You are leave zone ", zone.id)
  }

}

extension ViewController: UIScrollViewDelegate {
  
  func viewForZooming(in scrollView: UIScrollView) -> UIView? {
    return mImageView
  }
  
  func scrollViewDidZoom(_ scrollView: UIScrollView) {
    let currentZoom = mScrollView.zoomScale
    if currentZoom < mScrollView.minimumZoomScale || currentZoom > self.mScrollView.maximumZoomScale {
      return
    }
    else {
      // Stay pins at same sizes while zooming
      for obj in mImageView.subviews {
        if let pin = obj as? MapPin {
          pin.resizeMapPinWithZoom(currentZoom)
        }
      }
      mCurPosition.resizeLocationPinWithZoom(zoom: currentZoom) // Stay current position pin at same sizes while zooming
      // Stay destination marker pin at same sizes while zooming
      if let destMarker:UIImageView = mImageView.viewWithTag(1) as? UIImageView {
        destMarker.transform = CGAffineTransform(scaleX: 1.0 / currentZoom, y: 1.0 / currentZoom)
        destMarker.setCenterX(mRoutePath.currentPoint.x)
        destMarker.setCenterY(mRoutePath.currentPoint.y - ((destMarker.image?.size.height)! / 2) / currentZoom)
      }
    }
    
    // Another way to resize pins accordingly zoom
    /* CGAffineTransform transform = _imageView.transform; // Get current matrix
     CGAffineTransform invertedTransform = CGAffineTransformInvert(transform); // Inverse matrix
     _pressedPin.transform = invertedTransform; // Apply transformation to button
     _pressedPin.popUp.transform = invertedTransform; // Apply transformation to popup */
  }
}
