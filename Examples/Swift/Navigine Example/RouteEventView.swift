//
//  RouteEventView.swift
//  Swift-New
//
//  Created by Dmitry Stavitsky on 08/07/2018.
//  Copyright © 2018 Navigine. All rights reserved.
//

import UIKit
import Navigine

class RouteEventView: UILabel {
  private var mEventTitle = UILabel()
  private var mEventSubTitle = UILabel()
  var mCancelBtn = UIButton() // Cancel route button
  var mEvent: NCRouteEvent = NCRouteEvent() {
    didSet {
      guard mEvent.isEqual(oldValue) else {
        mEventTitle.text = String(format: "%.1f%@", mEvent.distance, "m")
        switch mEvent.type {
        case NCRouteEventType.undefined:
          mEventSubTitle.text = "Undefined event!"
        case NCRouteEventType.turnLeft:
          mEventSubTitle.text = "Turn left"
        case NCRouteEventType.turnRight:
          mEventSubTitle.text = "Turn right"
        case NCRouteEventType.transition:
          mEventSubTitle.text = "Cange floor"
        }
        return
      }
    }
  }
  
  override init(frame rect: CGRect) {
    super.init(frame: rect)
    backgroundColor = UIColor.white
    addBottomBorder(with: UIColor.lightGray, andWidth: 1.0)
    
    // Setup button
    mCancelBtn.frame = CGRect(x: frame.size.width - 50,
                              y: frame.size.height / 4.0,
                              width: 40,
                              height: 40)
    mCancelBtn.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    mCancelBtn.layer.cornerRadius = mCancelBtn.frame.size.height / 2.0
    
    // Set image for cancel button
    let btnImg = UIImage(named: "cancelRouteBtn")
    mCancelBtn.setImage(btnImg, for: .normal)
    
    // Setup title
    mEventTitle = UILabel(frame: CGRect(x: 0.0,
                                        y: 0.0,
                                        width: frame.size.width,
                                        height: frame.size.height / 2.0))
    mEventTitle.textColor = UIColor.black
    mEventTitle.backgroundColor = UIColor.clear
    mEventTitle.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24.0)
    mEventTitle.textAlignment = .center
    mEventTitle.adjustsFontSizeToFitWidth = true
    
    // Setup subtitle
    mEventSubTitle = UILabel(frame: CGRect(x: 0.0,
                                           y: frame.size.height / 2.0,
                                           width: frame.size.width,
                                           height: frame.size.height / 3.0))
    mEventSubTitle.textColor = UIColor.gray
    mEventSubTitle.backgroundColor = UIColor.clear
    mEventSubTitle.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16.0)
    mEventSubTitle.textAlignment = .center
    mEventSubTitle.adjustsFontSizeToFitWidth = true
    
    self.isUserInteractionEnabled = true
    self.addSubview(mEventTitle)
    self.addSubview(mEventSubTitle)
    self.addSubview(mCancelBtn)
    self.isHidden = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setFinishTitle() {
    mEventTitle.text = "Less than 1 meter"
    mEventSubTitle.text = "You are reached your place!"
  }
  
  // Add buttom border to general view
  func addBottomBorder(with color: UIColor?, andWidth borderWidth: CGFloat) {
    let border = UIView()
    border.backgroundColor = color
    border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
    border.frame = CGRect(x: 0, y: frame.size.height - borderWidth, width: frame.size.width, height: borderWidth)
    addSubview(border)
  }
}
