//
//  SLFSubscriptionStatusesResponse.h
//
//  Created by Administrator  on 11/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFSubscriptionStatusesResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *subscriptions;
@property (nonatomic, strong) NSArray *groups;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
