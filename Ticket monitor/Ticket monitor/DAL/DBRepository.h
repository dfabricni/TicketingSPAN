//
//  DBRepository.h
//  Ticket monitor
//
//  Created by Administrator on 18/12/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DataModels.h"


@interface DBRepository : NSObject




@property(atomic,strong)  FMDatabase * DB;

-(NSString*) getCodeItemName:(NSString*) codeName  identifer:(int) identifier;

-(NSMutableArray *) getAllCompanies:(NSString*) searchStr;

-(NSMutableArray *) getAllSubjects:(NSString*) searchStr;

-(NSMutableArray *) getAllServices:(NSString*) searchStr;

-(NSMutableArray *) getAllRuleTypes;

-(void) saveSettings:(SLFSettings*) settings;

-(SLFSettings *) getSettings;


+(void) prepareSqlLiteFile;

-(NSMutableArray *) getFeedsGroupedByCompany;
-(NSMutableArray *) getFeedsGroupedByTicket;

-(void) deleteGroup:(NSString*) groupID;
-(NSMutableArray *) getAllGroups;

-(NSMutableArray *) getAllSubscriptionsForGroup:(NSString*) groupId;

-(NSMutableArray *) getExistingSubscriptionsTypes:(NSString*) groupId;;

-(NSMutableArray *) getAllSubscriptionsForSync;

-(NSMutableArray *) getAllGroupsForSync;

-(NSMutableArray *) getAllDetails;

-(NSMutableArray *) getDetailsForTicket:(int) ticketID;

-(NSMutableArray *) getDetailsForSubscription:(NSString*) subscriptionGroupID;

-(NSMutableArray *) getDetailsForCompany:(int) companyID;

-(NSMutableArray *) getDetailsGroupedByTickets;
-(NSMutableArray *) getDetailsGroupedByCompanies;
-(NSMutableArray *) getDetailsGroupedBySubscriptions;


-(SLFTicketDetail *) getTicketDetail:(NSString*) guid;

-(SLFGroup*) getGroup:(NSString*) groupID;

-(void) deleteAllFeeds;

-(void) saveGroup:(SLFGroup*) group syncStatus:(int) syncStatus;

-(void) saveSubscription:(SLFSubscription*) subscription syncStatus:(int) syncStatus;

//-(void) deleteAllsubscriptionsForGroup:(NSString*) groupID;

-(void) saveTicketDetail:(SLFTicketDetail*) ticketDetail;

-(void) markAllAsSynced;

-(void) deleteAllMarkedForDeletionAndSynced;
-(void) disableAllSubscriptionsForGroup:(NSString*) groupID;
-(void) enableAllSubscriptionsForGroup:(NSString*) groupID;
-(void) markAllSubscriptionsToDeleteForGroup:(NSString*) groupID;



-(void) markTicketAsRead:(NSString*)guid;

-(void) markAllAsRead;
-(BOOL) checkUnsynced;

-(void) saveCompany:(SLFCompany*) company;
-(void) saveService:(SLFService*) service;
-(void) saveSubject:(SLFSubject*) subject;
-(double) findMaxTimestamp;

-(NSString*) findMaxTimestampVer2;


@end
