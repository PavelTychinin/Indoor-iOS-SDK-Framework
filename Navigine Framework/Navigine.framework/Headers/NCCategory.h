//
//  NCCategory.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 03/10/2017.
//  Copyright © 2017 Navigine. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NCCategory : NSObject <NSCoding, NSCopying>

/**
 * Category's identifier
 */
@property (nonatomic, readonly) NSInteger id;

/**
 * Category's name
 */
@property (nonatomic, copy, readonly) NSString * name;

/**
 * Convenience creation method.
 *
 * @param aIdentifier Identifier of category.
 * @param aName Name of category
 * @return An instance of NCCategory.
 */
+ (instancetype) categoryWithIdentifier: (NSInteger)aIdentifier
                                   name: (NSString *)aName DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");

/**
 * Initializes and returns a Category object using the provided Name and Identifier.
 */
- (instancetype) initWithIdentifier: (NSInteger)identifier
                               name: (NSString *)name NS_DESIGNATED_INITIALIZER DEPRECATED_MSG_ATTRIBUTE("Please don't use this method anymore");

- (nullable instancetype) initWithCoder: (NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

/**
 * Method for category validation
 *
 * @return YES if valid, NO othetwise
 */
- (BOOL) isValid;

@end

NS_ASSUME_NONNULL_END
