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
}
 */

-(void) setBearerToken:(NSString *)token
{
   //[self.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    self.oAuthAccessToken = token;
}

-(void) postSubscriptions:(SLFSubscriptionsRequest *)subscription{
    
    
    
}


-(void) getCompanies:(double)timestamp
{
    Globals * globals = [Globals instance];
    DBRepository * repo = [[DBRepository alloc] init];

    
    NSMutableURLRequest * requestWithURL  = [NSMutableURLRequest requestWithURL: [NSURL URLWithString: [NSString stringWithFormat:@"%@companies?timestamp=%f", BaseURLString, timestamp]]];
    [requestWithURL setValue:self.oAuthAccessToken forHTTPHeaderField:@"Authorization"];
 
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:requestWithURL];
    operation.responseSerializer =[AFJSONResponseSerializer serializer];
  
   
    
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
    operation.responseSerializer =[AFJSONResponseSerializer serializer];
    
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
    operation.responseSerializer =[AFJSONResponseSerializer serializer];

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
    operation.responseSerializer =[AFJSONResponseSerializer serializer];
    
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
