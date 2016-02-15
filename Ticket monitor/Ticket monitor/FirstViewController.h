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

@interface FirstViewController : UITableViewController<SLFHttpClientDelegate,SynchronizerDelegate,OAuthTokenRefresherDelegate>


@property (strong, nonatomic) NSMutableArray * details;
@property (strong, nonatomic) IBOutlet UIBarButtonItem * rightButtonNEW;

@property (nonatomic, assign) BOOL  syncNeeded;

//-(void) logIn;

-(void) getMoreFeeds;

-(void) invalidateTableView;

-(void)showMessage:(NSString*)message withTitle:(NSString *)title;

-(void) refreshRefreshControl;

-(IBAction)onRemove :(id)sender;
@end




