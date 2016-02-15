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
#import "SLFSubscription.h"
#import "SearchTableViewController.h"

#import <QuartzCore/QuartzCore.h>


@interface NewGroupViewController ()

@end

@implementation NewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
   
}

-(void) viewWillAppear:(BOOL)animated
{
    DBRepository * repo =  [[DBRepository alloc] init];
    
    
    if(self.group)
    {
        self.title = @"Edit group";
        self.subscriptions = [repo getAllSubscriptionsForGroup:self.group.iDProperty];
        
        self.txtName.text = self.group.name;
        [self.orSwitch setOn:[self.group.groupOperation isEqualToString:@"A"]];
        
        
        self.txtName.enabled = false;
        self.orSwitch.enabled = false;
        // self.rightButtonSave.enabled = false;
        self.rightButtonSave.title = @"Add";
    }else{
        self.subscriptions  = [[NSMutableArray alloc]init];
    }
    
    [self.tableView reloadData];
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
        self.group.active = TRUE;
        self.group.groupOperation = self.orSwitch.isOn ? @"A" : @"O";
        [repo saveGroup:self.group syncStatus:0];
        
         [self showMessage:@"Do you want to add subscription details?" withTitle:@"Details"];
    }else
    {
        // show actions
        
        [self showActions  ];
        
    }
    

}
-(void) showActions
{
    
  
        // pull existing ones and pull them out of the array
        
     DBRepository * repo =  [[DBRepository alloc] init];
        
      NSMutableArray * existingOnes  = [repo getExistingSubscriptionsTypes:self.group.iDProperty];
        
        
  
    UIAlertController * actions=   [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    if([self.group.groupOperation isEqualToString:@"O"] || (![existingOnes containsObject:[NSNumber numberWithInt:1]] && ![existingOnes containsObject:[NSNumber numberWithInt:2]] && [self.group.groupOperation isEqualToString:@"A"]) )
    {
    
        UIAlertAction *myCompanyAction = [UIAlertAction actionWithTitle:@"Set my company" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
             DBRepository * repo =  [[DBRepository alloc] init];
            
        //do something when click button
            NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
            dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            
            SLFSubscription * subs= [[SLFSubscription alloc] init];
            subs.iDProperty = [[NSUUID UUID] UUIDString];
            subs.subscriptionGroupID  =  self.group.iDProperty;
            subs.ruleTypeID =  1;
            subs.value =  @"1038";
            subs.valueDisplayText = @"SPAN d.o.o.";
            subs.lastCheckPoint =  [dateFormater stringFromDate:[NSDate date]];
            subs.active = true;
            
            [repo saveSubscription:subs syncStatus:0 ];
            self.subscriptions = [repo getAllSubscriptionsForGroup:self.group.iDProperty];
            [self.tableView reloadData];
        
        }];
        [actions addAction:myCompanyAction];
    }
    
    if([self.group.groupOperation isEqualToString:@"O"] || (![existingOnes containsObject:[NSNumber numberWithInt:2]] && ![existingOnes containsObject:[NSNumber numberWithInt:1]] && [self.group.groupOperation isEqualToString:@"A"]) )
    {
        
        UIAlertAction * otherCompanyAction = [UIAlertAction actionWithTitle:@"Set other company" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            SearchTableViewController *vc = (SearchTableViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
            vc.FilterType = SLFCompanyFilter;
            vc.groupID= self.group.iDProperty;
            [vc initCustom];
            [self.navigationController pushViewController:vc animated:TRUE];
            
            
        }];
        [actions addAction:otherCompanyAction];
    }
    
    if([self.group.groupOperation isEqualToString:@"O"] || (![existingOnes containsObject:[NSNumber numberWithInt:3]] && [self.group.groupOperation isEqualToString:@"A"]) )
    {
        
        UIAlertAction * serviceTypeAction = [UIAlertAction actionWithTitle:@"Set service type" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            SearchTableViewController *vc = (SearchTableViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
            vc.FilterType = SLFServiceFilter;
             vc.groupID= self.group.iDProperty;
            [vc initCustom];
            [self.navigationController pushViewController:vc animated:TRUE];
        }];
        [actions addAction:serviceTypeAction];
    }
    
    if([self.group.groupOperation isEqualToString:@"O"] || (![existingOnes containsObject:[NSNumber numberWithInt:4]] && [self.group.groupOperation isEqualToString:@"A"]) )
    {
        
        UIAlertAction * subjectTypeAction = [UIAlertAction actionWithTitle:@"Set subject" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            SearchTableViewController *vc = (SearchTableViewController*)[storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
            vc.FilterType = SLFSubjectFilter;
            vc.groupID= self.group.iDProperty;
            [vc initCustom];
            [self.navigationController pushViewController:vc animated:TRUE];
        }];
        [actions addAction:subjectTypeAction];
    }
    
    if([self.group.groupOperation isEqualToString:@"O"] || (![existingOnes containsObject:[NSNumber numberWithInt:5]] && [self.group.groupOperation isEqualToString:@"A"]) )
    {
        
        UIAlertAction * priorityTypeAction = [UIAlertAction actionWithTitle:@"Set priority type" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
            UIAlertController * alertController=   [UIAlertController
                                                    alertControllerWithTitle:@"Priority"
                                                    message:@"Please enter priority 1 or 2"
                                                    preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
             {
                 textField.placeholder = NSLocalizedString(@"Priority", @"Priority");
                 textField.keyboardType  = UIKeyboardTypeNumberPad;
                 [textField addTarget:self action:@selector(alertTextFieldForPriorityDidChange:)forControlEvents:UIControlEventEditingChanged];
                 textField.delegate = self;
                 
             }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                NSString * enteredValue = alertController.textFields.firstObject.text;
                NSString * valueDisplayText=nil;
                if ([enteredValue isEqualToString:@""]) {
                    
                    return ;
                }
                
                if ([enteredValue isEqualToString:@"1"]) {
                    enteredValue  = @"9";
                    valueDisplayText =@"1";
                }else
                {
                    enteredValue  = @"8";
                    valueDisplayText = @"2";
                }
                //do something when click button
                NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
                dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
                
                SLFSubscription * subs= [[SLFSubscription alloc] init];
                subs.iDProperty = [[NSUUID UUID] UUIDString];
                subs.subscriptionGroupID  =  self.group.iDProperty;
                subs.ruleTypeID =  5;
                subs.value =  enteredValue;
                subs.valueDisplayText = valueDisplayText;
                subs.lastCheckPoint =  [dateFormater stringFromDate:[NSDate date]];
                subs.active = true;
                
                [repo saveSubscription:subs syncStatus:0 ];
                self.subscriptions = [repo getAllSubscriptionsForGroup:self.group.iDProperty];
                [self.tableView reloadData];
                
            }];
            okAction.enabled= false;
            
            [alertController addAction:okAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                
                
                //do something when click button
                
                
            }];
            [alertController addAction:cancelAction];
            
            UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
            [vc presentViewController:alertController animated:YES completion:nil];
            
            

            
        }];
        [actions addAction:priorityTypeAction];
    }
    
    if([self.group.groupOperation isEqualToString:@"O"] || (![existingOnes containsObject:[NSNumber numberWithInt:6]] && [self.group.groupOperation isEqualToString:@"A"]) )
    {
        
        UIAlertAction * ticketAction = [UIAlertAction actionWithTitle:@"Set ticket ID" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
            //do something when click button
            UIAlertController * alertController=   [UIAlertController
                                            alertControllerWithTitle:@"Ticket ID"
                                            message:@"Please enter ticketID"
                                            preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField)
             {
                 textField.placeholder = NSLocalizedString(@"Ticket ID", @"TicketID");
                 textField.keyboardType  = UIKeyboardTypeNumberPad;
                 [textField addTarget:self action:@selector(alertTextFieldForTicketIDDidChange:)forControlEvents:UIControlEventEditingChanged];

             }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                NSString * enteredValue = alertController.textFields.firstObject.text;
                
                if ([enteredValue isEqualToString:@""]) {
                    
                    return ;
                }
                
                
                //do something when click button
                NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
                dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
                
                SLFSubscription * subs= [[SLFSubscription alloc] init];
                subs.iDProperty = [[NSUUID UUID] UUIDString];
                subs.subscriptionGroupID  =  self.group.iDProperty;
                subs.ruleTypeID =  6;
                subs.value =  enteredValue;
                subs.valueDisplayText = enteredValue;
                subs.lastCheckPoint =  [dateFormater stringFromDate:[NSDate date]];
                subs.active = true;
                
                [repo saveSubscription:subs syncStatus:0 ];
                self.subscriptions = [repo getAllSubscriptionsForGroup:self.group.iDProperty];
                [self.tableView reloadData];
                
            }];
            okAction.enabled= false;
            
            [alertController addAction:okAction];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
                
                
                
                //do something when click button
              
                
            }];
            [alertController addAction:cancelAction];
            
            UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
            [vc presentViewController:alertController animated:YES completion:nil];

            
            
        }];
        
        
        
        [actions addAction:ticketAction];
    }
    UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
        //do something when click button
        
    }];
    [actions addAction:cancelAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:actions animated:YES completion:nil];
}

