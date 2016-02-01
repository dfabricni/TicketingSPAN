//
//  SecondViewController.h
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SecondViewController : UITableViewController

@property (strong, nonatomic) NSMutableArray * groups;


@property (strong, nonatomic) IBOutlet UIBarButtonItem * rightButtonNEW;


-(IBAction)onNew :(id)sender;

@end



