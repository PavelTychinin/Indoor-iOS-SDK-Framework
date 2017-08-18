//
//  NCEvent.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 27/07/2017.
//  Copyright © 2017 Navigine. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NCEventType) {
  NCEventTypeUndefined = 0,
  NCEventTypeTurnLeft,
  NCEventTypeTurnRight,
  NCEventTypeTransition
};

@interface NCEvent : NSObject
@property (nonatomic, assign) float distance;
@property (nonatomic, assign) int value;
@property (nonatomic, assign) NCEventType type;
@end
