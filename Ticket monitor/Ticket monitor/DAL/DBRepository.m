//
//  DBRepository.m
//  Ticket monitor
//
//  Created by Administrator on 18/12/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import "DBRepository.h"
#import "FMDatabase.h"
#import <Foundation/Foundation.h>
#import "DataModels.h"

@implementation DBRepository

-(id) init{
    
    if ( self = [super init] ) {

    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"DBVersion"];
        
    NSString * dbFileName = [NSString stringWithFormat:@"/SLFDB-%@.rdb",dbVersion];
    NSString * dbPath = [documentsDirectory stringByAppendingString:dbFileName];
    
   self.DB = [FMDatabase databaseWithPath:dbPath];
   
    	
//wwß
        return self;
    }
    else
        return nil;
    
}



+(void) prepareSqlLiteFile
{
      NSString *dbVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"DBVersion"];
    
    NSString * dbFileName = [NSString stringWithFormat:@"/SLFDB-%@.rdb",dbVersion];
    

    
    // copy sql lite file if we decide
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SLFDB.rdb"];
    
    NSString * documentsDBFilePath = [documentsDirectory stringByAppendingString:dbFileName];
    
    NSError *error = nil;

    //delte old one
    if([[NSFileManager defaultManager] fileExistsAtPath:documentsDBFilePath isDirectory:false]){
     
        // file is of same version, so don't do anything
        return;
      
    }else{
        // delete all rdb files in documentsDirectory
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSArray *fileArray = [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:nil];
        for (NSString *filename in fileArray)  {
            
            [fileMgr removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
        }
    }
    
  
    
if([[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:documentsDBFilePath error:&error]){
    NSLog(@"Default file successfully copied over.");
  } else {
    NSLog(@"Error description-%@ \n", [error localizedDescription]);
    NSLog(@"Error reason-%@", [error localizedFailureReason]);
  }


    
}


-(NSString*) getCodeItemName:(NSString*) codeName  identifer:(int) identifier;
{
   NSString * name = nil;
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:[NSString stringWithFormat: @"SELECT * FROM %@  where ID = %d", codeName, identifier   ]];
    while ([s next]) {
        
        name = [s stringForColumn:@"Name"];
    }
    
    [s close];
    
    [self.DB close];
    
    return name;
}

-(NSMutableArray *) getAllCompanies:(NSString*) searchStr
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    
    NSString * query = nil;
    
    if([searchStr isEqualToString:@""] || !searchStr ){
        query = @"SELECT * FROM Company order by Name";
    }else
    {
        query = [NSString stringWithFormat:@"SELECT * FROM Company where Name like '%@%%' order by Name",searchStr ];
    }
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:query];
    while ([s next]) {
        SLFCompany * company = [[SLFCompany alloc] init];
        
        company.ID = [s intForColumn:@"ID"];
        company.name = [s stringForColumn:@"Name"];
        
        [items addObject:company];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
    
}




-(NSMutableArray *) getAllSubjects:(NSString*) searchStr
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSString * query = nil;
    
    if([searchStr isEqualToString:@""] || !searchStr ){
        query = @"SELECT * FROM Subject order by Name";
    }else
    {
        query = [NSString stringWithFormat:@"SELECT * FROM Subject where Name like '%@%%' order by Name",searchStr ];
    }
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:query];    while ([s next]) {
        SLFSubject * subject = [[SLFSubject alloc] init];
        
        subject.ID = [s intForColumn:@"ID"];
        subject.name = [s stringForColumn:@"Name"];
        
        [items addObject:subject];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
    
}

-(NSMutableArray *) getAllServices:(NSString*) searchStr;
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    NSString * query = nil;
    
    if([searchStr isEqualToString:@""] || !searchStr ){
        query = @"SELECT * FROM Service order by Name";
    }else
    {
        query = [NSString stringWithFormat:@"SELECT * FROM Service where Name like '%@%%' order by Name",searchStr ];
    }
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:query];
    while ([s next]) {
        SLFService * service = [[SLFService alloc] init];
        
        service.ID = [s intForColumn:@"ID"];
        service.name = [s stringForColumn:@"Name"];
        
        [items addObject:service];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
    
}

