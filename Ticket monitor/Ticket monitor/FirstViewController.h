//
//  FirstViewController.h
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLFHttpClient.h"
#import "Synchronizer.h"
#import "Globals.h"


typedef NS_ENUM(NSInteger, FeedTableType) {
    NoGrouping = 0,
    GroupByTicket = 1,
    GroupByCompany = 2,
    GroupBySubscription = 3
    
};

@interface FirstViewController : UITableViewController<SLFHttpClientDelegate,SynchronizerDelegate,OAuthTokenRefresherDelegate>


@property (strong, nonatomic) NSMutableArray * details;
@property (strong, nonatomic) IBOutlet UIBarButtonItem * rightButtonNEW;
@property (strong, nonatomic) IBOutlet UIBarButtonItem * leftButtonGroup;

@property (nonatomic, assign) BOOL  syncNeeded;

@property (nonatomic, assign) FeedTableType  feedTableType;


//-(void) logIn;

-(void) getMoreFeeds;

-(void) invalidateTableView;

-(void)showMessage:(NSString*)message withTitle:(NSString *)title;

-(void) refreshRefreshControl;

-(IBAction)onRemove :(id)sender;

-(IBAction)onGroupBy :(id)sender;


-(void) resolveView;

@end




