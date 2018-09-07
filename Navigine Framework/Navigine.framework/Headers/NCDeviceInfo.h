#import <Foundation/Foundation.h>
<<<<<<< HEAD
=======
#import "NCLocationPoint.h"
#import "NCGlobalPoint.h"
#import "NCZone.h"
>>>>>>> e713c16d573b27ab7cd55bedefd166f4cbb63036

@class NCLocationPoint, NCGlobalPoint, NCZone, NCRoutePath;

typedef NS_ENUM(NSInteger, NCNavigationError) {
  NCIncorrectClient    = 1,
  NCNoSolution         = 4,
  NCNoBeacons          = 8,
  NCIncorrectBMP       = 10,
  NCIncorrectGP        = 20,
  NCIncorrectXMLParams = 21
};

@interface NCDeviceInfo : NSObject <NSCoding, NSCopying>

/**
 * Device UUID
 */
@property (nonatomic, copy, readonly, nonnull) NSString *identifier;

/**
 * Device measuring time (in milliseconds);
 */
@property (nonatomic, copy, readonly, nonnull) NSDate *time;

/**
 * Id of the location where the user is located
 */
@property (nonatomic, assign, readonly) NSInteger locationId;

/**
 * Id of the sublocation where the user is located
 */
@property (nonatomic, assign, readonly) NSInteger sublocationId;

/**
 * X device position on map(in meters)
 */
@property (nonatomic, assign, readonly) float x;

/**
 * X device position on map(relative coordinates)
 */
@property (nonatomic, assign, readonly) float kx;

/**
 * Y device position on map(in meters)
 */
@property (nonatomic, assign, readonly) float y;

/**
 * Y device position on map(relative coordinates)
 */
@property (nonatomic, assign, readonly) float ky;

/**
 * Trusting radius of the current device position within the sub-location;
 */
@property (nonatomic, assign, readonly) float r;

/**
 * Device azimuth angle (in degrees)
 */
@property (nonatomic, assign, readonly) float azimuth;

/**
 * Device latitude and longitude
 */
@property (nonatomic, assign, readonly) double latitude;
@property (nonatomic, assign, readonly) double longitude;

/**
 * Device paths from the current position to the target points
 * or nil if target points are not defined (see NCRoutePath class)
 */
@property (nonatomic, strong, readonly, nullable) NSArray<NCRoutePath *> *paths;

/**
 * Current list of sublocation zones where the device belongs
 * or nil if no such zones exists (see NCZone class)
 */
@property (nonatomic, strong, readonly, nullable) NSArray<NCZone *> *zones;

/**
 * Navigation error or nil if navigation successful
 */
@property (nonatomic, copy, readonly, nullable) NSError *error;

@property (nonatomic, readonly, nullable) NCLocationPoint *locationPoint;
@property (nonatomic, readonly, nullable) NCGlobalPoint *globalPoint;

- (BOOL) isInsideZoneWithId:    (NSInteger) id;
- (BOOL) isInsideZoneWithAlias: (NSString *) alias;

- (BOOL) isValid;

@end
