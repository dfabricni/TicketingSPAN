//
//  FirstViewController.m
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import "FeedsFilteredViewController.h"
#import "AFURLSessionManager.h"
#import "ADAuthenticationContext.h"
#import "DBRepository.h"
#import "Globals.h"
#import "SLFHttpClient.h"
#import "Synchronizer.h"
#import "TicketDetaillViewController.h"

@interface FeedsFilteredViewController ()

@end

@implementation FeedsFilteredViewController
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

-(void) initWithGroupingData:(SLFGroupedItem*) groupedItem feedTableType:(FeedTableType) type
{
    self.title = groupedItem.GroupedItemName;
    self.groupedItem = groupedItem;
    self.feedTableType = type;
    [self loadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
       //init refresh control
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = UIColorFromRGB(0xe3e3e3);
    self.refreshControl.tintColor = UIColorFromRGB(0xe22221);
    [self.refreshControl addTarget:self action:@selector(getMoreFeeds) forControlEvents:UIControlEventValueChanged];

    
   self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

   
    
    
    

}
-(void) viewDidAppear:(BOOL)animated
{
    Globals * globals  = [Globals instance];
    globals.delegate = self;
    if([globals needsReauthentication])
        return;
    

    [self loadData];
    
}
-(void) loadData
{
    DBRepository * repo =  [[DBRepository alloc] init];
    
    switch (self.feedTableType) {
        case GroupByCompany:
        {
            int companyID = [self.groupedItem.GroupedItem intValue];
            self.details = [repo getDetailsForCompany:companyID];
        }
            break;
        case GroupBySubscription:
            self.details = [repo getDetailsForSubscription:self.groupedItem.GroupedItem];
            break;
        case GroupByTicket:
        {
            int ticketID = [self.groupedItem.GroupedItem intValue];
            self.details = [repo getDetailsForTicket:ticketID];
        }
            break;
        case NoGrouping:
            break;
       
    }
    
    [self.tableView reloadData];
    [self invalidateTableView];
}
-(void) globals:(Globals *)global didFinishedAcquaringToken:(id)object
{
    global.delegate = nil;
    [self loadData];
    Synchronizer * sync  =  [Synchronizer instance];
    sync.delegate = self;
    [sync Sync];
}
-(void) globals:(Globals *)global didFinishedAuthenticating:(id)object
{
    global.delegate = nil;
    
     Synchronizer * sync  =  [Synchronizer instance];
    sync.delegate = self;
     [sync Sync];
}


-(void) invalidateTableView
{
    if ([self.details count] > 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        
    }
    else{
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
       // messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
}
-(void) getMoreFeeds
{
    SLFHttpClient * httpClient =  [SLFHttpClient createSLFHttpClient];
    httpClient.delegate = self;
    [httpClient getLatestFeeds:nil];
}

-(void)slfHTTPClient:(SLFHttpClient *)client didFailWithError:(NSError *)error
{
    client.delegate = nil;
    
    [self showMessage:[NSString stringWithFormat:@"Network Error : %@ ",[error userInfo] ]
            withTitle:@"Error"];
    
    [self refreshRefreshControl];
    
   
    
}
-(void) refreshRefreshControl
{
    if (self.refreshControl) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"dd.MM.yyyy HH:mm:ss"];
        NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
        NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]forKey:NSForegroundColorAttributeName];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
        
        [self.refreshControl endRefreshing];
    }
}
-(void)slfHTTPClient:(SLFHttpClient *)client didFinishedWithPullingAndUpdating:(id)object
{

    [self loadData];
    
    [self refreshRefreshControl];
    
    client.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    TicketDetaillViewController *vc = (TicketDetaillViewController*)[storyboard instantiateViewControllerWithIdentifier:@"TicketDetail"];
    SLFTicketDetail * detail = self.details[indexPath.row];
    [vc initWithTicketDetailID:detail.gUID];
    [self.navigationController pushViewController:vc animated:TRUE];
    
    

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
    
   
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

    bool read  = false;
    
  
            SLFTicketDetail * detail = (SLFTicketDetail*)self.details[indexPath.row];
            
            NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            
            NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
            [dateFormater setTimeZone:gmt];
            dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            
            NSDate* date= [dateFormater dateFromString: detail.datetime];
            
            dateFormater.dateFormat =  @"dd.MM. HH:mm:ss";
            [dateFormater setTimeZone:outputTimeZone];
            
            cell.textLabel.text = detail.detailDescription;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"ID: %d  %@ %@", detail.ticketID,[dateFormater stringFromDate:date], detail.subscriptionGroupName ];
            
            read  = detail.read;
            
            
            
    
    
    
    if (!read) {
        cell.textLabel.textColor = UIColorFromRGB(0xC43947);
        cell.textLabel.font  = [UIFont boldSystemFontOfSize:16.];
        
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.font  = [UIFont systemFontOfSize: 16.];
    }
   
    return cell;
    
}

-(void) synchronizer:(Synchronizer *)sync didFinishedSynchronizing:(id)object
{
   [self loadData];
    sync.delegate  = nil;
   
    
}
-(void) synchronizer:(Synchronizer *)sync errorOccured:(NSError *)error
{
    NSLog(@"Network error:   %@",   [error userInfo]);

    NSString * errorText = [[error userInfo] valueForKey:@"NSLocalizedDescription"];
    
    sync.delegate  = nil;
    
    [self showMessage:@"Error synchronizing data"
                    withTitle:errorText];

    
    
}

-(void)showMessage:(NSString*)message withTitle:(NSString *)title
{

 UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){

        //do something when click button
        
        if ([title containsString:@"Forbidden"]) {
            // exit app
            UIApplication *app = [UIApplication sharedApplication];
            [app performSelector:@selector(suspend)];
            
            //wait 2 seconds while app is going background
            [NSThread sleepForTimeInterval:2.0];
            
            //exit app when app is in background
            exit(0);

        }
        
    }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}



@end

