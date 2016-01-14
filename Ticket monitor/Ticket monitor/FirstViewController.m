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
/*
-(id) init
{
     self = [super init];

    if(self)
    {
        self.tableView.delegate  = self;
        self.tableView.dataSource =  self;
    }
    
    return self;
}
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.delegate  = self;
    self.tableView.dataSource =  self;

    DBRepository * repo =  [[DBRepository alloc] init];
    
    self.details = [repo getAllDetails];
    
    [self.tableView reloadData];
   self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
   

   [self logIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.details count];
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];

   
    if (cell == nil) {


        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DefaultCell"];

       
        
    }

 
    
    NSDictionary * detail = self.details[indexPath.row];
    
    cell.textLabel.text = detail[@"DetailDescription"];
    
   
//2016-01-14T07:55:16.000Z
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";    
    NSDate* date= [dateFormater dateFromString: detail[@"Datetime"]];
    dateFormater.dateFormat =  @"dd.MM.yyyy HH:mm:ss";
   
    cell.detailTextLabel.text =  [dateFormater stringFromDate:date];
    
    return cell;
    
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
            
            if (globals.device != nil) {
                
                globals.device.username = result.tokenCacheStoreItem.userInformation.userId ;
            }
            
            SLFHttpClient * httpClient =  [SLFHttpClient sharedSLFHttpClient];
            
            [httpClient setBearerToken:globals.oAuthAccessToken];
            
            
            Synchronizer * sync  =  [Synchronizer instance];
            [sync Sync];

            
        }
    }];
    
    
}


-(IBAction)logMeIn:(id)sender
{
    
    
    DBRepository * repo =  [[DBRepository alloc] init];
    
    self.details = [repo getAllDetails];
    
    [self.tableView reloadData];
        
   // Synchronizer * sync  =  [Synchronizer instance];
    //[sync Sync];
        
    
}
@end
