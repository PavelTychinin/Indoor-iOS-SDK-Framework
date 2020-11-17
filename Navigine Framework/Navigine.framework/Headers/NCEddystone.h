//
//  NCEddystone.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 01/03/16.
//  Copyright © 2016 Navigine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCLocationPoint.h"

typedef NS_ENUM(NSUInteger, NCEddystoneStatus) {
  NCEddystoneOld = 0,
  NCEddystoneNew,
  NCEddystoneMod,
  NCEddystoneDel
};

NS_ASSUME_NONNULL_BEGIN

@interface NCEddystone : NCLocationPoint

/**
 * Eddystone's identifier
 */
@property (nonatomic, readonly) NSInteger id;

/**
 * Eddystone's name on map
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * Eddystone's UUID
 */
@property (nonatomic, copy, readonly) NSString *namespaceId;

/**
 * Eddystone's UUID
 */
@property (nonatomic, copy, readonly) NSString *instanceId;

@property (nonatomic, readonly) NCEddystoneStatus status;

/**
 * Method for eddystone validation
 *
 * @return YES if valid, NO othetwise
 */
- (BOOL) isValid;

/**
 Method for comparing eddystones.

 @param otherEddystone Compared eddystone
 @return YES if equals, NO othetwise
 */
- (BOOL) isEqualToEddystone: (NCEddystone *)otherEddystone;

@end

NS_ASSUME_NONNULL_END
