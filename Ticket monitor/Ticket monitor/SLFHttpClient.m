
//  SLFHttpClient.m
//  Ticket monitor
//
//  Created by Administrator on 11/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import "SLFHttpClient.h"
#import "DataModels.h"
#import "Globals.h"
#import "DBRepository.h"
#import "AFHTTPRequestOperationManager.h"

static NSString * const BaseURLString = @"https://slf-mobile-span.azurewebsites.net/v2/api/";


@implementation SLFHttpClient


+ (SLFHttpClient *)createSLFHttpClient
{
    /*
    static SLFHttpClient *_sharedSLFHTTPClient = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSLFHTTPClient = [[self alloc] init];
    });
    */
    
     Globals * globals  = [Globals instance];
    SLFHttpClient * client =  [[SLFHttpClient alloc] init];
    [client setBearerToken:globals.oAuthAccessToken];

    return client;
   // return _sharedSLFHTTPClient;
}
/*

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];

    if (self) {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }

    return self;
}*/
 

-(void) setBearerToken:(NSString *)token
{
  // [self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];

    self.oAuthAccessToken = token;
}

-(void) registerDevice:(SLFDevice *)device
{
    
   // DBRepository * repo = [[DBRepository alloc] init];
    NSDictionary *parameters = [device dictionaryRepresentation];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
    
    NSString * deviceRegisterLink = @"device";
     
    
    NSMutableURLRequest *request =  [manager.requestSerializer requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@", BaseURLString,deviceRegisterLink] parameters:parameters error:nil];
    
    
    [request setValue:self.oAuthAccessToken forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
        NSLog(@"JSON: %@", [responseObject description]);
        
        if(operation.response.statusCode == 403)
        {
            NSError  *error = [NSError errorWithDomain:@"eu.span.slf" code:14 userInfo:[NSDictionary dictionaryWithObject:@"Forbidden" forKey:NSLocalizedDescriptionKey]];

            if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
                [self.delegate slfHTTPClient:self didFailWithError:error];
            }

            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", [error description]);
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
            [self.delegate slfHTTPClient:self didFailWithError:error];
        }
        
    }];
    
    [operation start];
    [operation waitUntilFinished];
    // [manager.operationQueue addOperation:operation];
    
    
}


-(void) postSubscriptions:(SLFSubscriptionsRequest *)subscriptions{
    
    
    DBRepository * repo = [[DBRepository alloc] init];
    NSDictionary *parameters = [subscriptions dictionaryRepresentation];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer =[AFJSONRequestSerializer serializer];
  
    
    NSMutableURLRequest *request =  [manager.requestSerializer requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@subscriptions", BaseURLString] parameters:parameters error:nil];
    
    
    [request setValue:self.oAuthAccessToken forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];

    [operation setResponseSerializer:[AFJSONResponseSerializer alloc]];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        [repo markAllAsSynced];
        [repo deleteAllMarkedForDeletionAndSynced];
        
        NSLog(@"JSON: %@", [responseObject description]);
        
        if(operation.response.statusCode != 200)
        {
            NSError  *error = [NSError errorWithDomain:@"eu.span.slf" code:14 userInfo:[NSDictionary dictionaryWithObject:@"Unexpected error" forKey:NSLocalizedDescriptionKey]];
            
            if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
                [self.delegate slfHTTPClient:self didFailWithError:error];
            }
            
        }else{
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFinishedWithPullingAndUpdating:)]) {
            [self.delegate slfHTTPClient:self didFinishedWithPullingAndUpdating:nil];
        }
        }

    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"Error: %@", [error description]);
    if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
        [self.delegate slfHTTPClient:self didFailWithError:error];
    }
    
}];
    
    [operation start];
    [operation waitUntilFinished];
   // [manager.operationQueue addOperation:operation];

    
}



