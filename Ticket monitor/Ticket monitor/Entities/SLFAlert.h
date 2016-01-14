//
//  SLFAlert.h
//
//  Created by Administrator  on 14/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFAlert : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *body;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
