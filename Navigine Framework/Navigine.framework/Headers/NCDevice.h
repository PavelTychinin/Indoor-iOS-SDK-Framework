//
//  NCDevice.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 08/02/2017.
//  Copyright © 2017 Navigine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NCNetworkStatus) {
  NCNotReachable = 0,
  NCReachableViaWiFi,
  NCReachableViaWWAN
};

@protocol NCCentralServiceDelegate;

@interface NCDevice : NSObject

+ (NCDevice *) device;

@property (nonatomic, strong, readonly) NSString              *deviceId;
@property (nonatomic, strong, readonly) NSString              *osVersion;
@property (nonatomic, strong, readonly) NSString              *model;
@property (nonatomic, strong, readonly) NSDictionary          *wifiInfo;
@property (nonatomic, assign, readonly) CLAuthorizationStatus authorizationStatus;
@property (nonatomic, assign, readonly) CBManagerState        centralManagerState;
@property (nonatomic, assign, readonly) UIApplicationState    applicationState;
@property (nonatomic, assign, readonly) NCNetworkStatus       networkStatus;

@end
