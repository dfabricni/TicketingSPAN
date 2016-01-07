//
//  SLFDevice.h
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFDevice : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *deviceType;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *deviceID;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
