//
//  SLFTicketDetail.m
//
//  Created by Administrator  on 25/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFTicketDetail.h"


NSString *const kSLFTicketDetailDetailDescription = @"DetailDescription";
NSString *const kSLFTicketDetailDetailNote = @"DetailNote";
NSString *const kSLFTicketDetailAction = @"Action";
NSString *const kSLFTicketDetailTicketMasterDescription = @"TicketMasterDescription";
NSString *const kSLFTicketDetailGUID = @"GUID";
NSString *const kSLFTicketDetailCompanyID = @"CompanyID";
NSString *const kSLFTicketDetailTimestamp = @"Timestamp";
NSString *const kSLFTicketDetailPriorityID = @"PriorityID";
NSString *const kSLFTicketDetailTicketID = @"TicketID";
NSString *const kSLFTicketDetailServiceID = @"ServiceID";
NSString *const kSLFTicketDetailDatetime = @"Datetime";
NSString *const kSLFTicketDetailSubjectID = @"SubjectID";
NSString *const kSLFTicketDetailDatetimeInSeconds= @"DatetimeInSeconds";
NSString *const kSLFTicketDetailSubscriptionGroupID = @"SubscriptionGroupID";

NSString *const kSLFTicketDetailTicketTitle = @"TicketTitle";
NSString *const kSLFTicketDetailCompanyCode = @"CompanyCode";
NSString *const kSLFTicketDetailTicketAssignedTo = @"TicketAssignedTo";
NSString *const kSLFTicketDetailModifiedBy = @"ModifiedBy";
NSString *const kSLFTicketDetailSubscriptionGroupName = @"SubscriptionGroupName";



@interface SLFTicketDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFTicketDetail

