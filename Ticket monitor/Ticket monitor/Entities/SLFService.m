//
//  SLFServices.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFService.h"


NSString *const kSLFServicesId = @"Id";
NSString *const kSLFServicesName = @"Name";
NSString *const kSLFServicesDetail = @"Detail";


@interface SLFService ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFService

@synthesize ID = _servicesIdentifier;
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
            self.ID = [[self objectOrNilForKey:kSLFServicesId fromDictionary:dict] intValue];
            self.name = [self objectOrNilForKey:kSLFServicesName fromDictionary:dict];
            self.detail = [self objectOrNilForKey:kSLFServicesDetail fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithInt:self.ID] forKey:kSLFServicesId];
    [mutableDict setValue:self.name forKey:kSLFServicesName];
    [mutableDict setValue:self.detail forKey:kSLFServicesDetail];

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

    self.ID = [aDecoder decodeIntForKey:kSLFServicesId];
    self.name = [aDecoder decodeObjectForKey:kSLFServicesName];
    self.detail = [aDecoder decodeObjectForKey:kSLFServicesDetail];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeInt:_servicesIdentifier forKey:kSLFServicesId];
    [aCoder encodeObject:_name forKey:kSLFServicesName];
    [aCoder encodeObject:_detail forKey:kSLFServicesDetail];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFService *copy = [[SLFService alloc] init];
    
    if (copy) {

        copy.ID = self.ID;
        copy.name = [self.name copyWithZone:zone];
        copy.detail = [self.detail copyWithZone:zone];
    }
    
    return copy;
}


@end
