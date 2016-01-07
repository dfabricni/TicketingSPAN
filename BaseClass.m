//
//  BaseClass.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "BaseClass.h"
#import "Services.h"


NSString *const kBaseClassServices = @"services";
NSString *const kBaseClassMaxtimestamp = @"maxtimestamp";


@interface BaseClass ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation BaseClass

@synthesize services = _services;
@synthesize maxtimestamp = _maxtimestamp;


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
    NSObject *receivedServices = [dict objectForKey:kBaseClassServices];
    NSMutableArray *parsedServices = [NSMutableArray array];
    if ([receivedServices isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedServices) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedServices addObject:[Services modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedServices isKindOfClass:[NSDictionary class]]) {
       [parsedServices addObject:[Services modelObjectWithDictionary:(NSDictionary *)receivedServices]];
    }

    self.services = [NSArray arrayWithArray:parsedServices];
            self.maxtimestamp = [[self objectOrNilForKey:kBaseClassMaxtimestamp fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForServices = [NSMutableArray array];
    for (NSObject *subArrayObject in self.services) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForServices addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForServices addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForServices] forKey:kBaseClassServices];
    [mutableDict setValue:[NSNumber numberWithDouble:self.maxtimestamp] forKey:kBaseClassMaxtimestamp];

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

    self.services = [aDecoder decodeObjectForKey:kBaseClassServices];
    self.maxtimestamp = [aDecoder decodeDoubleForKey:kBaseClassMaxtimestamp];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_services forKey:kBaseClassServices];
    [aCoder encodeDouble:_maxtimestamp forKey:kBaseClassMaxtimestamp];
}

- (id)copyWithZone:(NSZone *)zone
{
    BaseClass *copy = [[BaseClass alloc] init];
    
    if (copy) {

        copy.services = [self.services copyWithZone:zone];
        copy.maxtimestamp = self.maxtimestamp;
    }
    
    return copy;
}


@end
