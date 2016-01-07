//
//  SLFServicesResponse.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFServicesResponse.h"
#import "SLFService.h"


NSString *const kSLFServicesResponseServices = @"services";
NSString *const kSLFServicesResponseMaxtimestamp = @"maxtimestamp";


@interface SLFServicesResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFServicesResponse

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
    NSObject *receivedSLFServices = [dict objectForKey:kSLFServicesResponseServices];
    NSMutableArray *parsedSLFServices = [NSMutableArray array];
    if ([receivedSLFServices isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSLFServices) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSLFServices addObject:[SLFService modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSLFServices isKindOfClass:[NSDictionary class]]) {
       [parsedSLFServices addObject:[SLFService modelObjectWithDictionary:(NSDictionary *)receivedSLFServices]];
    }

    self.services = [NSArray arrayWithArray:parsedSLFServices];
            self.maxtimestamp = [[self objectOrNilForKey:kSLFServicesResponseMaxtimestamp fromDictionary:dict] doubleValue];

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
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForServices] forKey:kSLFServicesResponseServices];
    [mutableDict setValue:[NSNumber numberWithDouble:self.maxtimestamp] forKey:kSLFServicesResponseMaxtimestamp];

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

    self.services = [aDecoder decodeObjectForKey:kSLFServicesResponseServices];
    self.maxtimestamp = [aDecoder decodeDoubleForKey:kSLFServicesResponseMaxtimestamp];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_services forKey:kSLFServicesResponseServices];
    [aCoder encodeDouble:_maxtimestamp forKey:kSLFServicesResponseMaxtimestamp];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFServicesResponse *copy = [[SLFServicesResponse alloc] init];
    
    if (copy) {

        copy.services = [self.services copyWithZone:zone];
        copy.maxtimestamp = self.maxtimestamp;
    }
    
    return copy;
}


@end
