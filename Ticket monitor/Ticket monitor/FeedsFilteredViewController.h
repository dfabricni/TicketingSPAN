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
#import "FirstViewController.h"
#import "DataModels.h"



@interface FeedsFilteredViewController : UITableViewController<SLFHttpClientDelegate,SynchronizerDelegate,OAuthTokenRefresherDelegate>


@property (strong, nonatomic) NSMutableArray * details;

@property (nonatomic, assign) FeedTableType  feedTableType;

@property (nonatomic, strong) SLFGroupedItem *  groupedItem;

-(void) initWithGroupingData:(SLFGroupedItem*) groupedItem feedTableType:(FeedTableType) type;


//-(void) logIn;

-(void) getMoreFeeds;

-(void) invalidateTableView;

-(void)showMessage:(NSString*)message withTitle:(NSString *)title;

-(void) refreshRefreshControl;



@end




