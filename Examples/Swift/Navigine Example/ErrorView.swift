//
//  ErrorView.m
//  Navigine
//
//  Created by Dmitry Stavitsky on 08/07/2018.
//  Copyright © 2018 Navigine. All rights reserved.
//

import UIKit

class ErrorView : UILabel {
  var mError = NSError() {
    didSet{
      guard mError.isEqual(oldValue) else {
        let defautError = "Navigation unavailable!\n" + "Error " + String(mError.code)
        switch (mError.code) {
        case 1:
          self.text = defautError + ": Incorrect Client"
        case 4:
          self.text = defautError + ": No solution"
        case 8:
          self.text = defautError + ": No beacons found"
        case 10:
          self.text = defautError + ": Incorrect BMP"
        case 20:
          self.text = defautError + ": Incorrect GP"
        case 21:
          self.text = defautError + ": Incorrect XML Params"
        default:
          self.text = defautError + ": Unknown error"
        }
        return
      }
    }
  }
  
  override init(frame rect: CGRect) {
    super.init(frame: rect)
    self.numberOfLines = 0
    self.textColor = UIColor.white
    self.backgroundColor = UIColor.red.withAlphaComponent(0.7)
    self.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 24)
    self.textAlignment = .center
    self.adjustsFontSizeToFitWidth = true
    self.isHidden = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
