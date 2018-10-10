#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NCBeaconStatus) {
  NCBeaconOld = 0,
  NCBeaconNew,
  NCBeaconMod,
  NCBeaconDel
};

@interface NCBeacon : NSObject <NSCoding>

/**
 * Beacon's identifier
 */
@property (nonatomic, readonly) NSInteger id;

/**
 * Location Id to which the venue belongs
 */
@property (nonatomic, readonly) NSInteger location;

/**
 * Sublocation Id to which the venue belongs
 */
@property (nonatomic, readonly) NSInteger sublocation;

/**
 * Beacon's major and minor
 */
@property (nonatomic, readonly) NSInteger major;
@property (nonatomic, readonly) NSInteger minor;

/**
 * Beacon's UUID
 */
@property (nonatomic, copy, readonly) NSString *uuid;

/**
 * Beacon's name on map
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 * Beacon's coordinates on map
 */
@property (nonatomic, copy, readonly) NSNumber *x;
@property (nonatomic, copy, readonly) NSNumber *y;

@property (nonatomic, readonly) NCBeaconStatus status;

/**
 * Method for beacon validation
 *
 * @return YES if valid, NO othetwise
 */
- (BOOL) isValid;

@end
