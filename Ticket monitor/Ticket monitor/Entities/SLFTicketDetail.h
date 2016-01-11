//
//  SLFTicketDetail.h
//
//  Created by Administrator  on 07/01/16
//  Copyright (c) 2016 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface SLFTicketDetail : NSObject <NSCoding, NSCopying>

@property (nonatomic, strong) NSString * note;
@property (nonatomic, assign) int detailID;
@property (nonatomic, assign) int subject;
@property (nonatomic, strong) NSString *actionDesc;
@property (nonatomic, assign) int sEQPRIORITY;
@property (nonatomic, strong) NSString *pDATE;
@property (nonatomic, assign) int ticketID;
@property (nonatomic, strong) NSString *ticketDesc;
@property (nonatomic, assign) int sEQSERVICE;
@property (nonatomic, assign) int cOMPANY;
@property (nonatomic, strong) NSString *detailDesc;

+ (instancetype)modelObjectWithDictionary:(NSDictionary *)dict;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)dictionaryRepresentation;

@end
