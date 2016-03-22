//
//  SLFSubscriptions.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFSubscription.h"


NSString *const kSLFSubscriptionsActive = @"Active";
NSString *const kSLFSubscriptionsToDelete = @"ToDelete";
NSString *const kSLFSubscriptionsRuleTypeID = @"RuleTypeID";
NSString *const kSLFSubscriptionsSubscriptionGroupID = @"SubscriptionGroupID";
NSString *const kSLFSubscriptionsLastCheckPoint = @"LastCheckPoint";
NSString *const kSLFSubscriptionsValueDisplayText = @"ValueDisplayText";
NSString *const kSLFSubscriptionsID = @"ID";
NSString *const kSLFSubscriptionsValue = @"Value";


@interface SLFSubscription ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFSubscription

@synthesize active = _active;
@synthesize toDelete = _toDelete;
@synthesize ruleTypeID = _ruleTypeID;
@synthesize subscriptionGroupID = _subscriptionGroupID;
@synthesize lastCheckPoint = _lastCheckPoint;
@synthesize valueDisplayText = _valueDisplayText;
@synthesize iDProperty = _iDProperty;
@synthesize value = _value;


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
            self.active = [[self objectOrNilForKey:kSLFSubscriptionsActive fromDictionary:dict] boolValue];
            self.toDelete = [[self objectOrNilForKey:kSLFSubscriptionsToDelete fromDictionary:dict] boolValue];
            self.ruleTypeID = [[self objectOrNilForKey:kSLFSubscriptionsRuleTypeID fromDictionary:dict] intValue];
            self.subscriptionGroupID = [self objectOrNilForKey:kSLFSubscriptionsSubscriptionGroupID fromDictionary:dict];
            self.lastCheckPoint = [self objectOrNilForKey:kSLFSubscriptionsLastCheckPoint fromDictionary:dict];
            self.valueDisplayText = [self objectOrNilForKey:kSLFSubscriptionsValueDisplayText fromDictionary:dict];
            self.iDProperty = [self objectOrNilForKey:kSLFSubscriptionsID fromDictionary:dict];
            self.value = [self objectOrNilForKey:kSLFSubscriptionsValue fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[NSNumber numberWithBool:self.active] forKey:kSLFSubscriptionsActive];
    [mutableDict setValue:[NSNumber numberWithBool:self.toDelete] forKey:kSLFSubscriptionsToDelete];
    [mutableDict setValue:[NSNumber numberWithInt:self.ruleTypeID] forKey:kSLFSubscriptionsRuleTypeID];
    [mutableDict setValue:self.subscriptionGroupID forKey:kSLFSubscriptionsSubscriptionGroupID];
    [mutableDict setValue:self.lastCheckPoint forKey:kSLFSubscriptionsLastCheckPoint];
    [mutableDict setValue:self.valueDisplayText forKey:kSLFSubscriptionsValueDisplayText];
    [mutableDict setValue:self.iDProperty forKey:kSLFSubscriptionsID];
    [mutableDict setValue:self.value forKey:kSLFSubscriptionsValue];

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

    self.active = [aDecoder decodeBoolForKey:kSLFSubscriptionsActive];
    self.toDelete = [aDecoder decodeBoolForKey:kSLFSubscriptionsToDelete];
    self.ruleTypeID = [aDecoder decodeIntForKey:kSLFSubscriptionsRuleTypeID];
    self.subscriptionGroupID = [aDecoder decodeObjectForKey:kSLFSubscriptionsSubscriptionGroupID];
    self.lastCheckPoint = [aDecoder decodeObjectForKey:kSLFSubscriptionsLastCheckPoint];
    self.valueDisplayText = [aDecoder decodeObjectForKey:kSLFSubscriptionsValueDisplayText];
    self.iDProperty = [aDecoder decodeObjectForKey:kSLFSubscriptionsID];
    self.value = [aDecoder decodeObjectForKey:kSLFSubscriptionsValue];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeBool:_active forKey:kSLFSubscriptionsActive];
    [aCoder encodeBool:_toDelete forKey:kSLFSubscriptionsToDelete];
    [aCoder encodeInt:_ruleTypeID forKey:kSLFSubscriptionsRuleTypeID];
    [aCoder encodeObject:_subscriptionGroupID forKey:kSLFSubscriptionsSubscriptionGroupID];
    [aCoder encodeObject:_lastCheckPoint forKey:kSLFSubscriptionsLastCheckPoint];
    [aCoder encodeObject:_valueDisplayText forKey:kSLFSubscriptionsValueDisplayText];
    [aCoder encodeObject:_iDProperty forKey:kSLFSubscriptionsID];
    [aCoder encodeObject:_value forKey:kSLFSubscriptionsValue];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFSubscription *copy = [[SLFSubscription alloc] init];
    
    if (copy) {

        copy.active = self.active;
        copy.toDelete = self.toDelete;
        copy.ruleTypeID = self.ruleTypeID;
        copy.subscriptionGroupID = [self.subscriptionGroupID copyWithZone:zone];
        copy.lastCheckPoint = [self.lastCheckPoint copyWithZone:zone];
        copy.valueDisplayText = [self.valueDisplayText copyWithZone:zone];
        copy.iDProperty = [self.iDProperty copyWithZone:zone];
        copy.value = [self.value copyWithZone:zone];
    }
    
    return copy;
}


@end
