#import <Foundation/Foundation.h>

@interface NCCategory : NSObject <NSCoding, NSCopying>

NS_ASSUME_NONNULL_BEGIN

/**
 * Category's identifier
 */
@property (nonatomic, readonly) NSInteger identifier;

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
                                   name: (NSString *)aName;

/**
 * Initializes and returns a Category object using the provided Name and Identifier.
 */
- (instancetype) initWithIdentifier: (NSInteger)identifier
                               name: (NSString *)name NS_DESIGNATED_INITIALIZER;

- (nullable instancetype) initWithCoder: (NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

NS_ASSUME_NONNULL_END

/**
 * Method for category validation
 *
 * @return YES if valid, NO othetwise
 */
- (BOOL) isValid;

@end
