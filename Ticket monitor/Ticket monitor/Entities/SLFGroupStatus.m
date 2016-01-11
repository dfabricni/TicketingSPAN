//
//  SLFGroups.m
//
//  Created by Administrator  on 11/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFGroupStatus.h"


NSString *const kSLFGroupStatusID = @"ID";
NSString *const kSLFGroupsStatusSyncStatus = @"SyncStatus";


@interface SLFGroupStatus ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFGroupStatus

@synthesize ID = _iDProperty;
@synthesize syncStatus = _syncStatus;


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
            self.ID = [self objectOrNilForKey:kSLFGroupStatusID fromDictionary:dict];
            self.syncStatus = [[self objectOrNilForKey:kSLFGroupsStatusSyncStatus fromDictionary:dict] doubleValue];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.ID forKey:kSLFGroupStatusID];
    [mutableDict setValue:[NSNumber numberWithDouble:self.syncStatus] forKey:kSLFGroupsStatusSyncStatus];

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

    self.ID = [aDecoder decodeObjectForKey:kSLFGroupStatusID];
    self.syncStatus = [aDecoder decodeDoubleForKey:kSLFGroupsStatusSyncStatus];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_iDProperty forKey:kSLFGroupStatusID];
    [aCoder encodeDouble:_syncStatus forKey:kSLFGroupsStatusSyncStatus];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFGroupStatus *copy = [[SLFGroupStatus alloc] init];
    
    if (copy) {

        copy.ID = [self.ID copyWithZone:zone];
        copy.syncStatus = self.syncStatus;
    }
    
    return copy;
}


@end
