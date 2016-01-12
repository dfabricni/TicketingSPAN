//
//  Synchronizer.m
//  Ticket monitor
//
//  Created by Administrator on 11/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import "Synchronizer.h"
#import "Globals.h"
#import "DataModels.h"
#import "SLFHttpClient.h"

@implementation Synchronizer


+ (id)instance {
    static Synchronizer * shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared  = [[self alloc] init];
    });
    return shared;
}



- (id)init {
    if (self = [super init]) {
        
        // get settings
               
    }
    return self;
}

-(void) Sync
{
    
    // dispatch it in another thread
    // start progress notification
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

//dispatch_queue_t myQueue = dispatch_queue_create("Sync queue",NULL);
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    // Perform long running process
    
   

    
    
    // first begin with notification that syncing is in progress
    
    SLFHttpClient * httpClient = [SLFHttpClient sharedSLFHttpClient];
    Globals * globals = [Globals instance];
    
    
    
    // get new services
    [httpClient getServices:globals.settings.ServicesTimestamp];
    
    
    // get new companies
   [httpClient getCompanies:globals.settings.CompaniesTimestamp];
    
    // get new subjects
   [httpClient getSubjects:globals.settings.SubjectsTimestamp];
    
    
    
    // get subscriptions
    [httpClient getAllSubscriptions];
    
    
    
    
    // push new groups
    
    
    // push new  subscriptions
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        // Update the UI
        // end progress notification
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; 

        
    });
    
    
    
});
    

}

@end