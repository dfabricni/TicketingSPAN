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
    NSString * dbPath = [documentsDirectory stringByAppendingString:@"/SLFDB.rdb"];
    
   self.DB = [FMDatabase databaseWithPath:dbPath];
   
    	
//wwß
        return self;
    }
    else
        return nil;
    
}



+(void) prepareSqlLiteFile
{
    bool overwrite = true;
    
    
    if(!overwrite)
        return;
  //  /Users/administrator/Library/Developer/CoreSimulator/Devices/AE397F1A-CE56-4967-AC0E-2B55C48A7EA0/data/Containers/Data/Application/AF79198C-31B5-431E-B461-E9789E085E0F/Documents/
    
    
    // copy sql lite file if we decide
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"SLFDB.rdb"];
    
    NSString * documentsDBFilePath = [documentsDirectory stringByAppendingString:@"/SLFDB.rdb"];
    
    NSError *error = nil;

    //delte old one
    if([[NSFileManager defaultManager] fileExistsAtPath:documentsDBFilePath isDirectory:false])
        [[NSFileManager defaultManager] removeItemAtPath: documentsDBFilePath  error: &error];
    
    
    if(error !=  nil)
    {
        NSLog(@"Error description-%@ \n", [error localizedDescription]);
        NSLog(@"Error reason-%@", [error localizedFailureReason]);
    }
    
if([[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:documentsDBFilePath error:&error]){
    NSLog(@"Default file successfully copied over.");
  } else {
    NSLog(@"Error description-%@ \n", [error localizedDescription]);
    NSLog(@"Error reason-%@", [error localizedFailureReason]);
  }


    
}




-(NSMutableArray *) getAllCompanies
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM Company"];
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




-(NSMutableArray *) getAllSubjects
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM Subject"];
    while ([s next]) {
        SLFSubject * subject = [[SLFSubject alloc] init];
        
        subject.ID = [s intForColumn:@"ID"];
        subject.name = [s stringForColumn:@"Name"];
        
        [items addObject:subject];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;
    
}

-(NSMutableArray *) getAllServices
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM Service"];
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
       
    }
    
    [s close];
    
    
    [self.DB close];
    
    return settings;
    
}

-(void) saveSettings:(SLFSettings*) setting{
   
    [self.DB open];
    
    [self.DB executeUpdate:@"update settings set ServicesTimestamp = ? , SubjectsTimestamp = ? , CompaniesTimestamp = ?" , [NSNumber numberWithDouble:setting.ServicesTimestamp ], [NSNumber numberWithDouble:setting.SubjectsTimestamp ],[NSNumber numberWithDouble:setting.CompaniesTimestamp ],nil];
    
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


-(void) saveGroup:(SLFGroup*) group{
    
    
    [self.DB open];
  // [self.DB executeUpdate:@"update SubscriptionGroup set Name = ? , GroupOperation = ? , Active = ?, SyncStatus = 0 where ID = ? " , group.name , group.groupOperation, TRUE, group.iDProperty,nil];
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"update SubscriptionGroup set Name = '%@' , GroupOperation = '%@' , Active = %d, SyncStatus = 0 where ID = '%@' " , group.name , group.groupOperation, TRUE, group.iDProperty ]];
    
    // jsut in case then make insert
    
     [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into SubscriptionGroup(Id,Name,GroupOperation,Active,SyncStatus) values('%@','%@','%@',%d,1)" , group.iDProperty ,group.name , group.groupOperation, TRUE ]];
    
   // [self.DB executeUpdate:@"insert or ignore into SubscriptionGroup(Id,Name,GroupOperation,Active,SyncStatus) values(?,?,?,?,?)", group.iDProperty, group.name,group.groupOperation,1,0];
    
    [self.DB close];
    
}

-(void) saveSubscription:(SLFSubscription*) subscription
{

    [self.DB open];
    
     [self.DB executeUpdate:[NSString stringWithFormat:@"update Subscription set SubscriptionGroupID = '%@' , RuleTypeID = %d , LastCheckPoint = '%@', Value='%@', ValueDisplayText = '%@' , Active = %d, SyncStatus = 1 where ID = '%@' " , subscription.subscriptionGroupID, subscription.ruleTypeID, subscription.lastCheckPoint, subscription.value, subscription.valueDisplayText, subscription.active, subscription.iDProperty]];
    
  //  [self.DB executeUpdate:@"update Subscription set SubscriptionGroupID = ? , RuleTypeID = ? , LastCheckPoint = ?, Value=?, ValueDisplayText = ? , Active = ?, SyncStatus = 0 where ID = ? 	" , subscription.subscriptionGroupID, subscription.ruleTypeID, subscription.lastCheckPoint, subscription.value, subscription.valueDisplayText, subscription.active, subscription.iDProperty ,nil];
    
    // jsut in case then make insert
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into Subscription(ID,SubscriptionGroupID,RuleTypeID,LastCheckPoint,Value,ValueDisplayText ,Active,SyncStatus) values('%@','%@',%d,'%@','%@','%@',%d,%d)", subscription.iDProperty, subscription.subscriptionGroupID,subscription.ruleTypeID,subscription.lastCheckPoint,subscription.value,subscription.valueDisplayText ,subscription.active,1]];
    
    [self.DB close];
    
}

-(void) saveTicketDetail:(SLFTicketDetail *)ticketDetail
{
    [self.DB open];
    
    [self.DB executeUpdate:@"update TicketDetail set TicketID = ?, SubjectID = ?, DetailDescription = ?, ActionDescription = ?, CompanyID = ?, Datetime = ?, Priority = ?, ServiceID = ?, Note = ?,  TicketDescription = ?, where ID = ? 	" , ticketDetail.ticketID, ticketDetail.subject, ticketDetail.detailDesc, ticketDetail.actionDesc, ticketDetail.cOMPANY, ticketDetail.pDATE, ticketDetail.sEQPRIORITY, ticketDetail.sEQSERVICE, ticketDetail.note, ticketDetail.ticketDesc, ticketDetail.detailID ,nil];
    
    // jsut in case then make insert
    
    [self.DB executeUpdate:@"insert or ignore into Subscription(ID,TicketID, SubjectID, DetailDescription, ActionDescription, CompanyID, Datetime, Priority, ServiceID, Note,  TicketDescription) values(?,?,?,?,?,?,?,?,?,?,?)", ticketDetail.detailID, ticketDetail.ticketID, ticketDetail.subject, ticketDetail.detailDesc, ticketDetail.actionDesc, ticketDetail.cOMPANY, ticketDetail.pDATE, ticketDetail.sEQPRIORITY, ticketDetail.sEQSERVICE, ticketDetail.note, ticketDetail.ticketDesc];
    
    [self.DB close];
    
    
}

-(void) markAllAsRead
{
    [self.DB open];
    
    [self.DB executeUpdate:@"update TicketDetail set Read = 1"];
    
    [self.DB close];
}

-(void) markTicketAsRead:(int)detailID
{
    [self.DB open];
    
    [self.DB executeUpdate:@"update TicketDetail set Read = 1 where ID  = ?",detailID,nil];
    
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
    
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into Service(Id,Name) values(%d,%@)", service.ID,service.name  ]];
    
    [self.DB close];
}

-(void) saveSubject:(SLFSubject *)subject
{
    [self.DB open];
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"update Subject set Name = '%@'  where ID = %d 	" , subject.name ,subject.ID]];
    
    
    [self.DB executeUpdate:[NSString stringWithFormat:@"insert or ignore into Subject(Id,Name) values(%d,'%@')" , subject.ID,subject.name  ]];
    
    [self.DB close];
}


@end
