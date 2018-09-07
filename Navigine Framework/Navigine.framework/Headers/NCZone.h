#import <Foundation/Foundation.h>

@class NCLocationPoint;

NS_ASSUME_NONNULL_BEGIN

@interface NCZone : NSObject <NSCoding>

/**
 * Zone's Identifier
 */
@property (nonatomic) int identifier;

/**
 * Location Id to which the zone belongs
 */
@property (nonatomic) int locationId;

/**
 * Sublocation Id to which the zone belongs
 */
@property (nonatomic) int sublocationId;

/**
 * Zone's name on map
 */
@property (nonatomic) NSString  *name;

/**
 * Zone's alias
 */
@property (nonatomic) NSString  *alias;

/**
 * Zone's color
 */
@property (nonatomic) NSString  *color;

/**
 * Zone's vertices
 */
@property (nonatomic, copy, readonly) NSArray<NCLocationPoint *> *points;

/**
 * Zone's geometric center
 */
@property (nonatomic, nullable, readonly) NCLocationPoint *center;

/**
 * Check that zone contains point
 *
 * @param point LocationPoint that you want to check for belonging to zone
 * @return YES if belongs, NO othetwise
 */
- (BOOL) containsPoint: (NCLocationPoint *) point;

/**
 * Add Vertex to zone
 *
 * @param LocationPoint that you want to add
 */
- (void) addZonePoint: (NCLocationPoint *) zonePoint;

/**
 * Remove all vertices
 */
- (void) clearZonePoints;

/**
 * Method for zone validation
 *
 * @return YES if valid, NO othetwise
 */
- (BOOL) isValid;

@end

NS_ASSUME_NONNULL_END
