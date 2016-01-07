//
//  SLFDevice.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFDevice.h"


NSString *const kSLFDeviceDeviceType = @"deviceType";
NSString *const kSLFDeviceUsername = @"username";
NSString *const kSLFDeviceDeviceID = @"deviceID";


@interface SLFDevice ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFDevice

@synthesize deviceType = _deviceType;
@synthesize username = _username;
@synthesize deviceID = _deviceID;


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
            self.deviceType = [self objectOrNilForKey:kSLFDeviceDeviceType fromDictionary:dict];
            self.username = [self objectOrNilForKey:kSLFDeviceUsername fromDictionary:dict];
            self.deviceID = [self objectOrNilForKey:kSLFDeviceDeviceID fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.deviceType forKey:kSLFDeviceDeviceType];
    [mutableDict setValue:self.username forKey:kSLFDeviceUsername];
    [mutableDict setValue:self.deviceID forKey:kSLFDeviceDeviceID];

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

    self.deviceType = [aDecoder decodeObjectForKey:kSLFDeviceDeviceType];
    self.username = [aDecoder decodeObjectForKey:kSLFDeviceUsername];
    self.deviceID = [aDecoder decodeObjectForKey:kSLFDeviceDeviceID];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_deviceType forKey:kSLFDeviceDeviceType];
    [aCoder encodeObject:_username forKey:kSLFDeviceUsername];
    [aCoder encodeObject:_deviceID forKey:kSLFDeviceDeviceID];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFDevice *copy = [[SLFDevice alloc] init];
    
    if (copy) {

        copy.deviceType = [self.deviceType copyWithZone:zone];
        copy.username = [self.username copyWithZone:zone];
        copy.deviceID = [self.deviceID copyWithZone:zone];
    }
    
    return copy;
}


@end
