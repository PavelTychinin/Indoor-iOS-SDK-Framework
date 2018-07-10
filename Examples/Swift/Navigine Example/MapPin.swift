//
//  MapPin.swift
//  Swift-New
//
//  Created by Dmitry Stavitsky on 08/07/2018.
//  Copyright © 2018 Navigine. All rights reserved.
//

import UIKit
import Navigine

class MapPin: UIButton {
  var mPopUp = UIButton();
  var mVenue = NCVenue();
  
  init(venue: NCVenue) {
    super.init(frame: CGRect.zero)
    self.mVenue = venue
    
    // Init map pin with venue's centre
    let ctrVenue = CGPoint(x: CGFloat(truncating: mVenue.x), y: CGFloat(truncating: mVenue.y))
    self.center = ctrVenue
    
    // Set image to venue
    let venImg = UIImage(named: "elmVenueIcon")
    self.setImage(venImg, for: .normal)
    layer.zPosition = 5.0 // For overlap path curve
    
    // Add venue's popup title
    mPopUp = UIButton(frame: CGRect.zero)
    mPopUp.setTitle(mVenue.name, for: .normal)
    guard let label = mPopUp.titleLabel else {return}
    label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 30.0)
    label.textColor = UIColor.white
    label.textAlignment = .center
    mPopUp.backgroundColor = UIColor(hex: 0xce8951)
    mPopUp.clipsToBounds = false
    mPopUp.layer.cornerRadius = 10.0
    mPopUp.sizeToFit()
    mPopUp.frame.size.width += 20.0
    
    // Add down arrow to label
    let labelCaret = UIImageView(image: UIImage(named: "elmBubbleArrowOrange"))
    labelCaret.setCenterX(mPopUp.width() / 2.0)
    
    // Hide gap between label and arrow
    labelCaret.setCenterY(mPopUp.height() + labelCaret.height() / 2.0 - 0.5)
    mPopUp.addSubview(labelCaret)
    mPopUp.isHidden = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func resizeMapPinWithZoom(_ zoom: CGFloat) {
    if let imgView = self.imageView {
      let imgHeight = imgView.height() / 2.0
      transform = CGAffineTransform(scaleX: 1.0 / zoom, y: 1.0 / zoom)
      mPopUp.transform = CGAffineTransform(scaleX: 1.0 / zoom, y: 1.0 / zoom)
      mPopUp.setBottom(self.top() - imgHeight / zoom)
    }
  }
}
