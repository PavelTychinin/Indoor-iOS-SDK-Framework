#import <Foundation/Foundation.h>
#import "NCLocationPoint.h"
#import "NCRouteEvent.h"

@interface NCRoutePath : NSObject

/**
 * Sequence of route events on the route path (see class NCRouteEvent)
 */
@property (nonatomic, strong, nonnull) NSArray *events;

/**
 * Sequence of path points (see class NCLocationPoint)
 */
@property (nonatomic, strong, nonnull) NSArray *points;

/**
 * Full path length (in meters)
 */
@property (nonatomic, assign) float lenght;

- (BOOL) isValid;

@end
