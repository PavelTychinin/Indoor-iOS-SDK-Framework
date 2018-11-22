//
//  NCRoutePath.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 29/03/2017.
//  Copyright © 2017 Navigine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCRouteEvent, NCLocationPoint;

@interface NCRoutePath : NSObject<NSCoding>

NS_ASSUME_NONNULL_BEGIN

/**
 * Sequence of route events on the route path (see class NCRouteEvent)
 */
@property (nonatomic, readonly) NSArray<NCRouteEvent *> *events;

/**
 * Sequence of path points (see class NCLocationPoint)
 */
@property (nonatomic, readonly) NSArray<NCLocationPoint *> *points;

/**
 * Full path length (in meters)
 */
@property (nonatomic, readonly) float lenght;

+ (instancetype) routePathWithLength: (float) length
                         routePoints: (NSArray *) points
                         routeEvents: (NSArray *) events DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");

- (instancetype) initWithLength: (float) length
                    routePoints: (NSArray *) points
                    routeEvents: (NSArray *) events NS_DESIGNATED_INITIALIZER DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");

- (nullable instancetype) initWithCoder: (NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

- (BOOL) isValid;

NS_ASSUME_NONNULL_END

@end
