//
//  NewGroupViewController.h
//  Ticket monitor
//
//  Created by Administrator on 01/02/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLFGroup.h"

@interface NewGroupViewController : UIViewController


@property (strong, nonatomic) IBOutlet UIBarButtonItem * rightButtonSave;
@property (strong, nonatomic) IBOutlet UITextField * txtName;
@property (strong, nonatomic) IBOutlet UISwitch * orSwitch;
@property (strong, nonatomic)  SLFGroup * group;

-(IBAction)onSave :(id)sender;

-(BOOL) validateName;

-(void) initWithGroup:(SLFGroup*) group;

@end
