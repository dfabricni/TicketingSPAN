//
//  SLFSubjects.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFSubject.h"


NSString *const kSLFSubjectsId = @"Id";
NSString *const kSLFSubjectsName = @"Name";
NSString *const kSLFSubjectsDetail = @"Detail";

@interface SLFSubject ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFSubject

@synthesize ID = _subjectsIdentifier;
@synthesize name = _name;
@synthesize detail = _detail;


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
            self.detail= [self objectOrNilForKey:kSLFSubjectsDetail fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInt:self.ID] forKey:kSLFSubjectsId];
    [mutableDict setValue:self.name forKey:kSLFSubjectsName];
    [mutableDict setValue:self.detail forKey:kSLFSubjectsDetail];

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
    self.detail = [aDecoder decodeObjectForKey:kSLFSubjectsDetail];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInt:_subjectsIdentifier forKey:kSLFSubjectsId];
    [aCoder encodeObject:_name forKey:kSLFSubjectsName];
    [aCoder encodeObject:_detail forKey:kSLFSubjectsDetail];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFSubject *copy = [[SLFSubject alloc] init];
    
    if (copy) {

        copy.ID = self.ID;
        copy.name = [self.name copyWithZone:zone];
        copy.detail = [self.detail copyWithZone:zone];
    }
    
    return copy;
}


@end
