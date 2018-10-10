#import <Foundation/Foundation.h>

@class NCSublocation, NCZone, NCLocationlPoint;

NS_ASSUME_NONNULL_BEGIN

@interface NCLocation : NSObject<NSCoding>

/**
 *  Location id in personal account
 */
@property (nonatomic, readonly) NSInteger id;

/**
 *  Location name in personal account
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  Location description in personal account
 */
@property (nonatomic, copy, readonly) NSString *localDescription;

/**
 *  Location version
 */
@property (nonatomic, readonly) NSInteger version;

/**
 *  Array with sublocations of your location
 */
@property (nonatomic, strong, readonly) NSArray<NCSublocation *> *sublocations;

/**
 *  Is local modified Archive
 */
@property (nonatomic, readonly) BOOL modified;

+ (instancetype) locationWithIdentifier: (NSInteger) identifier
                                   name: (NSString *) name
                       localDescription: (NSString *) description
                                version: (NSInteger) version
                           sublocations: (NSArray *) sublocations;

- (instancetype) initWithIdentifier: (NSInteger) aIdentifier
                               name: (NSString *) aName
                   localDescription: (NSString *) aDescription
                            version: (NSInteger) aVersion
                       sublocations: (NSArray *) aSublocations;
/**
 *  Function is used for getting sublocation at id or nil error
 *
 *  @param sublocationId of sublocation
 *
 *  @return Sublocation object or nil
 */
- (NCSublocation *_Nullable) subLocationWithId: (NSInteger) sublocationId;

- (NCZone *_Nullable) zoneWithId: (NSInteger) zoneId;

- (NSArray<NCZone *> *) zonesContainingPoint: (NCLocationlPoint *) point;

- (BOOL) isValid;

@end

NS_ASSUME_NONNULL_END

