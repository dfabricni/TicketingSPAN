//
//  Services.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "Services.h"


NSString *const kServicesId = @"Id";
NSString *const kServicesName = @"Name";


@interface Services ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation Services

@synthesize servicesIdentifier = _servicesIdentifier;
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
            self.servicesIdentifier = [[self objectOrNilForKey:kServicesId fromDictionary:dict] doubleValue];
            self.name = [self objectOrNilForKey:kServicesName fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithDouble:self.servicesIdentifier] forKey:kServicesId];
    [mutableDict setValue:self.name forKey:kServicesName];

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

    self.servicesIdentifier = [aDecoder decodeDoubleForKey:kServicesId];
    self.name = [aDecoder decodeObjectForKey:kServicesName];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeDouble:_servicesIdentifier forKey:kServicesId];
    [aCoder encodeObject:_name forKey:kServicesName];
}

- (id)copyWithZone:(NSZone *)zone
{
    Services *copy = [[Services alloc] init];
    
    if (copy) {

        copy.servicesIdentifier = self.servicesIdentifier;
        copy.name = [self.name copyWithZone:zone];
    }
    
    return copy;
}


@end
