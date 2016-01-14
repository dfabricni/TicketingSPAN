//
//  SLFNotification.h
//
//  Created by Administrator  on 14/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLFAps;

@interface SLFNotification : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) SLFAps *aps;
@property (nonatomic, assign) double detailID;
@property (nonatomic, strong) NSString *shortDescription;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