-(NSMutableArray *) getExistingSubscriptionsTypes:(NSString*) groupId;
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:[NSString stringWithFormat: @"SELECT RuleTypeID FROM Subscription where Active = 1 and SubscriptionGroupID = '%@'", groupId ]];
    while ([s next]) {
        
      int ruleTypeID = [s intForColumn:@"RuleTypeID"];
        [items addObject: [NSNumber numberWithInt: ruleTypeID ]];
        
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
}

-(NSMutableArray *) getAllRuleTypes
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM RuleType where Active = 1"];
    while ([s next]) {
        SLFRuleType * ruleType = [[SLFRuleType alloc] init];
        
        ruleType.ID = [s intForColumn:@"ID"];
        ruleType.name = [s stringForColumn:@"Name"];
        ruleType.code = [s stringForColumn:@"Code"];
        
        [items addObject:ruleType];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
    
}

-(SLFSettings *) getSettings{
    
     SLFSettings * settings = [[SLFSettings alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM Settings limit 1"];
    while ([s next]) {
        
        settings.ServicesTimestamp = [s doubleForColumn:@"ServicesTimestamp"];
        settings.CompaniesTimestamp= [s doubleForColumn:@"CompaniesTimestamp"];
        settings.SubjectsTimestamp = [s doubleForColumn:@"SubjectsTimestamp"];
        settings.FeedsTimestamp = [s doubleForColumn:@"FeedsTimestamp"];
       
    }
    
    [s close];
    
    
    [self.DB close];
    
    return settings;
    
}

-(void) saveSettings:(SLFSettings*) setting{
   
    [self.DB open];
    
    [self.DB executeUpdate:@"update settings set ServicesTimestamp = ? , SubjectsTimestamp = ? , CompaniesTimestamp = ? , FeedsTimestamp = ?" , [NSNumber numberWithDouble:setting.ServicesTimestamp ], [NSNumber numberWithDouble:setting.SubjectsTimestamp ],[NSNumber numberWithDouble:setting.CompaniesTimestamp ],[NSNumber numberWithDouble:setting.FeedsTimestamp ],nil];
    
    [self.DB close];
    
}


-(NSMutableArray *) getAllGroups{
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM SubscriptionGroup where Active = 1"];
    while ([s next]) {
        SLFGroup * group = [[SLFGroup alloc] init];
        
        group.iDProperty = [s stringForColumn:@"ID"];
        group.name = [s stringForColumn:@"Name"];
        group.groupOperation = [s stringForColumn:@"GroupOperation"];
        group.active = [s boolForColumn:@"Active"];
        
        [items addObject:group];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
}


-(NSMutableArray *) getAllGroupsForSync{
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM SubscriptionGroup where  SyncStatus = 0"];
    while ([s next]) {
        SLFGroup * group = [[SLFGroup alloc] init];
        
        group.iDProperty = [s stringForColumn:@"ID"];
        group.name = [s stringForColumn:@"Name"];
        group.groupOperation = [s stringForColumn:@"GroupOperation"];
        group.active = [s boolForColumn:@"Active"];
        
        [items addObject:group];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
}

-(NSMutableArray *) getAllSubscriptionsForGroup:(NSString*) groupId{

    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM Subscription	 where Active = 1 and SubscriptionGroupID = ?", groupId];
    while ([s next]) {
        SLFSubscription * subscription = [[SLFSubscription alloc] init];
        
        subscription.iDProperty = [s stringForColumn:@"ID"];
        subscription.subscriptionGroupID = [s stringForColumn:@"SubscriptionGroupID"];
        subscription.ruleTypeID = [s doubleForColumn:@"RuleTypeID"];
        subscription.lastCheckPoint = [s stringForColumn:@"LastCheckPoint"];
        subscription.value = [s stringForColumn:@"Value"];
        subscription.valueDisplayText = [s stringForColumn:@"ValueDisplayText"];
        subscription.active = [s boolForColumn:@"Active"];
        
        [items addObject:subscription];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
}


-(NSMutableArray *) getAllSubscriptionsForSync{
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM Subscription	 where  SyncStatus  =  0"];
    while ([s next]) {
        SLFSubscription * subscription = [[SLFSubscription alloc] init];
        
        subscription.iDProperty = [s stringForColumn:@"ID"];
        subscription.subscriptionGroupID = [s stringForColumn:@"SubscriptionGroupID"];
        subscription.ruleTypeID = [s doubleForColumn:@"RuleTypeID"];
        subscription.lastCheckPoint = [s stringForColumn:@"LastCheckPoint"];
        subscription.value = [s stringForColumn:@"Value"];
        subscription.valueDisplayText = [s stringForColumn:@"ValueDisplayText"];
        subscription.active = [s boolForColumn:@"Active"];
        
        [items addObject:subscription];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
}


-(void) saveGroup:(SLFGroup*) group syncStatus:(int) syncStatus{
    
    
    [self.DB open];
  
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"update SubscriptionGroup set Name = '%@' , GroupOperation = '%@' , Active = %d, SyncStatus = %d where ID = '%@' " , group.name , group.groupOperation, group.active,syncStatus, group.iDProperty ]];
    
    // jsut in case then make insert
    
     [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into SubscriptionGroup(Id,Name,GroupOperation,Active,SyncStatus) values('%@','%@','%@',%d,%d)" , group.iDProperty ,group.name , group.groupOperation, group.active ,syncStatus]];
    
   
    [self.DB close];
    
}

-(void) saveSubscription:(SLFSubscription*) subscription syncStatus:(int) syncStatus
{

    [self.DB open];
    
     [self.DB executeUpdate:[NSString stringWithFormat:@"update Subscription set SubscriptionGroupID = '%@' , RuleTypeID = %d , LastCheckPoint = '%@', Value='%@', ValueDisplayText = '%@' , Active = %d, SyncStatus = %d where ID = '%@' " , subscription.subscriptionGroupID, subscription.ruleTypeID, subscription.lastCheckPoint, subscription.value, subscription.valueDisplayText, subscription.active, syncStatus,subscription.iDProperty]];
    
  
    
    // jsut in case then make insert
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into Subscription(ID,SubscriptionGroupID,RuleTypeID,LastCheckPoint,Value,ValueDisplayText ,Active,SyncStatus) values('%@','%@',%d,'%@','%@','%@',%d,%d)", subscription.iDProperty, subscription.subscriptionGroupID,subscription.ruleTypeID,subscription.lastCheckPoint,subscription.value,subscription.valueDisplayText ,subscription.active,syncStatus]];
    
    [self.DB close];
    
}

-(void) saveTicketDetail:(SLFTicketDetail *)ticketDetail
{
    [self.DB open];
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"update TicketDetail set TicketID = %D, SubjectID = %d, DetailDescription = '%@', ActionDescription = '%@', CompanyID = %d, Datetime = '%@', Priority = %d, ServiceID = %d, DetailNote = '%@',  TicketDescription = '%@' , ServerTimestamp = %f , DatetimeInSeconds = %f , SubscriptionGroupID = '%@'  where GUID = '%@' " , ticketDetail.ticketID, ticketDetail.subjectID, ticketDetail.detailDescription, ticketDetail.action, ticketDetail.companyID, ticketDetail.datetime, ticketDetail.priorityID, ticketDetail.serviceID, ticketDetail.detailNote, ticketDetail.ticketMasterDescription,ticketDetail.timestamp, ticketDetail.datetimeInSeconds, ticketDetail.subscriptionGroupID, ticketDetail.gUID]];
    
    // jsut in case then make insert
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into TicketDetail(GUID,TicketID, SubjectID, DetailDescription, ActionDescription, CompanyID, Datetime, Priority, ServiceID, DetailNote,  TicketDescription,ServerTimestamp,DateTimeInSeconds,SubscriptionGroupID) values('%@',%d,%d,'%@','%@',%d,'%@',%d,%d,'%@','%@',%f,%f,'%@')", ticketDetail.gUID, ticketDetail.ticketID, ticketDetail.subjectID, ticketDetail.detailDescription, ticketDetail.action, ticketDetail.companyID, ticketDetail.datetime, ticketDetail.priorityID, ticketDetail.serviceID, ticketDetail.detailNote, ticketDetail.ticketMasterDescription,ticketDetail.timestamp, ticketDetail.datetimeInSeconds,ticketDetail.subscriptionGroupID]];
    
    [self.DB close];
    
    
}
-(SLFGroup*) getGroup:(NSString*) groupID
{
    SLFGroup * group = nil;

    [self.DB open];
    NSString * query =[NSString stringWithFormat: @"SELECT * FROM SubscriptionGroup where ID = '%@'",[groupID uppercaseString] ];
   
    FMResultSet *s = [self.DB executeQuery:query];
    while ([s next]) {
      
        group = [[SLFGroup alloc] init];        
        group.iDProperty = [s stringForColumn:@"ID"];
        group.name = [s stringForColumn:@"Name"];
        group.groupOperation = [s stringForColumn:@"GroupOperation"];
        group.active = [s boolForColumn:@"Active"];
        
        
    }
    
    [s close];
    
    
    [self.DB close];
    
    return group;
}
-(NSMutableArray*) getAllDetails
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM TicketDetail	 order by DatetimeInSeconds desc limit 500"];
    while ([s next]) {
       SLFTicketDetail* detail =  [[SLFTicketDetail alloc] init];
        
        detail.gUID = [s stringForColumn:@"GUID"];
        detail.detailDescription  = [s stringForColumn:@"DetailDescription"];
        detail.detailNote  = [s stringForColumn:@"DetailNote"];
        detail.ticketMasterDescription  = [s stringForColumn:@"TicketDescription"];
        detail.subjectID  = [s intForColumn:@"SubjectID"];
        detail.companyID  = [s intForColumn:@"CompanyID"];
        detail.serviceID  = [s intForColumn:@"ServiceID"];
        detail.priorityID  = [s intForColumn:@"Priority"];
        detail.datetime  = [s stringForColumn:@"Datetime"];
        detail.ticketID  = [s intForColumn:@"TicketID"];
        detail.action  = [s stringForColumn:@"ActionDescription"];
        detail.subscriptionGroupID  = [s stringForColumn:@"SubscriptionGroupID"];
        detail.read = [s boolForColumn:@"Read"];
       /*
        NSMutableDictionary * detail = [NSMutableDictionary dictionary];
        
    detail[@"GUID"] = [s stringForColumn:@"GUID"];
    detail[@"DetailDescription"] = [s stringForColumn:@"DetailDescription"];
    detail[@"Datetime"] = [s stringForColumn:@"Datetime"];
    detail[@"ticketID"] = @([s intForColumn:@"ticketID"]);
        */
       
       [items addObject:detail];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
}
-(SLFTicketDetail *) getTicketDetail:(NSString*) guid
{
    SLFTicketDetail * detail = nil;
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:[NSString stringWithFormat: @"SELECT * FROM TicketDetail	 where GUID = '%@'", guid ]];
    while ([s next]) {
       
        detail =  [[SLFTicketDetail alloc] init];
        
        detail.gUID = [s stringForColumn:@"GUID"];
        detail.detailDescription  = [s stringForColumn:@"DetailDescription"];
        detail.detailNote  = [s stringForColumn:@"DetailNote"];
        detail.ticketMasterDescription  = [s stringForColumn:@"TicketDescription"];
        detail.subjectID  = [s intForColumn:@"SubjectID"];
        detail.companyID  = [s intForColumn:@"CompanyID"];
        detail.serviceID  = [s intForColumn:@"ServiceID"];
        detail.priorityID  = [s intForColumn:@"Priority"];
        detail.datetime  = [s stringForColumn:@"Datetime"];
        detail.ticketID  = [s intForColumn:@"TicketID"];
        detail.action  = [s stringForColumn:@"ActionDescription"];
        detail.subscriptionGroupID  = [s stringForColumn:@"SubscriptionGroupID"];
        detail.read = [s boolForColumn:@"Read"];
        
    }
    
    [s close];
    
    
    [self.DB close];
    
    return detail;
}

-(void) markAllAsRead
{
    [self.DB open];
    
    [self.DB executeUpdate:@"update TicketDetail set Read = 1"];
    
    [self.DB close];
}

-(void) markTicketAsRead:(NSString*)guid
{
    [self.DB open];
    
    [self.DB executeUpdate: [NSString stringWithFormat:@"update TicketDetail set Read = 1 where GUID  = '%@'",guid]];
    
    [self.DB close];
}

-(void) markAllAsSynced
{
    [self.DB open];
    
    [self.DB executeUpdate:@"update SubscriptionGroup set SyncStatus = 1"];
    
    [self.DB executeUpdate:@"update Subscription set SyncStatus = 1"];
    
    [self.DB close];
}
-(void) deleteAllDisabledAndSynced
{
    [self.DB open];
    
    [self.DB executeUpdate:@"delete from Subscription where Active = 0 and SyncStatus = 1"];
    
    [self.DB executeUpdate:@"delete from SubscriptionGroup where Active = 0 and SyncStatus = 1"];
    
    [self.DB close];
}
-(void) disableAllSubscriptionsForGroup:(NSString*) groupID
{
    [self.DB open];
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"update Subscription set Active = 0, SyncStatus = 0  where SubscriptionGroupID = '%@' " , groupID]];
    
    
    
    [self.DB close];
}

