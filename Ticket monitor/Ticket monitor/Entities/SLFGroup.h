//
//  SLFGroups.h
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFGroup : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *iDProperty;
@property (nonatomic, strong) NSString *groupOperation;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, assign) BOOL toDelete;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
