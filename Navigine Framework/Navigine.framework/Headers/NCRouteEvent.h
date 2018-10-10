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
@property (nonatomic, readonly) float distance;

/**
 * Event type. (Turn left, Turn right or sublocation change);
 */
@property (nonatomic, readonly) NCRouteEventType type;

/**
 * Rotation angle(in degrees)
 */
@property (nonatomic, readonly) int value;

+ (instancetype) routeEventWithDistance: (float) distance
                                  value: (int) value
                                   type: (NCRouteEventType) eventType;

- (instancetype) initWithDistance: (float) distance
                            value: (int) value
                             type: (NCRouteEventType) eventType NS_DESIGNATED_INITIALIZER;

- (instancetype) initWithCoder: (NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

- (BOOL) isValid;

@end
