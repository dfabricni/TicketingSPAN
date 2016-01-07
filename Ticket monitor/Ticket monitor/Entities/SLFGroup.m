//
//  SLFGroups.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFGroup.h"


NSString *const kSLFGroupsID = @"ID";
NSString *const kSLFGroupsGroupOperation = @"GroupOperation";
NSString *const kSLFGroupsName = @"Name";
NSString *const kSLFGroupsActive = @"Active";


@interface SLFGroup()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFGroup

@synthesize iDProperty = _iDProperty;
@synthesize groupOperation = _groupOperation;
@synthesize name = _name;
@synthesize active = _active;


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
            self.iDProperty = [self objectOrNilForKey:kSLFGroupsID fromDictionary:dict];
            self.groupOperation = [self objectOrNilForKey:kSLFGroupsGroupOperation fromDictionary:dict];
            self.name = [self objectOrNilForKey:kSLFGroupsName fromDictionary:dict];
            self.active = [[self objectOrNilForKey:kSLFGroupsActive fromDictionary:dict] boolValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.iDProperty forKey:kSLFGroupsID];
    [mutableDict setValue:self.groupOperation forKey:kSLFGroupsGroupOperation];
    [mutableDict setValue:self.name forKey:kSLFGroupsName];
    [mutableDict setValue:[NSNumber numberWithBool:self.active] forKey:kSLFGroupsActive];

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

    self.iDProperty = [aDecoder decodeObjectForKey:kSLFGroupsID];
    self.groupOperation = [aDecoder decodeObjectForKey:kSLFGroupsGroupOperation];
    self.name = [aDecoder decodeObjectForKey:kSLFGroupsName];
    self.active = [aDecoder decodeBoolForKey:kSLFGroupsActive];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_iDProperty forKey:kSLFGroupsID];
    [aCoder encodeObject:_groupOperation forKey:kSLFGroupsGroupOperation];
    [aCoder encodeObject:_name forKey:kSLFGroupsName];
    [aCoder encodeBool:_active forKey:kSLFGroupsActive];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFGroup *copy = [[SLFGroup alloc] init];
    
    if (copy) {

        copy.iDProperty = [self.iDProperty copyWithZone:zone];
        copy.groupOperation = [self.groupOperation copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.active = self.active;
    }
    
    return copy;
}


@end
