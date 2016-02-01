//
//  NewGroupViewController.m
//  Ticket monitor
//
//  Created by Administrator on 01/02/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import "NewGroupViewController.h"
#import "DBRepository.h"
#import "Globals.h"
#import "SLFHttpClient.h"

#import <QuartzCore/QuartzCore.h>


@interface NewGroupViewController ()

@end

@implementation NewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if(self.group)
    {
        
        self.txtName.text = self.group.name;
        [self.orSwitch setOn:[self.group.groupOperation isEqualToString:@"A"]];

        
        self.txtName.enabled = false;
        self.orSwitch.enabled = false;
        self.rightButtonSave.enabled = false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) initWithGroup:(SLFGroup*) group
{
    self.group=group;
   
    
    
   

}
-(BOOL) validateName
{
    if([self.txtName.text length] ==0)
    {
        self.txtName.layer.cornerRadius=8.0f;
        self.txtName.layer.masksToBounds=YES;
        self.txtName.layer.borderColor=[[UIColor redColor]CGColor];
        self.txtName.layer.borderWidth= 1.0f;

        return false;
    }
    
    return true;
}
-(IBAction)onSave :(id)sender
{
    
    if(![self validateName])
        return;
    
    DBRepository * repo =  [[DBRepository alloc] init];
    if(!self.group){
        self.group = [[SLFGroup alloc]init];
    
        self.group.iDProperty = [[NSUUID UUID] UUIDString];
        self.group.name = self.txtName.text;
        self.group.groupOperation = self.orSwitch.isOn ? @"A" : @"O";
        [repo saveGroup:self.group];
         [self showMessage:@"Do you want to add subscription details?" withTitle:@"Details"];
    }else
    {
        
    }
    

}

-(void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        self.txtName.enabled = false;
        self.orSwitch.enabled = false;
        
        
        // pop up details view
        
        
    }];
    [alert addAction:okAction];
    
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
        
        [self.navigationController popViewControllerAnimated:true];
    }];
    [alert addAction:noAction];
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
    
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
