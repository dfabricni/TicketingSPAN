//
//  SLFTicketDetail.h
//
//  Created by Administrator  on 25/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFTicketDetail : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString *detailDescription;
@property (nonatomic, strong) NSString *detailNote;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, strong) NSString *ticketMasterDescription;
@property (nonatomic, strong) NSString *gUID;
@property (nonatomic, assign) int companyID;
@property (nonatomic, assign) double timestamp;
@property (nonatomic, assign) double datetimeInSeconds;
@property (nonatomic, assign) int priorityID;
@property (nonatomic, assign) int ticketID;
@property (nonatomic, assign) int serviceID;
@property (nonatomic, strong) NSString *datetime;
@property (nonatomic, assign) int subjectID;
@property (nonatomic, strong) NSString *subscriptionGroupID;
@property (nonatomic, assign) BOOL read;
@property (nonatomic, strong) NSString *ticketTitle;
@property (nonatomic, strong) NSString *companyCode;
@property (nonatomic, strong) NSString *ticketAssignedTo;
@property (nonatomic, strong) NSString *modifiedBy;
@property (nonatomic, strong) NSString *subscriptionGroupName;
@property (nonatomic, strong) NSString *status;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
