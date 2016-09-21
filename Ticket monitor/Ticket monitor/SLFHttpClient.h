//
//  SLFHttpClient.h
//  Ticket monitor
//
//  Created by Administrator on 11/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "SLFSubscriptionsResponse.h"
#import "DataModels.h"


@protocol SLFHttpClientDelegate;




@interface SLFHttpClient : NSObject


@property (nonatomic, weak) id<SLFHttpClientDelegate>delegate;
@property (nonatomic, copy) NSString * oAuthAccessToken;

+ (SLFHttpClient *)createSLFHttpClient;

-(void) setBearerToken:(NSString*) token;



//- (instancetype)initWithBaseURL:(NSURL *)url;

-(void) postSubscriptions:(SLFSubscriptionsRequest*) subscriptions;

-(void) getServices:(double) timestamp;
-(void) getCompanies:(double) timestamp;
-(void) getSubjects:(double) timestamp;


-(void) getLatestFeeds:(NSString*) timeStamp;



    

-(void) getAllSubscriptions;

-(void) registerDevice:(SLFDevice*) device;

-(void) getDetailByGUID:(NSString*) GUID username:(NSString*) username;


-(void) getDetailByGUIDFromBackgroundTask:(NSString*) GUID username:(NSString*) username taskID:(UIBackgroundTaskIdentifier) taskID;

@end



@protocol SLFHttpClientDelegate <NSObject>
@optional
-(void)slfHTTPClient:(SLFHttpClient *)client didFinishedWithPullingAndUpdating:(id)object;
@optional
-(void)slfHTTPClient:(SLFHttpClient *)client didFailWithError:(NSError *)error;

@optional
-(void)slfHTTPClient:(SLFHttpClient *)client didFinishedWithPullingAndUpdatingFromBackgroundTask:(id)object taskID:(UIBackgroundTaskIdentifier) taskID;
@optional
-(void)slfHTTPClient:(SLFHttpClient *)client didFailWithErrorFromBackgroundTask:(NSError *)error taskID:(UIBackgroundTaskIdentifier) taskID;


@end
