//  UIView+Additions.m
//  ButtonViewApp
//
//  Created by Dmitry Stavitsky on 08/07/2018.
//  Copyright © 2018 Navigine. All rights reserved.
//

import UIKit

extension Error {
  var code: Int { return (self as NSError).code }
  var domain: String { return (self as NSError).domain }
}

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

extension UIView {
  /**
   * Shortcut for frame.origin.x.
   *
   * Sets frame.origin.x = left
   */
  func left() -> CGFloat {
    return frame.origin.x
  }
  
  func setLeft(_ x: CGFloat) {
    var frame: CGRect = self.frame
    frame.origin.x = x
    self.frame = frame
  }
  
  /**
   * Shortcut for frame.origin.y
   *
   * Sets frame.origin.y = top
   */
  func top() -> CGFloat {
    return frame.origin.y
  }
  
  func setTop(_ y: CGFloat) {
    var frame: CGRect = self.frame
    frame.origin.y = y
    self.frame = frame
  }
  
  /**
   * Shortcut for frame.origin.x + frame.size.width
   *
   * Sets frame.origin.x = right - frame.size.width
   */
  func right() -> CGFloat {
    return frame.origin.x + frame.size.width
  }
  
  func setRight(_ right: CGFloat) {
    var frame: CGRect = self.frame
    frame.origin.x = right - frame.size.width
    self.frame = frame
  }
  
  /**
   * Shortcut for frame.origin.y + frame.size.height
   *
   * Sets frame.origin.y = bottom - frame.size.height
   */
  func bottom() -> CGFloat {
    return frame.origin.y + frame.size.height
  }
  
  func setBottom(_ bottom: CGFloat) {
    var frame: CGRect = self.frame
    frame.origin.y = bottom - frame.size.height
    self.frame = frame
  }
  
  /**
   * Shortcut for center.x
   *
   * Sets center.x = centerX
   */
  func centerX() -> CGFloat {
    return center.x
  }
  
  func setCenterX(_ centerX: CGFloat) {
    center = CGPoint(x: centerX, y: center.y)
  }
  
  /**
   * Shortcut for center.y
   *
   * Sets center.y = centerY
   */
  func centerY() -> CGFloat {
    return center.y
  }
  
  func setCenterY(_ centerY: CGFloat) {
    center = CGPoint(x: center.x, y: centerY)
  }
  
  /**
   * Shortcut for frame.size.width
   *
   * Sets frame.size.width = width
   */
  func width() -> CGFloat {
    return frame.size.width
  }
  
  func setWidth(_ width: CGFloat) {
    var frame: CGRect = self.frame
    frame.size.width = width
    self.frame = frame
  }
  
  /**
   * Shortcut for frame.size.height
   *
   * Sets frame.size.height = height
   */
  func height() -> CGFloat {
    return frame.size.height
  }
  
  func setHeight(_ height: CGFloat) {
    var frame: CGRect = self.frame
    frame.size.height = height
    self.frame = frame
  }
  
  
  /**
   * Return the status bar frame.
   */
  func statusBarFrame() -> CGRect {
    return UIApplication.shared.statusBarFrame
  }
  
  /**
   * Shortcut for frame.origin
   */
  func origin() -> CGPoint {
    return frame.origin
  }
  
  func setOrigin(_ origin: CGPoint) {
    var frame: CGRect = self.frame
    frame.origin = origin
    self.frame = frame
  }
  
  /**
   * Shortcut for frame.size
   */
  func size() -> CGSize {
    return frame.size
  }
  
  func setSize(_ size: CGSize) {
    var frame: CGRect = self.frame
    frame.size = size
    self.frame = frame
  }
  
  /**
   * Removes all subviews.
   */
  func removeAllSubviews() {
    while subviews.count > 0 {
      let child: UIView? = subviews.last
      child?.removeFromSuperview()
    }
  }
  
  /**
   * Removes all subviews with exeption.
   */
  func removeAllSubviews(withExeption exeption: UIView?) {
    var subviews = self.subviews
    if let anExeption = exeption {
      while let elementIndex = subviews.index(of: anExeption) { subviews.remove(at: elementIndex) }
    }
    while subviews.count > 0 {
      let child = subviews.last
      child?.removeFromSuperview()
      if let aChild = child {
        while let elementIndex = subviews.index(of: aChild) { subviews.remove(at: elementIndex) }
      }
    }
  }
}
