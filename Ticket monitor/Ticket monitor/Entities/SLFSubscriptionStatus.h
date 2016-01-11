//
//  SLFSubscriptionStatus.h
//
//  Created by Administrator  on 11/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFSubscriptionStatus : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, assign) double syncStatus;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
