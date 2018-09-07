#import <Foundation/Foundation.h>

@class NCCategory, UIImage;

@interface NCVenue : NSObject <NSCoding, NSCopying>

/**
 * Identifier of venue
 */
@property(nonatomic, assign, readonly) NSInteger identifier;

/**
 * Location id of venue
 */
@property(nonatomic, assign, readonly) NSInteger locationId;

/**
 * Sublocation id of venue
 */
@property(nonatomic, assign, readonly) NSInteger sublocationId;

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
@property(nonatomic, copy, readonly) NSString *describe;

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

@end
