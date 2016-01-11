//
//  SLFSubscriptionStatusesResponse.m
//
//  Created by Administrator  on 11/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFSubscriptionStatusesResponse.h"
#import "SLFSubscriptionStatus.h"
#import "SLFGroupStatus.h"


NSString *const kSLFSubscriptionStatusesResponseSubscriptions = @"subscriptions";
NSString *const kSLFSubscriptionStatusesResponseGroups = @"groups";


@interface SLFSubscriptionStatusesResponse ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFSubscriptionStatusesResponse

@synthesize subscriptions = _subscriptions;
@synthesize groups = _groups;


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
    NSObject *receivedSLFSubscriptions = [dict objectForKey:kSLFSubscriptionStatusesResponseSubscriptions];
    NSMutableArray *parsedSLFSubscriptions = [NSMutableArray array];
    if ([receivedSLFSubscriptions isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSLFSubscriptions) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSLFSubscriptions addObject:[SLFSubscriptionStatus modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSLFSubscriptions isKindOfClass:[NSDictionary class]]) {
       [parsedSLFSubscriptions addObject:[SLFSubscriptionStatus modelObjectWithDictionary:(NSDictionary *)receivedSLFSubscriptions]];
    }

    self.subscriptions = [NSArray arrayWithArray:parsedSLFSubscriptions];
    NSObject *receivedSLFGroups = [dict objectForKey:kSLFSubscriptionStatusesResponseGroups];
    NSMutableArray *parsedSLFGroups = [NSMutableArray array];
    if ([receivedSLFGroups isKindOfClass:[NSArray class]]) {
        for (NSDictionary *item in (NSArray *)receivedSLFGroups) {
            if ([item isKindOfClass:[NSDictionary class]]) {
                [parsedSLFGroups addObject:[SLFGroupStatus modelObjectWithDictionary:item]];
            }
       }
    } else if ([receivedSLFGroups isKindOfClass:[NSDictionary class]]) {
       [parsedSLFGroups addObject:[SLFGroupStatus modelObjectWithDictionary:(NSDictionary *)receivedSLFGroups]];
    }

    self.groups = [NSArray arrayWithArray:parsedSLFGroups];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    NSMutableArray *tempArrayForSubscriptions = [NSMutableArray array];
    for (NSObject *subArrayObject in self.subscriptions) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForSubscriptions addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForSubscriptions addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForSubscriptions] forKey:kSLFSubscriptionStatusesResponseSubscriptions];
    NSMutableArray *tempArrayForGroups = [NSMutableArray array];
    for (NSObject *subArrayObject in self.groups) {
        if([subArrayObject respondsToSelector:@selector(dictionaryRepresentation)]) {
            // This class is a model object
            [tempArrayForGroups addObject:[subArrayObject performSelector:@selector(dictionaryRepresentation)]];
        } else {
            // Generic object
            [tempArrayForGroups addObject:subArrayObject];
        }
    }
    [mutableDict setValue:[NSArray arrayWithArray:tempArrayForGroups] forKey:kSLFSubscriptionStatusesResponseGroups];

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

    self.subscriptions = [aDecoder decodeObjectForKey:kSLFSubscriptionStatusesResponseSubscriptions];
    self.groups = [aDecoder decodeObjectForKey:kSLFSubscriptionStatusesResponseGroups];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_subscriptions forKey:kSLFSubscriptionStatusesResponseSubscriptions];
    [aCoder encodeObject:_groups forKey:kSLFSubscriptionStatusesResponseGroups];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFSubscriptionStatusesResponse *copy = [[SLFSubscriptionStatusesResponse alloc] init];
    
    if (copy) {

        copy.subscriptions = [self.subscriptions copyWithZone:zone];
        copy.groups = [self.groups copyWithZone:zone];
    }
    
    return copy;
}


@end
