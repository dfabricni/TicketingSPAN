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
#import "TicketDetaillViewController.h"

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
    
   // self.tableView.delegate  = self;
    //self.tableView.dataSource =  self;
    self.syncNeeded = true;
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
    if([globals needsReauthentication])
        return;
    /*
    if (globals.authInProcess) {
        return;
    }*/
    
    DBRepository * repo =  [[DBRepository alloc] init];
    
    self.details = [repo getAllDetails];
    
    [self.tableView reloadData];
    [self invalidateTableView];
    
    
    /*
    // TODO revidirat ovo oko syncanja
    if (self.syncNeeded) {
        Synchronizer * sync  =  [Synchronizer instance];
        sync.delegate = self;
        [sync Sync];
        self.syncNeeded = false;
    }
    */

    
    
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    
    
    
    
}

-(void) invalidateTableView
{
    if ([self.details count] > 0) {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
       
        
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
    SLFHttpClient * httpClient =  [SLFHttpClient sharedSLFHttpClient];
    httpClient.delegate = self;
    [httpClient getLatestFeeds];
}

-(void)slfHTTPClient:(SLFHttpClient *)client didFailWithError:(NSError *)error
{
    client.delegate = nil;
    
    [self showMessage:@"Network error occured"
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

    DBRepository * repo =  [[DBRepository alloc] init];
    
    self.details = [repo getAllDetails];
    
    [self.tableView reloadData];
    
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
    NSDictionary * detail = self.details[indexPath.row];
    
   
    [vc initWithTicketDetailID:detail[@"GUID"]];
    
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

-(void) synchronizer:(Synchronizer *)sync didFinishedSynchronizing:(id)object
{
   // self.overlayView.hidden  =  true;
    sync.delegate  = nil;
    [self.indicatorView stopAnimating];
    [self.overlayView removeFromSuperview];
    
}
-(void) synchronizer:(Synchronizer *)sync errorOccured:(NSError *)error
{
    NSLog(@"Network error:   %@",   [error userInfo]);

    sync.delegate  = nil;
    
    [self showMessage:@"Error synchronizing data"
                    withTitle:@"Error"];

    [self.indicatorView stopAnimating];
   // self.overlayView.hidden  =  true;
    [self.overlayView removeFromSuperview];
    
}
-(void)showMessage:(NSString*)message withTitle:(NSString *)title
{

 UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){

        //do something when click button
    }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}


-(IBAction)onRemove :(id)sender
{
    DBRepository * repo =  [[DBRepository alloc] init];
    [repo deleteAllFeeds];
     self.details = [repo getAllDetails];
    [self.tableView reloadData];
}


@end

