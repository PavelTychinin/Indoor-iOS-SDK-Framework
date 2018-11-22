//
//  NCVenue.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 17/06/15.
//  Copyright (c) 2015 Navigine. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NCCategory, UIImage;

@interface NCVenue : NSObject <NSCoding, NSCopying>

/**
 * Identifier of venue
 */
@property(nonatomic, assign, readonly) NSInteger id;

/**
 * Location id of venue
 */
@property(nonatomic, assign, readonly) NSInteger location;

/**
 * Sublocation id of venue
 */
@property(nonatomic, assign, readonly) NSInteger sublocation;

/**
 * Venue's coordinates on map
 */
@property(nonatomic, copy, readonly) NSNumber *x;
@property(nonatomic, copy, readonly) NSNumber *y;

/**
 * Venue's name
 */
@property(nonatomic, copy, readonly) NSString *name;

/**
 * Venue's phone number
 */
@property(nonatomic, copy, readonly) NSString *phone;

/**
 * Other information about venue
 */
@property(nonatomic, copy, readonly) NSString *descript;

/**
 * Venue's alias
 */
@property(nonatomic, copy, readonly) NSString *alias;

/**
 * Venue's category(caffe, point of interest, etc...)
 */
@property(nonatomic, copy, readonly) NCCategory *category;

/**
 * Venue's image
 */
@property(nonatomic, strong, readonly) UIImage *image;

/**
 * Method for venue validation
 *
 * @return YES if valid, NO othetwise
 */
- (BOOL) isValid;

/**
 Method for comparing venues.
 
 @param otherVenue Compared Venue
 @return YES if equals, NO othetwise
 */
- (BOOL)isEqualToVenue: (NCVenue *)otherVenue;

@end
