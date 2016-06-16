//
//  SecondViewController.m
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import "SecondViewController.h"
#import "DBRepository.h"
#import "Globals.h"
#import "SLFHttpClient.h"
#import "NewGroupViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.editing = false;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = UIColorFromRGB(0xe3e3e3);
    self.refreshControl.tintColor = UIColorFromRGB(0xe22221);
    [self.refreshControl addTarget:self action:@selector(refreshSubscriptions) forControlEvents:UIControlEventValueChanged];
    
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
   // [self.tableView setEditing:TRUE animated:TRUE];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void) viewDidAppear:(BOOL)animated
{
   
    
    Globals * globals  = [Globals instance];
    globals.delegate = self;
    if([globals needsReauthentication])
        return;
    
    
   
    [self syncIfNeeded];
    

}

-(void) syncIfNeeded
{
     DBRepository * repo =  [[DBRepository alloc] init];
    
    // check to see if there is need to sync
    BOOL needsync = [repo checkUnsynced];
    if(needsync)
    {
        
        [self callSync];
        
    }
    
    self.groups = [repo getAllGroups];
    [self.tableView reloadData];
}

-(void)refreshSubscriptions
{
    SLFHttpClient * httpClient = [SLFHttpClient createSLFHttpClient];
    httpClient.delegate = self;
    [httpClient getAllSubscriptions];

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

-(void) globals:(Globals *)global didFinishedAcquaringToken:(id)object
{
    global.delegate = nil;
    [self syncIfNeeded];
   
}
-(void) globals:(Globals *)global didFinishedAuthenticating:(id)object
{
    global.delegate = nil;
    [self syncIfNeeded];

   
}

-(void) callSync
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // Perform long running process
        
    DBRepository * repo =  [[DBRepository alloc] init];
    SLFHttpClient * httpClient = [SLFHttpClient createSLFHttpClient];
    httpClient.delegate = self;
    // start syncing
    SLFSubscriptionsRequest * slfSubscriptionsRequest = [[SLFSubscriptionsRequest alloc] init];
    
    slfSubscriptionsRequest.groups = [repo getAllGroupsForSync];
    slfSubscriptionsRequest.subscriptions = [repo getAllSubscriptionsForSync];
    
    
    
    if ([slfSubscriptionsRequest.groups count] > 0 || [slfSubscriptionsRequest.subscriptions count] > 0) {
        
        
        [httpClient postSubscriptions:slfSubscriptionsRequest];
        
    }
        
     });
        
}
-(void) slfHTTPClient:(SLFHttpClient *)client didFinishedWithPullingAndUpdating:(id)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self refreshRefreshControl];
        // Update the UI
        // end progress notification
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        client.delegate= nil;
        DBRepository * repo =  [[DBRepository alloc] init];
        self.groups = [repo getAllGroups];
        [self.tableView reloadData];
        
    });
    
   
    
}
-(void) slfHTTPClient:(SLFHttpClient *)client didFailWithError:(NSError *)error
{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self refreshRefreshControl];
        // Update the UI
        // end progress notification
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        NSLog(@"Network error:   %@",   [error userInfo]);
        
        client.delegate  = nil;
        
        [self showMessage:[NSString stringWithFormat:@"Network Error : %@ ",[error userInfo] ]
                withTitle:@"Error"];
        
    });
    
   
    
}

-(IBAction)onRemove :(id)sender
{
    
    [self.tableView setEditing:!self.editing animated:TRUE];
    
    self.editing = !self.editing;
   /*
    if(self.editing)
        self.leftButtonRemove.title = @"Stop";
    else
        self.leftButtonRemove.title = @"Delete";
    */
}

-(IBAction)onNew	 :(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NewGroupViewController *vc = (NewGroupViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NewGroup"];
    
    
    [self.navigationController pushViewController:vc animated:TRUE];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    // If row is deleted, remove it from the list.

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] delegate];
        DBRepository * repo =  [[DBRepository alloc] init];
        SLFGroup* group = (SLFGroup*) [self.groups objectAtIndex:[indexPath row]];
        
        group.toDelete =  true;
        //[controller removeObjectFromListAtIndex:indexPath.row];

        [repo saveGroup:group syncStatus:0];
        
       // [repo disableAllSubscriptionsForGroup:group.iDProperty];
        
        [repo markAllSubscriptionsToDeleteForGroup:group.iDProperty];
        
        self.groups = [repo getAllGroups];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

        [self callSync];
    }

}



-(CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    
    
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DefaultCell"];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    
    
    SLFGroup * group = self.groups[indexPath.row];
    
    cell.textLabel.textColor = UIColorFromRGB(0xC43947);
    cell.textLabel.font  = [UIFont boldSystemFontOfSize:16.];
    
    cell.textLabel.text = group.name;
    cell.detailTextLabel.text= !group.active ? @"Disabled":@"";
    
    return cell;

}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NewGroupViewController *vc = (NewGroupViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NewGroup"];
    SLFGroup * group = [self.groups objectAtIndex:indexPath.row];
        
    [vc initWithGroup:group];
    
    [self.navigationController pushViewController:vc animated:TRUE];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.groups)
        return [self.groups count];
    else
        return 0;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
