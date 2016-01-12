//
//  FirstViewController.m
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import "FirstViewController.h"
#import "AFURLSessionManager.h"
#import "ADAuthenticationContext.h"
#import "DBRepository.h"
#import "Globals.h"
#import "SLFHttpClient.h"
#import "Synchronizer.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DBRepository * repo =  [[DBRepository alloc] init];
    
    [repo getAllCompanies   ];
    
    [self logIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) logIn
{
    NSString *authority = @"https://login.windows.net/b0460523-b78c-4b4a-8a10-5928b799ad45/FederationMetadata/2007-06/FederationMetadata.xml";
    NSString *resourceURI = @"http://slf-mobile-span.azurewebsites.net";
    NSString *clientID = @"714bf373-f063-4c64-9141-77a258e94d3c";
    NSString *redirectURI = @"http://console-app-test-oauth/";
    
    ADAuthenticationError *error;
    ADAuthenticationContext *authContext = [ADAuthenticationContext authenticationContextWithAuthority:authority error:&error];
    NSURL *redirectUri = [[NSURL alloc]initWithString:redirectURI];
    
    [authContext acquireTokenWithResource:resourceURI clientId:clientID redirectUri:redirectUri completionBlock:^(ADAuthenticationResult *result) {
        if (result.tokenCacheStoreItem == nil)
        {
            return;
        }
        else
        {
            
            Globals * globals  = [Globals instance];
            
            globals.oAuthAccessToken = [NSString stringWithFormat:@"%@ %@",result.tokenCacheStoreItem.accessTokenType, result.tokenCacheStoreItem.accessToken];
            
            
            SLFHttpClient * httpClient =  [SLFHttpClient sharedSLFHttpClient];
            
            [httpClient setBearerToken:globals.oAuthAccessToken];
            
            Synchronizer * sync  =  [Synchronizer instance];
            
            [sync Sync];
            
            //[httpClient getCompanies:0];
            
        }
    }];

}

-(IBAction)logMeIn:(id)sender
{
    
    Synchronizer * sync  =  [Synchronizer instance];
    
    [sync Sync];
    
   }

@end
