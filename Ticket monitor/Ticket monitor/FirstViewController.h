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

@interface FirstViewController : UITableViewController<SLFHttpClientDelegate,SynchronizerDelegate>


@property (strong, nonatomic) NSMutableArray * details;

@property (strong, nonatomic) IBOutlet UIView * overlayView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView * indicatorView;

-(void) logIn;

-(void) getMoreFeeds;

-(void) invalidateTableView;

-(void)showMessage:(NSString*)message withTitle:(NSString *)title;

-(void) refreshRefreshControl;

@end




