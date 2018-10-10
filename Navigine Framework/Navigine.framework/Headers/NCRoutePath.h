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
                         routeEvents: (NSArray *) events;

- (instancetype) initWithLength: (float) length
                    routePoints: (NSArray *) points
                    routeEvents: (NSArray *) events NS_DESIGNATED_INITIALIZER;

- (nullable instancetype) initWithCoder: (NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

NS_ASSUME_NONNULL_END

- (BOOL) isValid;

@end
