//
//  Globals.h
//  Ticket monitor
//
//  Created by Administrator on 07/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataModels.h"


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@protocol OAuthTokenRefresherDelegate ;


@interface Globals : NSObject

@property (nonatomic, weak) id<OAuthTokenRefresherDelegate>delegate;

@property (nonatomic, copy) NSString * oAuthAccessToken;
//@property (nonatomic, copy) NSString * refreshToken;
@property (nonatomic, retain) SLFSettings * settings;
@property (nonatomic, retain) SLFDevice * device;
@property (nonatomic, assign) long  servicesTimestamp;
@property (nonatomic, retain) NSDate * expiresOn;
@property (nonatomic, assign) BOOL  authInProcess;

@property (nonatomic, retain) NSString * authority;
@property (nonatomic, retain) NSString * resourceURI;
@property (nonatomic, retain) NSString * clientID;
@property (nonatomic, retain) NSString * redirectURI;
//property (nonatomic, retain) NSString * username;

@property (nonatomic, assign) BOOL  isMainSPANCompany;
@property (nonatomic, assign) int  companyID;


+ (id)instance;

-(void) saveSettings;
-(NSString*) formatDateFromTimestamp:(double) timestamp;

-(NSString*) formatDateFromTimestampUTC:(double) timestamp;

-(NSString*) formatDateFromTimestampUTCLast24Hours;

-(BOOL) needsReauthentication;


-(void) acquireOrRefreshToken;
@end




@protocol OAuthTokenRefresherDelegate <NSObject>


@optional
-(void) globals:(Globals*) global  didFinishedAcquaringToken:(id) object;

@optional
-(void) globals:(Globals*) global  didFinishedAuthenticating:(id) object;


@optional
-(void) globals:(Globals*) global  errorOccured:(NSError*) error;

@end