-(void) deleteAllFeeds
{
    [self.DB open];
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"delete from TicketDetail"]];
    
    
    
    [self.DB close];
}


-(void) saveCompany:(SLFCompany *)company
{
    [self.DB open];
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"update Company set Name = '%@'  where ID = %d " , company.name ,company.ID]];
    
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into Company(Id,Name) values(%d,'%@')", company.ID,company.name ]];
    
    [self.DB close];
}

-(void) saveService:(SLFService *)service
{
    [self.DB open];
    
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"update Service set Name = '%@'  where ID = %d" , service.name ,service.ID]];
    
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into Service(Id,Name) values(%d,'%@')", service.ID,service.name  ]];
    
    [self.DB close];
}

-(void) saveSubject:(SLFSubject *)subject
{
    [self.DB open];
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"update Subject set Name = '%@'  where ID = %d 	" , subject.name ,subject.ID]];
    
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into Subject(Id,Name) values(%d,'%@')" , subject.ID,subject.name  ]];
    
    [self.DB close];
}
-(NSString*) findMaxTimestampVer2
{
    NSString * res = 0;
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT ifnull(max(GUID),0)  FROM TicketDetail"];
    while ([s next]) {
        
        res = [s stringForColumnIndex:0];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return res;
}

-(double) findMaxTimestamp
{
    double res = 0;
   
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT ifnull(max(ServerTimestamp),0)  FROM TicketDetail"];
    while ([s next]) {
        
        res = [s doubleForColumnIndex:0];       
    }
    
    [s close];
    
    
    [self.DB close];
    
    return res;
}
-(BOOL) checkUnsynced
{
    BOOL exists=false;
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM Subscription	 where  SyncStatus  =  0"];
    if ([s next]) {
        exists = TRUE;
    }
    
    [s close];
    
    s = [self.DB executeQuery:@"SELECT * FROM SubscriptionGroup	 where  SyncStatus  =  0"];
    if ([s next]) {
        exists = TRUE;
    }
    
    [s close];
    
    [self.DB close];
    
    return exists;
}


@end
