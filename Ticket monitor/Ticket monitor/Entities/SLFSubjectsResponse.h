//
//  SLFSubjectsResponse.h
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFSubjectsResponse : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSArray *subjects;
@property (nonatomic, assign) double maxtimestamp;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