- (void)alertTextFieldForTicketIDDidChange:(UITextField *)sender
{
  UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
  if (alertController)
  {
    UITextField * txtField = alertController.textFields.firstObject;
      UIAlertAction *okAction = [alertController.actions objectAtIndex:0];
   // UIAlertAction *okAction = alertController.actions obj
    okAction.enabled = txtField.text.length > 0;
  }
}

- (void)alertTextFieldForPriorityDidChange:(UITextField *)sender
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController)
    {
        UITextField * txtField = alertController.textFields.firstObject;
        UIAlertAction *okAction = [alertController.actions objectAtIndex:0];
        // UIAlertAction *okAction = alertController.actions obj
        okAction.enabled = txtField.text.length ==  1;
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string  {
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"12"] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
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
        self.rightButtonSave.title = @"Add" ;
        [self showActions  ];
        
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




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.subscriptions)
        return [self.subscriptions count];
    else
        return 0;
}

-(CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    
    
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DefaultCell"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    
    
    SLFSubscription * subscription = self.subscriptions[indexPath.row];
    
    cell.textLabel.text = [self resolveDetailType :subscription.ruleTypeID ];
    
    cell.detailTextLabel.text= subscription.valueDisplayText;
    
    return cell;
    
}

-(NSString*) resolveDetailType:(int) type
{
    switch (type) {
        case 1:
            return @"My company";
            break;
        case 2:
            return @"Company";
            break;
        case 3:
            return @"Service";
            break;
        case 4:
            return @"Subject";
            break;
        case 5:
            return @"Priority";
            break;
        case 6:
            return @"TicketID";
            break;
        default:
            return @"My company";
            break;
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // If row is deleted, remove it from the list.
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        //SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] delegate];
        DBRepository * repo =  [[DBRepository alloc] init];
        SLFSubscription* subscription = (SLFSubscription*) [self.subscriptions objectAtIndex:[indexPath row]];
        
        subscription.active =  false;
        //[controller removeObjectFromListAtIndex:indexPath.row];
        
        [repo saveSubscription:subscription syncStatus:0];
        self.subscriptions = [repo getAllSubscriptionsForGroup:self.group.iDProperty];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
    
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
