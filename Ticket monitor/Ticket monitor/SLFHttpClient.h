//
//  SLFHttpClient.h
//  Ticket monitor
//
//  Created by Administrator on 11/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "AFHTTPRequestOperation.h"
#import "SLFSubscriptionsResponse.h"

#define SLFSubscriptionsRequest SLFSubscriptionsResponse

@protocol SLFHttpClientDelegate;




@interface SLFHttpClient : NSObject


@property (nonatomic, weak) id<SLFHttpClientDelegate>delegate;
@property (nonatomic, copy) NSString * oAuthAccessToken;

+ (SLFHttpClient *)sharedSLFHttpClient;

-(void) setBearerToken:(NSString*) token;



//- (instancetype)initWithBaseURL:(NSURL *)url;

-(void) postSubscriptions:(SLFSubscriptionsRequest*) subscriptions;

-(void) getServices:(double) timestamp;
-(void) getCompanies:(double) timestamp;
-(void) getSubjects:(double) timestamp;

-(void) getAllSubscriptions;


@end



@protocol SLFHttpClientDelegate <NSObject>
@optional
-(void)slfHTTPClient:(SLFHttpClient *)client didUpdateSubscriptions:(id)subscriptions;

-(void)slfHTTPClient:(SLFHttpClient *)client didFailWithError:(NSError *)error;

@end