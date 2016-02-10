//
//  SecondViewController.h
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLFHttpClient.h"
#import "Synchronizer.h"

@interface SecondViewController : UITableViewController<SLFHttpClientDelegate>

@property (strong, nonatomic) NSMutableArray * groups;


@property (strong, nonatomic) IBOutlet UIBarButtonItem * rightButtonNEW;
//@property (strong, nonatomic) IBOutlet UIBarButtonItem * leftButtonRemove;
@property (assign, nonatomic) BOOL  editing;

-(IBAction)onNew :(id)sender;
-(IBAction)onRemove :(id)sender;

@end



