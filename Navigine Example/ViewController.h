//
//  ViewController.h
//  Navigine Example
//
//  Created by Pavel Tychinin on 19/07/2017.
//  Copyright © 2017 Navigine. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapPin.h"

@interface ViewController : UIViewController <UIScrollViewDelegate, NavigineCoreDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *sv;

@property (nonatomic, strong) UIImageView *current;
@end


