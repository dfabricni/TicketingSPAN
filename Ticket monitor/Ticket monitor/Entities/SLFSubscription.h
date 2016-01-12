//
//  SLFSubscriptions.h
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFSubscription : NSObject <NSCoding, NSCopying>

@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) int ruleTypeID;
@property (nonatomic, strong) NSString *subscriptionGroupID;
@property (nonatomic, strong) NSString *lastCheckPoint;
@property (nonatomic, strong) NSString *valueDisplayText;
@property (nonatomic, strong) NSString *iDProperty;
@property (nonatomic, strong) NSString *value;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
