//
//  SLFSubjects.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFSubject.h"


NSString *const kSLFSubjectsId = @"Id";
NSString *const kSLFSubjectsName = @"Name";


@interface SLFSubject ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFSubject

@synthesize ID = _subjectsIdentifier;
@synthesize name = _name;


+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
            self.ID = [[self objectOrNilForKey:kSLFSubjectsId fromDictionary:dict] intValue];
            self.name = [self objectOrNilForKey:kSLFSubjectsName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInt:self.ID] forKey:kSLFSubjectsId];
    [mutableDict setValue:self.name forKey:kSLFSubjectsName];

    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

- (NSString *)description 
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


#pragma mark - NSCoding Methods

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];

    self.ID = [aDecoder decodeIntForKey:kSLFSubjectsId];
    self.name = [aDecoder decodeObjectForKey:kSLFSubjectsName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInt:_subjectsIdentifier forKey:kSLFSubjectsId];
    [aCoder encodeObject:_name forKey:kSLFSubjectsName];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFSubject *copy = [[SLFSubject alloc] init];
    
    if (copy) {

        copy.ID = self.ID;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
