#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NCRouteEventType) {
  NCRouteEventTypeUndefined = 0,
  NCRouteEventTypeTurnLeft,
  NCRouteEventTypeTurnRight,
  NCRouteEventTypeTransition
};

@interface NCRouteEvent : NSObject <NSCoding>

/**
 * Distance from the beginning of the path to the current route event (in meters)
 */
@property (nonatomic, assign) float distance;

/**
 * Event type. (Turn left, Turn right or sublocation change);
 */
@property (nonatomic, assign) NCRouteEventType type;
@property (nonatomic, assign) int value;

- (BOOL) isValid;
@end