-(void) getCompanies:(double)timestamp
{
    Globals * globals = [Globals instance];
    DBRepository * repo = [[DBRepository alloc] init];

    
    NSMutableURLRequest * requestWithURL  = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@companies?timestamp=%f", BaseURLString, timestamp]]];
    [requestWithURL setValue:self.oAuthAccessToken forHTTPHeaderField:@"Authorization"];
 
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestWithURL];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

   
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        
        // save it in DB
        
        SLFCompaniesResponse * companiesResponse = [[SLFCompaniesResponse alloc] initWithDictionary:responseObject];
        
        globals.settings.CompaniesTimestamp = companiesResponse.maxtimestamp;
        
        [globals saveSettings];
        
        for (int i=0; i < [companiesResponse.companies count]; i++) {
            
            [repo saveCompany:companiesResponse.companies[i]];
        }

        
        
    
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         
         if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
             [self.delegate slfHTTPClient:self didFailWithError:error];
         }
         
     }];
    
    
    [operation start];
    [operation waitUntilFinished];


    
}

-(void) getServices:(double)timestamp
{
    Globals * globals = [Globals instance];
    DBRepository * repo = [[DBRepository alloc] init];
    
    
    NSMutableURLRequest * requestWithURL  = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@services?timestamp=%f", BaseURLString, timestamp]]];
    [requestWithURL setValue:self.oAuthAccessToken forHTTPHeaderField:@"Authorization"];

    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestWithURL];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        // save it in DB
        
        SLFServicesResponse * servicesResponse = [[SLFServicesResponse alloc] initWithDictionary:responseObject];
        
        globals.settings.ServicesTimestamp = servicesResponse.maxtimestamp;
        
        [globals saveSettings];
        
        for (int i=0; i < [servicesResponse.services count]; i++) {
            
            [repo saveService:servicesResponse.services[i]];
        }
                
    
     
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
             [self.delegate slfHTTPClient:self didFailWithError:error];
         }
         
     }];
    
    [operation start];
    [operation waitUntilFinished];
}

-(void) getSubjects:(double)timestamp
{
    Globals * globals = [Globals instance];
    DBRepository * repo = [[DBRepository alloc] init];
    
    
    NSMutableURLRequest * requestWithURL  = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@subjects?timestamp=%f", BaseURLString, timestamp]]];
    [requestWithURL setValue:self.oAuthAccessToken forHTTPHeaderField:@"Authorization"];
 
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestWithURL];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];

      [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // save it in DB
        SLFSubjectsResponse * subjectsResponse = [[SLFSubjectsResponse alloc] initWithDictionary:responseObject];
        
        globals.settings.SubjectsTimestamp = subjectsResponse.maxtimestamp;
        
        [globals saveSettings];
        
        for (int i=0; i < [subjectsResponse.subjects count]; i++) {
            
            [repo saveSubject:subjectsResponse.subjects[i]];
        }
        
        
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          
          if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
              [self.delegate slfHTTPClient:self didFailWithError:error];
          }
          
      }];
    
    [operation start];
    [operation waitUntilFinished];
    
    
}


-(void) getAllSubscriptions
{
   
    DBRepository * repo = [[DBRepository alloc] init];
    
    
    NSMutableURLRequest * requestWithURL  = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@subscriptions", BaseURLString]]];
    [requestWithURL setValue:self.oAuthAccessToken forHTTPHeaderField:@"Authorization"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestWithURL];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // save it in DB
        SLFSubscriptionsResponse * subscriptionsResponse = [[SLFSubscriptionsResponse alloc] initWithDictionary:responseObject];
        
        
        for (int i=0; i < [subscriptionsResponse.groups count]; i++) {
            
            [repo saveGroup:subscriptionsResponse.groups[i] syncStatus:1 ];
        }
        
        for (int i=0; i < [subscriptionsResponse.subscriptions count]; i++) {
            
            [repo saveSubscription:subscriptionsResponse.subscriptions[i] syncStatus:1];
        }
        
        [repo deleteAllMarkedForDeletionAndSynced];
        
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFinishedWithPullingAndUpdating:)]) {
            [self.delegate slfHTTPClient:self didFinishedWithPullingAndUpdating:nil];
        }

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
            [self.delegate slfHTTPClient:self didFailWithError:error];
        }
        
    }];
    
    [operation start];
    [operation waitUntilFinished];

}	

