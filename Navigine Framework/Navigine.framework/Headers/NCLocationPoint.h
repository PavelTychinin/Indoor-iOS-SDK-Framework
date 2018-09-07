#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCLocationPoint : NSObject <NSCoding>

/**
 * Id of location
 */
@property (nonatomic, assign, readonly) NSInteger location;

/**
 * Id of slocation
 */
@property (nonatomic, assign, readonly) NSInteger sublocation;

/**
 * X coordinate of the location point within the sublocation (m)
 */
@property (nonatomic, strong, readonly) NSNumber  *x;

/**
 * Y coordinate of the location point within the sublocation (m)
 */
@property (nonatomic, strong, readonly) NSNumber  *y;

- (double) distanceTo: (NCLocationPoint *)point;

+ (NCLocationPoint *) pointWithLocation:(NSInteger)  location
                            sublocation:(NSInteger)  sublocation
                                      x:(NSNumber *) x
                                      y:(NSNumber *) y;

- (BOOL) isValid;

typedef NCLocationPoint NCLocalPoint;

@end
NS_ASSUME_NONNULL_END
