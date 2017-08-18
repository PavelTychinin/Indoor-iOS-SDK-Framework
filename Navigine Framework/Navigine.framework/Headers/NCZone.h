//
//  NCZone.h
//  NavigineSDK
//
//  Created by Pavel Tychinin on 25/07/2017.
//  Copyright © 2017 Navigine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NCVertex.h"

@interface NCZone : NSObject <NSCoding>

@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger sublocationId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *uuid;
@property (nonatomic, strong) NSString *color;
@property (nonatomic, strong) NSArray *points;

- (BOOL) containsPoint:(NCVertex *)point;

@end