@synthesize detailDescription = _detailDescription;
@synthesize detailNote = _detailNote;
@synthesize action = _action;
@synthesize ticketMasterDescription = _ticketMasterDescription;
@synthesize gUID = _gUID;
@synthesize companyID = _companyID;
@synthesize timestamp = _timestamp;
@synthesize priorityID = _priorityID;
@synthesize ticketID = _ticketID;
@synthesize serviceID = _serviceID;
@synthesize datetime = _datetime;
@synthesize subjectID = _subjectID;
@synthesize datetimeInSeconds = _datetimeInSeconds;
@synthesize subscriptionGroupID = _subscriptionGroupID;
@synthesize ticketTitle = _ticketTitle;
@synthesize companyCode = _companyCode;
@synthesize ticketAssignedTo = _ticketAssignedTo;
@synthesize modifiedBy = _modifiedBy;
@synthesize subscriptionGroupName = _subscriptionGroupName;


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
        self.detailDescription = [self objectOrNilForKey:kSLFTicketDetailDetailDescription fromDictionary:dict];
        self.detailNote = [self objectOrNilForKey:kSLFTicketDetailDetailNote fromDictionary:dict];
        self.action = [self objectOrNilForKey:kSLFTicketDetailAction fromDictionary:dict];
        self.ticketMasterDescription = [self objectOrNilForKey:kSLFTicketDetailTicketMasterDescription fromDictionary:dict];
        self.gUID = [self objectOrNilForKey:kSLFTicketDetailGUID fromDictionary:dict];
        self.companyID = [[self objectOrNilForKey:kSLFTicketDetailCompanyID fromDictionary:dict] intValue];
        self.timestamp = [[self objectOrNilForKey:kSLFTicketDetailTimestamp fromDictionary:dict] doubleValue];
        self.datetimeInSeconds = [[self objectOrNilForKey:kSLFTicketDetailDatetimeInSeconds fromDictionary:dict] doubleValue];
        self.priorityID = [[self objectOrNilForKey:kSLFTicketDetailPriorityID fromDictionary:dict] intValue];
        self.ticketID = [[self objectOrNilForKey:kSLFTicketDetailTicketID fromDictionary:dict] intValue];
        self.serviceID = [[self objectOrNilForKey:kSLFTicketDetailServiceID fromDictionary:dict] intValue];
        self.datetime = [self objectOrNilForKey:kSLFTicketDetailDatetime fromDictionary:dict];
        self.subjectID = [[self objectOrNilForKey:kSLFTicketDetailSubjectID fromDictionary:dict] intValue];
        self.subscriptionGroupID= [self objectOrNilForKey:kSLFTicketDetailSubscriptionGroupID fromDictionary:dict];
        self.ticketTitle= [self objectOrNilForKey:kSLFTicketDetailTicketTitle fromDictionary:dict];
        self.companyCode= [self objectOrNilForKey:kSLFTicketDetailCompanyCode fromDictionary:dict];
        self.ticketAssignedTo = [self objectOrNilForKey:kSLFTicketDetailTicketAssignedTo fromDictionary:dict];
        self.modifiedBy= [self objectOrNilForKey:kSLFTicketDetailModifiedBy fromDictionary:dict];
        self.subscriptionGroupName= [self objectOrNilForKey:kSLFTicketDetailSubscriptionGroupName fromDictionary:dict];
        
    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.detailDescription forKey:kSLFTicketDetailDetailDescription];
    [mutableDict setValue:self.detailNote forKey:kSLFTicketDetailDetailNote];
    [mutableDict setValue:self.action forKey:kSLFTicketDetailAction];
    [mutableDict setValue:self.ticketMasterDescription forKey:kSLFTicketDetailTicketMasterDescription];
    [mutableDict setValue:self.gUID forKey:kSLFTicketDetailGUID];
    [mutableDict setValue:[NSNumber numberWithInt:self.companyID] forKey:kSLFTicketDetailCompanyID];
    [mutableDict setValue:[NSNumber numberWithDouble:self.datetimeInSeconds] forKey:kSLFTicketDetailDatetimeInSeconds];
    [mutableDict setValue:[NSNumber numberWithDouble:self.timestamp] forKey:kSLFTicketDetailTimestamp];
    [mutableDict setValue:[NSNumber numberWithInt:self.priorityID] forKey:kSLFTicketDetailPriorityID];
    [mutableDict setValue:[NSNumber numberWithInt:self.ticketID] forKey:kSLFTicketDetailTicketID];
    [mutableDict setValue:[NSNumber numberWithInt:self.serviceID] forKey:kSLFTicketDetailServiceID];
    [mutableDict setValue:self.datetime forKey:kSLFTicketDetailDatetime];
    [mutableDict setValue:[NSNumber numberWithInt:self.subjectID] forKey:kSLFTicketDetailSubjectID];
    [mutableDict setValue:self.subscriptionGroupID forKey:kSLFTicketDetailSubscriptionGroupID];
    [mutableDict setValue:self.ticketTitle forKey:kSLFTicketDetailTicketTitle];
    [mutableDict setValue:self.companyCode forKey:kSLFTicketDetailCompanyCode];
    [mutableDict setValue:self.ticketAssignedTo forKey:kSLFTicketDetailTicketAssignedTo];
    [mutableDict setValue:self.modifiedBy forKey:kSLFTicketDetailModifiedBy];
    [mutableDict setValue:self.subscriptionGroupName forKey:kSLFTicketDetailSubscriptionGroupName];
    
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
    
    self.detailDescription = [aDecoder decodeObjectForKey:kSLFTicketDetailDetailDescription];
    self.detailNote = [aDecoder decodeObjectForKey:kSLFTicketDetailDetailNote];
    self.action = [aDecoder decodeObjectForKey:kSLFTicketDetailAction];
    self.ticketMasterDescription = [aDecoder decodeObjectForKey:kSLFTicketDetailTicketMasterDescription];
    self.gUID = [aDecoder decodeObjectForKey:kSLFTicketDetailGUID];
    self.companyID = [aDecoder decodeIntForKey:kSLFTicketDetailCompanyID];
    self.timestamp = [aDecoder decodeDoubleForKey:kSLFTicketDetailTimestamp];
    self.datetimeInSeconds = [aDecoder decodeDoubleForKey:kSLFTicketDetailDatetimeInSeconds];
    self.priorityID = [aDecoder decodeIntForKey:kSLFTicketDetailPriorityID];
    self.ticketID = [aDecoder decodeIntForKey:kSLFTicketDetailTicketID];
    self.serviceID = [aDecoder decodeIntForKey:kSLFTicketDetailServiceID];
    self.datetime = [aDecoder decodeObjectForKey:kSLFTicketDetailDatetime];
    self.subjectID = [aDecoder decodeIntForKey:kSLFTicketDetailSubjectID];
    self.subscriptionGroupID = [aDecoder decodeObjectForKey:kSLFTicketDetailSubscriptionGroupID];
    self.ticketTitle = [aDecoder decodeObjectForKey:kSLFTicketDetailTicketTitle];
    self.companyCode = [aDecoder decodeObjectForKey:kSLFTicketDetailCompanyCode];
    self.ticketAssignedTo = [aDecoder decodeObjectForKey:kSLFTicketDetailTicketAssignedTo];
    self.modifiedBy = [aDecoder decodeObjectForKey:kSLFTicketDetailModifiedBy];
    self.subscriptionGroupName = [aDecoder decodeObjectForKey:kSLFTicketDetailSubscriptionGroupName];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_detailDescription forKey:kSLFTicketDetailDetailDescription];
    [aCoder encodeObject:_detailNote forKey:kSLFTicketDetailDetailNote];
    [aCoder encodeObject:_action forKey:kSLFTicketDetailAction];
    [aCoder encodeObject:_ticketMasterDescription forKey:kSLFTicketDetailTicketMasterDescription];
    [aCoder encodeObject:_gUID forKey:kSLFTicketDetailGUID];
    [aCoder encodeInt:_companyID forKey:kSLFTicketDetailCompanyID];
    [aCoder encodeDouble:_timestamp forKey:kSLFTicketDetailTimestamp];
    [aCoder encodeDouble:_datetimeInSeconds forKey:kSLFTicketDetailDatetimeInSeconds];
    [aCoder encodeInt:_priorityID forKey:kSLFTicketDetailPriorityID];
    [aCoder encodeInt:_ticketID forKey:kSLFTicketDetailTicketID];
    [aCoder encodeInt:_serviceID forKey:kSLFTicketDetailServiceID];
    [aCoder encodeObject:_datetime forKey:kSLFTicketDetailDatetime];
    [aCoder encodeInt:_subjectID forKey:kSLFTicketDetailSubjectID];
    [aCoder encodeObject:_subscriptionGroupID forKey:kSLFTicketDetailSubscriptionGroupID];    
    [aCoder encodeObject:_ticketTitle forKey:kSLFTicketDetailTicketTitle];
    [aCoder encodeObject:_companyCode forKey:kSLFTicketDetailCompanyCode];
    [aCoder encodeObject:_ticketAssignedTo forKey:kSLFTicketDetailTicketAssignedTo];
    [aCoder encodeObject:_modifiedBy forKey:kSLFTicketDetailModifiedBy];
    [aCoder encodeObject:_subscriptionGroupName forKey:kSLFTicketDetailSubscriptionGroupName];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFTicketDetail *copy = [[SLFTicketDetail alloc] init];
    
    if (copy) {
        
        copy.detailDescription = [self.detailDescription copyWithZone:zone];
        copy.detailNote = [self.detailNote copyWithZone:zone];
        copy.action = [self.action copyWithZone:zone];
        copy.ticketMasterDescription = [self.ticketMasterDescription copyWithZone:zone];
        copy.gUID = [self.gUID copyWithZone:zone];
        copy.companyID = self.companyID;
        copy.timestamp = self.timestamp ;
        copy.datetimeInSeconds = self.datetimeInSeconds ;
        copy.priorityID = self.priorityID;
        copy.ticketID = self.ticketID;
        copy.serviceID = self.serviceID;
        copy.datetime = [self.datetime copyWithZone:zone];
        copy.subjectID = self.subjectID ;
        copy.subscriptionGroupID = [self.subscriptionGroupID copyWithZone:zone];
        copy.ticketTitle = [self.ticketTitle copyWithZone:zone];
        copy.companyCode = [self.companyCode copyWithZone:zone];
        copy.ticketAssignedTo = [self.ticketAssignedTo copyWithZone:zone];
        copy.modifiedBy = [self.modifiedBy copyWithZone:zone];
        copy.subscriptionGroupName = [self.subscriptionGroupName copyWithZone:zone];
        
    }
    
    return copy;
}


@end
