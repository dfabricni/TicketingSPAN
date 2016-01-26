//
//  FirstViewController.h
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLFHttpClient.h"

@interface FirstViewController : UITableViewController<SLFHttpClientDelegate>

//@property ( retain, nonatomic) IBOutlet UIButton * btnLogin;

//@property (strong, nonatomic) IBOutlet UITableView * tableView;

@property (strong, nonatomic) NSMutableArray * details;

//@property (nonatomic, strong) UIRefreshControl * refreshControl;

-(IBAction)logMeIn:(id)sender;

-(void) logIn;

-(void) getMoreFeeds;

@end




