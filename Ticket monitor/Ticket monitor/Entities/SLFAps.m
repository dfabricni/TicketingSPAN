//
//  SLFAps.m
//
//  Created by Administrator  on 14/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFAps.h"
#import "SLFAlert.h"


NSString *const kSLFApsContentAvailable = @"content-available";
NSString *const kSLFApsAlert = @"alert";
NSString *const kSLFApsBadge = @"badge";
NSString *const kSLFApsSound = @"sound";


@interface SLFAps ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFAps

@synthesize contentAvailable = _contentAvailable;
@synthesize alert = _alert;
@synthesize badge = _badge;
@synthesize sound = _sound;


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
            self.contentAvailable = [self objectOrNilForKey:kSLFApsContentAvailable fromDictionary:dict];
            self.alert = [SLFAlert modelObjectWithDictionary:[dict objectForKey:kSLFApsAlert]];
            self.badge = [[self objectOrNilForKey:kSLFApsBadge fromDictionary:dict] doubleValue];
            self.sound = [self objectOrNilForKey:kSLFApsSound fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.contentAvailable forKey:kSLFApsContentAvailable];
    [mutableDict setValue:[self.alert dictionaryRepresentation] forKey:kSLFApsAlert];
    [mutableDict setValue:[NSNumber numberWithDouble:self.badge] forKey:kSLFApsBadge];
    [mutableDict setValue:self.sound forKey:kSLFApsSound];

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

    self.contentAvailable = [aDecoder decodeObjectForKey:kSLFApsContentAvailable];
    self.alert = [aDecoder decodeObjectForKey:kSLFApsAlert];
    self.badge = [aDecoder decodeDoubleForKey:kSLFApsBadge];
    self.sound = [aDecoder decodeObjectForKey:kSLFApsSound];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_contentAvailable forKey:kSLFApsContentAvailable];
    [aCoder encodeObject:_alert forKey:kSLFApsAlert];
    [aCoder encodeDouble:_badge forKey:kSLFApsBadge];
    [aCoder encodeObject:_sound forKey:kSLFApsSound];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFAps *copy = [[SLFAps alloc] init];
    
    if (copy) {

        copy.contentAvailable = [self.contentAvailable copyWithZone:zone];
        copy.alert = [self.alert copyWithZone:zone];
        copy.badge = self.badge;
        copy.sound = [self.sound copyWithZone:zone];
    }
    
    return copy;
}


@end
