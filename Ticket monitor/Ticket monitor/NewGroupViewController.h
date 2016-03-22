//
//  NewGroupViewController.h
//  Ticket monitor
//
//  Created by Administrator on 01/02/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLFGroup.h"

@interface NewGroupViewController : UIViewController<UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate>


@property (strong, nonatomic) IBOutlet UIBarButtonItem * rightButtonSave;
@property (strong, nonatomic) IBOutlet UITextField * txtName;
@property (strong, nonatomic) IBOutlet UISwitch * enabledSwitch;
@property (strong, nonatomic)  SLFGroup * group;
@property (strong, nonatomic)  NSMutableArray * subscriptions;
@property (strong, nonatomic) IBOutlet UITableView * tableView;

-(IBAction)onSave :(id)sender;

- (IBAction)changeSwitch:(id)sender;


-(BOOL) validateName;

-(void) initWithGroup:(SLFGroup*) group;
-(NSString*) resolveDetailType:(int) type;
@end
