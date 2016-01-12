//
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

static NSString * const BaseURLString = @"https://slf-mobile-span.azurewebsites.net/api/";


@implementation SLFHttpClient


+ (SLFHttpClient *)sharedSLFHttpClient
{
    static SLFHttpClient *_sharedSLFHTTPClient = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //_sharedSLFHTTPClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:BaseURLString]];
        _sharedSLFHTTPClient = [[self alloc] init];
    });

    return _sharedSLFHTTPClient;
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

-(void) postSubscriptions:(SLFSubscriptionsRequest *)subscriptions{
    
      // NSMutableURLRequest * requestWithURL  = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@subscriptions", BaseURLString]]];
    /*
     DBRepository * repo = [[DBRepository alloc] init];
    NSDictionary *parameters = [subscriptions dictionaryRepresentation];
    
    // Do any additional setup after loading the view.
   AFHTTPRequestOperationManager *operationManager = [AFHTTPRequestOperationManager manager];
   operationManager.requestSerializer =[AFJSONRequestSerializer serializer];

   [operationManager POST:[NSString stringWithFormat:@"%@subscriptions", BaseURLString] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
  
    [repo markAllAsSynced];
    NSLog(@"JSON: %@", [responseObject description]);
    
} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    
    NSLog(@"Error: %@", [error description]);
    if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
        [self.delegate slfHTTPClient:self didFailWithError:error];
    }
}];

    
    
   
    }];
*/
    
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
        NSLog(@"JSON: %@", [responseObject description]);
    
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
            
            [repo saveGroup:subscriptionsResponse.groups[i]];
        }
        
        for (int i=0; i < [subscriptionsResponse.subscriptions count]; i++) {
            
            [repo saveSubscription:subscriptionsResponse.subscriptions[i]];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if ([self.delegate respondsToSelector:@selector(slfHTTPClient:didFailWithError:)]) {
            [self.delegate slfHTTPClient:self didFailWithError:error];
        }
        
    }];
    
    [operation start];
    [operation waitUntilFinished];

}


@end
