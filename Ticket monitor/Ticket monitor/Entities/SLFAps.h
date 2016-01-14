//
//  SLFAps.h
//
//  Created by Administrator  on 14/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SLFAlert;

@interface SLFAps : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *contentAvailable;
@property (nonatomic, strong) SLFAlert *alert;
@property (nonatomic, assign) double badge;
@property (nonatomic, assign) id sound;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
