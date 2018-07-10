//
//  CurrentLocation.swift
//  Swift-New
//
//  Created by Dmitry Stavitsky on 08/07/2018.
//  Copyright © 2018 Navigine. All rights reserved.
//

import UIKit

class CurrentLocation : UIView {
  private var mPresisCircle = UIView()
  var mRadius: CGFloat = 0.0 {
    didSet {
      guard mRadius.isEqual(to: oldValue) else {
        let newFrame = CGRect(x:frame.width / 2.0 - mRadius / 2.0,
                              y: frame.size.height / 2.0 - mRadius / 2.0,
                              width: mRadius,
                              height: mRadius)
        mPresisCircle.frame = newFrame
        mPresisCircle.layer.cornerRadius = CGFloat(mRadius / 2.0)
        return
      }
    }
  }
  
  convenience init() {
    self.init(color: UIColor.red)
  }
  
  init(color: UIColor) {
    super.init(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
    
    // Init position point
    self.backgroundColor = color
    self.layer.borderColor = UIColor(white: 1.0, alpha: 1.0).cgColor
    self.layer.borderWidth = 2.0
    self.layer.cornerRadius = frame.size.height / 2.0
    
    // Init presision circle
    mPresisCircle = UIView(frame: CGRect.zero)
    mPresisCircle.clipsToBounds = true
    mPresisCircle.backgroundColor = UIColor.gray.withAlphaComponent(0.5)
    
    self.addSubview(mPresisCircle)
    self.isHidden = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func resizeLocationPinWithZoom(zoom: CGFloat) {
    transform = CGAffineTransform(scaleX: 1.0 / zoom, y: 1.0 / zoom)
  }
}
