//
//  Globals.m
//  Ticket monitor
//
//  Created by Administrator on 07/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import "Globals.h"
#import "DBRepository.h"
#import "AFURLSessionManager.h"
#import "ADAuthenticationContext.h"

#import "SLFHttpClient.h"
#import "Synchronizer.h"


@implementation Globals


+ (id)instance {
    static Globals * shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared  = [[self alloc] init];
    });
    return shared;
}


- (id)init {
  if (self = [super init]) {
      
      // get settings
      self.expiresOn = [NSDate date];
      self.authInProcess=false;
      DBRepository * repo =  [[DBRepository alloc] init];

      self.settings = [repo getSettings];
  
  }
  return self;
}


- (void) saveSettings {
   
    DBRepository * repo =  [[DBRepository alloc] init];
    [repo saveSettings:self.settings];
    
    
}

-(NSString*) formatDateFromTimestampUTCLast24Hours
{
    NSString * strTimestamp = nil;
    NSDate * date = [NSDate date];
    NSDate *yesterday = [date dateByAddingTimeInterval: -86400.0];

  
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormater setTimeZone:gmt];
    
    dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    strTimestamp =  [dateFormater stringFromDate:yesterday];
    return  strTimestamp;
}

-(NSString*) formatDateFromTimestamp:(double) timestamp
{
    NSString * strTimestamp = nil;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.];
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    strTimestamp =  [dateFormater stringFromDate:date];
    return  strTimestamp;
}

-(NSString*) formatDateFromTimestampUTC:(double) timestamp
{
    NSString * strTimestamp = nil;
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:timestamp/1000.];
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormater setTimeZone:gmt];

    dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    strTimestamp =  [dateFormater stringFromDate:date];
    return  strTimestamp;
}

-(BOOL) needsReauthentication
{
    BOOL res= false;
    
    if(self.authInProcess)
        return false;
    
    NSDate * current = [[NSDate date] dateByAddingTimeInterval:60];
    
    
    
    if ([current compare:self.expiresOn] == NSOrderedDescending )// || [self.oAuthAccessToken isEqualToString:@""])
    {
        self.authInProcess = true;
        [self logIn];
        res = true;
    }
    
    return res;
    
}


-(void) logIn
{
    
    NSString *authority = @"https://login.windows.net/b0460523-b78c-4b4a-8a10-5928b799ad45/FederationMetadata/2007-06/FederationMetadata.xml";
    NSString *resourceURI = @"https://slf-mobile-span.azurewebsites.net";
    NSString *clientID = @"75842aba-501f-409d-b0e0-7b2091678c4b";
    NSString *redirectURI = @"http://console-app-test-oauth/";
    
    ADAuthenticationError *error;
    ADAuthenticationContext *authContext = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    NSURL *redirectUri = [[NSURL alloc]initWithString:redirectURI];
    
    [authContext acquireTokenWithResource:resourceURI clientId:clientID redirectUri:redirectUri completionBlock:^(ADAuthenticationResult *result) {
        if (result.tokenCacheStoreItem == nil)
        {
            // exit the app
            //home button press programmatically
            UIApplication *app = [UIApplication sharedApplication];
            [app performSelector:@selector(suspend)];
            
            //wait 2 seconds while app is going background
            [NSThread sleepForTimeInterval:2.0];
            
            //exit app when app is in background
            exit(0);
            
            
            return;
        }
        else
        {
            
            
            
            Globals * globals  = [Globals instance];
            
            globals.oAuthAccessToken = [NSString stringWithFormat:@"%@ %@",result.tokenCacheStoreItem.accessTokenType, result.tokenCacheStoreItem.accessToken];
            
            globals.expiresOn = result.tokenCacheStoreItem.expiresOn;
            
            
            if (globals.device != nil) {
                
                globals.device.username = result.tokenCacheStoreItem.userInformation.userId ;
            }
            
            SLFHttpClient * httpClient =  [SLFHttpClient sharedSLFHttpClient];
            
            [httpClient setBearerToken:globals.oAuthAccessToken];
            
            self.authInProcess=false;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
              //  [self.navigationController.view addSubview:self.overlayView];
              //  [self.indicatorView startAnimating];
                
            });
            
            
            Synchronizer * sync  =  [Synchronizer instance];
            // sync.delegate = self;
            [sync Sync];
            
            
        }
    }];
    
    
}
@end
