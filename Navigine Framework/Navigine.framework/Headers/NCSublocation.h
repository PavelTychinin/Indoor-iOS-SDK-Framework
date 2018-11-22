//
//  NCSublocation.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 27/04/15.
//  Copyright (c) 2015 Navigine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCZone, NCBeacon, NCVenue, NCLocationPoint, NCGlobalPoint, UIImage;

NS_ASSUME_NONNULL_BEGIN

@interface NCSublocation : NSObject <NSCoding, NSCopying>

/**
 *  Sublocation id in personal account
 */
@property (nonatomic, readonly) NSInteger id;

/**
 * Location id in personal account
 */
@property (nonatomic, readonly) NSInteger location;

/**
 *  Location name in personal account
 */
@property (nonatomic, copy, readonly) NSString *name;

/**
 *  Name of svg image or nil if svg image not exists
 */
@property (nonatomic, copy, readonly) NSString *svgFile;

/**
 *  Name of png image or nil if png image not exists
 */
@property (nonatomic, copy, readonly) NSString *pngFile;

/**
 *  Name of jpg image or nil if jpg image not exists
 */
@property (nonatomic, copy, readonly) NSString *jpgFile; 

/**
 *  Data of svg image or nil if svg image not exists
 */
@property (nonatomic, readonly) NSData *svgImage;

/**
 *  Data of png image or nil if png image not exists
 */
@property (nonatomic, readonly) NSData *pngImage;

/**
 *  Data of jpg image or nil if jpg image not exists
 */
@property (nonatomic, readonly) NSData *jpgImage;

/**
 *  UImage of map or nil if image invalid
 */
@property (nonatomic, strong, nullable) UIImage *image;

/**
 *  Width of image in meters
 */
@property (nonatomic, readonly) float width;

/**
 *  Height of image in meters
 */
@property (nonatomic, readonly) float height;

/**
 *  Azimuth of image in degree
 */
@property (nonatomic, readonly) float azimuth;

/**
 *  GPS latitude
 */
@property (nonatomic, readonly) double latitude;

/**
 *  GPS longitude
 */
@property (nonatomic, readonly) double longitude;

/**
 *  Zones which sublocation contains
 */
@property (nonatomic, strong, readonly) NSArray<NCZone *> *zones;

/**
 *  Venues which sublocation contains
 */
@property (nonatomic, strong, readonly) NSArray<NCVenue *> *venues;

/**
 *  Beacons which sublocation contains
 */
@property (nonatomic, strong, readonly) NSArray<NCBeacon *> *beacons;

/**
 *  Function is used for getting zone at id
 *
 *  @param zoneId - Identifier of zone
 *  @return Zone object or nil
 */
- (NCZone *_Nullable) zoneWithId: (NSInteger) zoneId;

/**
 *  Validate sublocation
 */
- (BOOL) isValid;

/**
 * Convert GPS coordinates to local coordinates
 *
 * @param point LocationPoint that you want to convert
 */
- (NCGlobalPoint *) gpsFromLocal: (NCLocationPoint *) point;

/**
 * Convert local coordinates to GPS coordinates
 *
 * @param point GlobalPoint that you want to convert
 */
- (NCLocationPoint *) localFromGps: (NCGlobalPoint *) point;

@end

NS_ASSUME_NONNULL_END

