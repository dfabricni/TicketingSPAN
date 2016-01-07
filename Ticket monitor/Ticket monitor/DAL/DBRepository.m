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




@end
