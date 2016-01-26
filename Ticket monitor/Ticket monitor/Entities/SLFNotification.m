//
//  SLFNotification.m
//
//  Created by Administrator  on 14/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFNotification.h"
#import "SLFAps.h"


NSString *const kSLFNotificationAps = @"aps";
NSString *const kSLFNotificationGUID = @"GUID";
NSString *const kSLFNotificationShortDescription = @"shortDescription";


@interface SLFNotification ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFNotification

@synthesize aps = _aps;
@synthesize GUID = _GUID;
@synthesize shortDescription = _shortDescription;


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
            self.aps = [SLFAps modelObjectWithDictionary:[dict objectForKey:kSLFNotificationAps]];
            self.GUID = [self objectOrNilForKey:kSLFNotificationGUID fromDictionary:dict] ;
            self.shortDescription = [self objectOrNilForKey:kSLFNotificationShortDescription fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:[self.aps dictionaryRepresentation] forKey:kSLFNotificationAps];
    [mutableDict setValue:self.GUID forKey:kSLFNotificationGUID];
    [mutableDict setValue:self.shortDescription forKey:kSLFNotificationShortDescription];

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

    self.aps = [aDecoder decodeObjectForKey:kSLFNotificationAps];
    self.GUID = [aDecoder decodeObjectForKey:kSLFNotificationGUID];
    self.shortDescription = [aDecoder decodeObjectForKey:kSLFNotificationShortDescription];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_aps forKey:kSLFNotificationAps];
    [aCoder encodeObject:_GUID forKey:kSLFNotificationGUID];
    [aCoder encodeObject:_shortDescription forKey:kSLFNotificationShortDescription];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFNotification *copy = [[SLFNotification alloc] init];
    
    if (copy) {

        copy.aps = [self.aps copyWithZone:zone];
        copy.GUID = self.GUID;
        copy.shortDescription = [self.shortDescription copyWithZone:zone];
    }
    
    return copy;
}


@end
