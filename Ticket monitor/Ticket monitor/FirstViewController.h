//
//  FirstViewController.h
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController

@property ( retain, nonatomic) IBOutlet UIButton * btnLogin;

-(IBAction)logMeIn:(id)sender;

-(void) logIn;

@end




