//
//  SLFTicketDetail.m
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import "SLFTicketDetail.h"


NSString *const kSLFTicketDetailNote = @"Note";
NSString *const kSLFTicketDetailDetailID = @"DetailID";
NSString *const kSLFTicketDetailSubject = @"Subject";
NSString *const kSLFTicketDetailActionDesc = @"ActionDesc";
NSString *const kSLFTicketDetailSEQPRIORITY = @"SEQ_PRIORITY:";
NSString *const kSLFTicketDetailPDATE = @"PDATE";
NSString *const kSLFTicketDetailTicketID = @"TicketID";
NSString *const kSLFTicketDetailTicketDesc = @"TicketDesc";
NSString *const kSLFTicketDetailSEQSERVICE = @"SEQ_SERVICE";
NSString *const kSLFTicketDetailCOMPANY = @"COMPANY";
NSString *const kSLFTicketDetailDetailDesc = @"DetailDesc";


@interface SLFTicketDetail ()

- (id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict;

@end

@implementation SLFTicketDetail

@synthesize note = _note;
@synthesize detailID = _detailID;
@synthesize subject = _subject;
@synthesize actionDesc = _actionDesc;
@synthesize sEQPRIORITY = _sEQPRIORITY;
@synthesize pDATE = _pDATE;
@synthesize ticketID = _ticketID;
@synthesize ticketDesc = _ticketDesc;
@synthesize sEQSERVICE = _sEQSERVICE;
@synthesize cOMPANY = _cOMPANY;
@synthesize detailDesc = _detailDesc;


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
            self.note = [self objectOrNilForKey:kSLFTicketDetailNote fromDictionary:dict];
            self.detailID = [[self objectOrNilForKey:kSLFTicketDetailDetailID fromDictionary:dict] intValue];
            self.subject = [[self objectOrNilForKey:kSLFTicketDetailSubject fromDictionary:dict] intValue];
            self.actionDesc = [self objectOrNilForKey:kSLFTicketDetailActionDesc fromDictionary:dict];
            self.sEQPRIORITY = [[self objectOrNilForKey:kSLFTicketDetailSEQPRIORITY fromDictionary:dict] intValue];
            self.pDATE = [self objectOrNilForKey:kSLFTicketDetailPDATE fromDictionary:dict];
            self.ticketID = [[self objectOrNilForKey:kSLFTicketDetailTicketID fromDictionary:dict] intValue];
            self.ticketDesc = [self objectOrNilForKey:kSLFTicketDetailTicketDesc fromDictionary:dict];
            self.sEQSERVICE = [[self objectOrNilForKey:kSLFTicketDetailSEQSERVICE fromDictionary:dict] intValue];
            self.cOMPANY = [[self objectOrNilForKey:kSLFTicketDetailCOMPANY fromDictionary:dict] intValue];
            self.detailDesc = [self objectOrNilForKey:kSLFTicketDetailDetailDesc fromDictionary:dict];

    }
    
    return self;
    
}

- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.note forKey:kSLFTicketDetailNote];
    [mutableDict setValue:[NSNumber numberWithInt:self.detailID] forKey:kSLFTicketDetailDetailID];
    [mutableDict setValue:[NSNumber numberWithInt:self.subject] forKey:kSLFTicketDetailSubject];
    [mutableDict setValue:self.actionDesc forKey:kSLFTicketDetailActionDesc];
    [mutableDict setValue:[NSNumber numberWithInt:self.sEQPRIORITY] forKey:kSLFTicketDetailSEQPRIORITY];
    [mutableDict setValue:self.pDATE forKey:kSLFTicketDetailPDATE];
    [mutableDict setValue:[NSNumber numberWithInt:self.ticketID] forKey:kSLFTicketDetailTicketID];
    [mutableDict setValue:self.ticketDesc forKey:kSLFTicketDetailTicketDesc];
    [mutableDict setValue:[NSNumber numberWithInt: self.sEQSERVICE ]forKey:kSLFTicketDetailSEQSERVICE];
    [mutableDict setValue:[NSNumber numberWithInt:self.cOMPANY] forKey:kSLFTicketDetailCOMPANY];
    [mutableDict setValue:self.detailDesc forKey:kSLFTicketDetailDetailDesc];

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

    self.note = [aDecoder decodeObjectForKey:kSLFTicketDetailNote];
    self.detailID = [aDecoder decodeIntForKey:kSLFTicketDetailDetailID];
    self.subject = [aDecoder decodeIntForKey:kSLFTicketDetailSubject];
    self.actionDesc = [aDecoder decodeObjectForKey:kSLFTicketDetailActionDesc];
    self.sEQPRIORITY = [aDecoder decodeIntForKey:kSLFTicketDetailSEQPRIORITY];
    self.pDATE = [aDecoder decodeObjectForKey:kSLFTicketDetailPDATE];
    self.ticketID = [aDecoder decodeIntForKey:kSLFTicketDetailTicketID];
    self.ticketDesc = [aDecoder decodeObjectForKey:kSLFTicketDetailTicketDesc];
    self.sEQSERVICE = [aDecoder decodeIntForKey:kSLFTicketDetailSEQSERVICE];
    self.cOMPANY = [aDecoder decodeIntForKey:kSLFTicketDetailCOMPANY];
    self.detailDesc = [aDecoder decodeObjectForKey:kSLFTicketDetailDetailDesc];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_note forKey:kSLFTicketDetailNote];
    [aCoder encodeInt:_detailID forKey:kSLFTicketDetailDetailID];
    [aCoder encodeInt:_subject forKey:kSLFTicketDetailSubject];
    [aCoder encodeObject:_actionDesc forKey:kSLFTicketDetailActionDesc];
    [aCoder encodeInt:_sEQPRIORITY forKey:kSLFTicketDetailSEQPRIORITY];
    [aCoder encodeObject:_pDATE forKey:kSLFTicketDetailPDATE];
    [aCoder encodeInt:_ticketID forKey:kSLFTicketDetailTicketID];
    [aCoder encodeObject:_ticketDesc forKey:kSLFTicketDetailTicketDesc];
    [aCoder encodeInt:_sEQSERVICE forKey:kSLFTicketDetailSEQSERVICE];
    [aCoder encodeInt:_cOMPANY forKey:kSLFTicketDetailCOMPANY];
    [aCoder encodeObject:_detailDesc forKey:kSLFTicketDetailDetailDesc];
}

- (id)copyWithZone:(NSZone *)zone
{
    SLFTicketDetail *copy = [[SLFTicketDetail alloc] init];
    
    if (copy) {

        copy.note = [self.note copyWithZone:zone];
        copy.detailID = self.detailID;
        copy.subject = self.subject;
        copy.actionDesc = [self.actionDesc copyWithZone:zone];
        copy.sEQPRIORITY = self.sEQPRIORITY;
        copy.pDATE = [self.pDATE copyWithZone:zone];
        copy.ticketID = self.ticketID;
        copy.ticketDesc = [self.ticketDesc copyWithZone:zone];
        copy.sEQSERVICE = self.sEQSERVICE ;
        copy.cOMPANY = self.cOMPANY;
        copy.detailDesc = [self.detailDesc copyWithZone:zone];
    }
    
    return copy;
}


@end