-(void) getDetailByGUID:(NSString*) GUID username:(NSString*) username
{
    
    Globals * globals = [Globals instance];
    
     NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"guid"] = [NSString stringWithFormat:@"%@", GUID ];
    parameters[@"user"] = [NSString stringWithFormat:@"%@", username ];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:  BaseURLString]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //[manager.requestSerializer setValue:globals.oAuthAccessToken forHTTPHeaderField:@"Authorization"];
    
    [manager GET:@"detail" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {;;
        
          NSLog(@"JSON Ticket Detail: %@", [responseObject description]);
        
        SLFTicketDetail * ticketDetail = [[SLFTicketDetail alloc] initWithDictionary:responseObject];
        
        DBRepository * repo = [[DBRepository alloc] init];
        [repo saveTicketDetail:ticketDetail];
        
        // call delegate to refresh table view
        
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFinishedWithPullingAndUpdating:)]) {
            [self.delegate slfHTTPClient:self didFinishedWithPullingAndUpdating:ticketDetail];
        }
        
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
            if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
                [self.delegate slfHTTPClient:self didFailWithError:error];
            }
            
        }];


}

-(void) getDetailByGUIDFromBackgroundTask:(NSString*) GUID username:(NSString*) username taskID:(UIBackgroundTaskIdentifier) taskID
{
   // Globals * globals = [Globals instance];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"guid"] = [NSString stringWithFormat:@"%@", GUID ];
    parameters[@"user"] = [NSString stringWithFormat:@"%@", username ];
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:  BaseURLString]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //[manager.requestSerializer setValue:globals.oAuthAccessToken forHTTPHeaderField:@"Authorization"];
    
    [manager GET:@"detail" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {;;
        
        NSLog(@"JSON Ticket Detail: %@", [responseObject description]);
        
        SLFTicketDetail * ticketDetail = [[SLFTicketDetail alloc] initWithDictionary:responseObject];
        
        DBRepository * repo = [[DBRepository alloc] init];
        [repo saveTicketDetail:ticketDetail];
        
        // call delegate to refresh table view
        
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFinishedWithPullingAndUpdatingFromBackgroundTask:taskID:)]) {
            [self.delegate slfHTTPClient:self didFinishedWithPullingAndUpdatingFromBackgroundTask:ticketDetail taskID:taskID ];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithErrorFromBackgroundTask:taskID:)]) {
            [self.delegate slfHTTPClient:self didFailWithErrorFromBackgroundTask:error taskID:taskID];
        }
        
    }];
}

-(void) getLatestFeeds:(NSString*) timeStamp
{
   // NSString * timestamp = nil;
   
   // DBRepository * repo = [[DBRepository alloc] init];
    Globals * globals = [Globals instance];
    
    /*
    double maxTimestampInSeconds =  [repo findMaxTimestamp];
    
    if(maxTimestampInSeconds ==0)
    {
        timestamp = [globals formatDateFromTimestampUTCLast24Hours];
    }
    else
    {
        timestamp  =  [globals formatDateFromTimestampUTC:maxTimestampInSeconds];
    }*/
    //timeStamp = [repo findMaxTimestampVer2];
    if([timeStamp isEqualToString:@""] || timeStamp == nil)
    {
        timeStamp = @"0";
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"timestamp"] = [NSString stringWithFormat:@"%@", timeStamp ];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:  BaseURLString]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:globals.oAuthAccessToken forHTTPHeaderField:@"Authorization"];
    
    [manager GET:@"feed" parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {;;
        
        NSLog(@"JSON Ticket Detail: %@", [responseObject description]);
        
        NSArray * array = (NSArray*) responseObject;
        
        for(int i=0; i < [array count] ; i++)
        {
            SLFTicketDetail * ticketDetail = [[SLFTicketDetail alloc] initWithDictionary: (NSDictionary *)[array objectAtIndex:i]];
            
            DBRepository * repo = [[DBRepository alloc] init];
            [repo saveTicketDetail:ticketDetail];

        }
        
        // call delegate to refresh table view
        
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFinishedWithPullingAndUpdating:)]) {
            [self.delegate slfHTTPClient:self didFinishedWithPullingAndUpdating:nil];
        }

        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
            [self.delegate slfHTTPClient:self didFailWithError:error];
        }
        
    }];

}

@end
