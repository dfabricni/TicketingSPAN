//
//  FirstViewController.h
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property ( retain, nonatomic) IBOutlet UIButton * btnLogin;

@property (strong, nonatomic) IBOutlet UITableView * tableView;

@property (strong, nonatomic) NSMutableArray * details;

-(IBAction)logMeIn:(id)sender;

-(void) logIn;

@end




