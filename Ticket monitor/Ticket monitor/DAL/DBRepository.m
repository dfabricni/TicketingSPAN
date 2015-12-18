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
#import "Company.h"

@implementation DBRepository

-(id) init{
    
    if ( self = [super init] ) {

    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * dbPath = [documentsDirectory stringByAppendingString:@"/SLFDB.rdb"];
    
   self.DB = [FMDatabase databaseWithPath:dbPath];
   
    	
        
        return self;
    }
    else
        return nil;
    
}

-(NSMutableArray *) getAllCompanies
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    [self.DB open];
    
    FMResultSet *s = [self.DB executeQuery:@"SELECT * FROM Company"];
    while ([s next]) {
        Company * company = [[Company alloc] init];
        
        company.ID = [s intForColumn:@"ID"];
        company.name = [s stringForColumn:@"Name"];
        
        [items addObject:company];
    }
    
    [s close];
    
    
    [self.DB close];
    
    return items;

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
@end
