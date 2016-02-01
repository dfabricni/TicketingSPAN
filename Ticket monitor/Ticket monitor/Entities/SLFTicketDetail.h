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

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
