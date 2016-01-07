//
//  SLFSubscriptionsResponse.h
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFSubscriptionsResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *subscriptions;
@property (nonatomic, strong) NSArray *groups;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
