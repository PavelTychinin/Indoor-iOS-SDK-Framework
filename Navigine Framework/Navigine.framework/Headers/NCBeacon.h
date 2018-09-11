#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, NCBeaconStatus) {
  NCBeaconOld = 0,
  NCBeaconNew,
  NCBeaconMod,
  NCBeaconDel
};

@interface NCBeacon : NSObject <NSCoding>

/**
 * Beacon's identifier
 */
@property (nonatomic) NSInteger id;

/**
 * Location Id to which the venue belongs
 */
@property (nonatomic) NSInteger location;

/**
 * Sublocation Id to which the venue belongs
 */
@property (nonatomic) NSInteger sublocation;

/**
 * Beacon's major and minor
 */
@property (nonatomic) NSInteger major;
@property (nonatomic) NSInteger minor;

/**
 * Beacon's UUID
 */
@property (nonatomic, copy) NSString *uuid;

/**
 * Beacon's name on map
 */
@property (nonatomic, copy) NSString *name;

/**
 * Beacon's coordinates on map
 */
@property (nonatomic, copy) NSNumber *x;
@property (nonatomic, copy) NSNumber *y;

@property (nonatomic) NCBeaconStatus status;

/**
 * Method for beacon validation
 *
 * @return YES if valid, NO othetwise
 */
- (BOOL) isValid;

@end
