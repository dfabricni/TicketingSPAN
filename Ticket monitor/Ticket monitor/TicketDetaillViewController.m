//
//  TicketDetaillViewController.m
//  Ticket monitor
//
//  Created by Administrator on 15/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import "TicketDetaillViewController.h"
#import "DBRepository.h"
#import "SLFHttpClient.h"
#import "Globals.h"
#import <MessageUI/MessageUI.h>
#import "QuartzCore/QuartzCore.h"
#import "TicketDetailViewCell.h"

@interface TicketDetaillViewController ()

@end

@implementation TicketDetaillViewController


-(void) initWithTicketDetail:(SLFTicketDetail*) ticketDetail
{
   
  
    self.ticketGUID = ticketDetail.gUID;
    self.ticketDetail = ticketDetail;
      
    [self refreshTicketDetail];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

-(void) refreshTicketDetail
{
    if(self.ticketDetail==nil )
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        
         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.1), dispatch_get_main_queue(), ^{
        //trz pull from server
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString * username = [userDefaults objectForKey:@"SLFUsername"];
             
        SLFHttpClient * httpClient =  [SLFHttpClient createSLFHttpClient];
        httpClient.delegate = self;
        [httpClient getDetailByGUID:self.ticketGUID username:username];
             
    });
        
    }else{
        
        [self showTicketDetail];
    }
}

-(void) initWithDetails:(NSMutableArray*) details currentIndex:(long) index
{
    self.currentIndex =  index;
    self.ticketDetail = (SLFTicketDetail*) [details objectAtIndex:index];
    self.details  = details;
    
    [self refreshTicketDetail];
    
}
-(void) initWithTicketDetailID:(NSString *)guid
{
   
        self.ticketGUID = guid;
        DBRepository * repo =  [[DBRepository alloc] init];    
        self.ticketDetail = [repo getTicketDetail:guid];
   
        [self refreshTicketDetail];
    
}

-(void) showTicketDetail
{
   
    if(self.ticketDetail)
    {
       // if (self.segmentedControl.selectedSegmentIndex == 0 )
      //  {
        self.title = self.ticketDetail.ticketTitle;
            self.textView.text = [NSString stringWithFormat:@"%@  \n %@ ",self.ticketDetail.detailDescription, self.ticketDetail.detailNote ];
            self.ticketMasterTextView.text=self.ticketDetail.ticketMasterDescription;
      //  }
      //  else {
            
            [self.tableView  reloadData];
      //  }
 
    
    [[[DBRepository alloc] init] markTicketAsRead:self.ticketDetail.gUID];
        
    }else
    {
        self.textView.text = @"";
    }

   
    
}

-(void) viewDidAppear:(BOOL)animated
{
    Globals * globals  = [Globals instance];
    if([globals needsReauthentication])
        return;
    
    [self showTicketDetail];

}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = false;
    self.ticketMasterTextView.scrollEnabled = false;
    self.infoView.scrollEnabled = true;
    self.infoView.contentSize = CGSizeMake(self.view.frame.size.width, self.tableView.frame.size.height + self.ticketMasterTextView.frame.size.height);
    self.infoView.layer.zPosition = -1;
    
    self.btnPrevious.layer.borderWidth = 1.0f;
    self.btnPrevious.layer.borderColor = self.view.tintColor.CGColor;
    self.btnPrevious.layer.cornerRadius= 5.0f;
    
    self.btnNext.layer.borderWidth = 1.0f;
    self.btnNext.layer.borderColor = self.view.tintColor.CGColor;
    self.btnNext.layer.cornerRadius= 5.0f;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
}

-(void)showMessage:(NSString*)message withTitle:(NSString *)title
{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        //do something when click button
    }];
    [alert addAction:okAction];
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:alert animated:YES completion:nil];
}

-(void) slfHTTPClient:(SLFHttpClient *)client didFailWithError:(NSError *)error
{
   // dispatch_async(dispatch_get_main_queue(), ^{
        
    NSLog(@"Network error:   %@",   [error userInfo]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    client.delegate  = nil;
    
    [self showMessage:[NSString stringWithFormat:@"Error retrieving ticket: %@ ",[error userInfo] ]
            withTitle:@"Error"];
 // });
}
-(void)slfHTTPClient:(SLFHttpClient *)client didFinishedWithPullingAndUpdating:(id)object
{
     //dispatch_async(dispatch_get_main_queue(), ^{
         
         DBRepository * repo =  [[DBRepository alloc] init];
         self.ticketDetail = [repo getTicketDetail:self.ticketGUID];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         client.delegate = nil;
         [self showTicketDetail];
         
   // });
}


-(IBAction)segmentChangeViewValueChanged:(UISegmentedControl *)SControl
{
     if (SControl.selectedSegmentIndex==0)
    {
        self.textView.hidden  = false;
        self.btnNext.hidden= false;
        self.btnPrevious.hidden = false;
        self.infoView.hidden = true;
      
        
        
    }
   /* else if (SControl.selectedSegmentIndex==1)
    {
         self.textView.hidden  = false;
         self.infoView.hidden = true;
         self.textView.text  = self.ticketDetail.ticketMasterDescription;
        
    }*/
else if (SControl.selectedSegmentIndex==1)
    {
         self.textView.hidden  = true;
        self.btnNext.hidden= true;
        self.btnPrevious.hidden = true;
         self.infoView.hidden = false;
        
    }
    
    [self showTicketDetail];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TicketDetailViewCell *cell =  (TicketDetailViewCell*)[tableView dequeueReusableCellWithIdentifier:@"TicketDetailTableViewCell"];
    DBRepository * repo =  [[DBRepository alloc] init];
    
    if (cell == nil) {
        
        cell = [[TicketDetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TicketDetailTableViewCell"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize: 13.];
    
   if (indexPath.row == 0) {
       cell.lblCaption.text = @"Ticket:";
       if (self.ticketDetail) {
           
           cell.lblValue.text = [NSString stringWithFormat:@"%@", self.ticketDetail.ticketTitle ];
           
       }
   }
    
    if (indexPath.row == 1) {
        
        //assigned to
        cell.lblCaption.text = @"Status:";
        if (self.ticketDetail) {
            
            cell.lblValue.text = [NSString stringWithFormat:@"%@", self.ticketDetail.status ];
            
        }
        
    }
    
    
    if (indexPath.row == 2) {
        
       // cell.textLabel.text = [NSString stringWithFormat:@"Company: " ];
        cell.lblCaption.text = @"Company:";
        if(self.ticketDetail && self.ticketDetail.companyID > 0){
            
            NSString * name = [repo getCodeItemName:@"Company" identifer:self.ticketDetail.companyID];
            
            if(name)
            {
                cell.lblValue.text = [NSString stringWithFormat:@"%@", name ];
            } 
            
        }
    }
    
    
    
    
            
        if (indexPath.row == 3) {
            
            cell.lblCaption.text = @"Service:";
           // cell.textLabel.text = [NSString stringWithFormat:@"Service: " ];
            
            if(self.ticketDetail &&  self.ticketDetail.serviceID > 0){
                
                NSString * name = [repo getCodeItemName:@"Service" identifer:self.ticketDetail.serviceID];
                
                if(name)
                {
                    cell.lblValue.text = [NSString stringWithFormat:@"%@", name ];
                }
                
            }
        }
    
      if (indexPath.row == 4) {
          
           cell.lblCaption.text = @"Category:";
          //  cell.textLabel.text = [NSString stringWithFormat:@"Subject: " ];
          
            if(self.ticketDetail &&  self.ticketDetail.subjectID > 0){
                
                NSString * name = [repo getCodeItemName:@"Subject" identifer:self.ticketDetail.subjectID];
                
                if(name)
                {
                    cell.lblValue.text = [NSString stringWithFormat:@"%@", name ];
                }
                
            }
            
      }
    
      if (indexPath.row == 5) {
          
           // cell.textLabel.text = [NSString stringWithFormat:@"Priority: " ];
           cell.lblCaption.text = @"Priority:";
            if(self.ticketDetail &&  self.ticketDetail.priorityID > 0){
                
                int priority = self.ticketDetail.priorityID;
                
                if (priority == 9) {
                    cell.lblValue.text =@"1";
                }
                if (priority == 8) {
                    cell.lblValue.text =@"2";
                }
                if (priority == 7) {
                    cell.lblValue.text =@"3";
                }
                if (priority == 6) {
                    cell.lblValue.text =@"4";
                }
               
            }
            
      }
    
    if (indexPath.row == 6) {
        
         cell.lblCaption.text = @"Time:";
        
        if (self.ticketDetail) {
            NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            
            NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
            [dateFormater setTimeZone:gmt];
            dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            
            NSDate* date= [dateFormater dateFromString: self.ticketDetail.datetime];
            
            dateFormater.dateFormat =  @"dd.MM. HH:mm:ss";
            [dateFormater setTimeZone:outputTimeZone];
            
            cell.lblValue.text = [NSString stringWithFormat:@"%@",[dateFormater stringFromDate:date] ];
        }else{
            cell.lblValue.text = [NSString stringWithFormat:@"" ];
        }
       
               
    }
    
    if (indexPath.row == 7) {
        
        //assigned to
         cell.lblCaption.text = @"Assigned to:";
        if (self.ticketDetail) {
            
             cell.lblValue.text = [NSString stringWithFormat:@"%@", self.ticketDetail.ticketAssignedTo ];
            
        }
        
    }
    
    if (indexPath.row == 8) {
        
        // modified by
        cell.lblCaption.text = @"Modified by:";
        
        if (self.ticketDetail) {
           
            cell.lblValue.text = [NSString stringWithFormat:@"%@", self.ticketDetail.modifiedBy ];
            
        }
        
    }
    
    
    
    
    return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

-(CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 25;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)onPrevious :(id)sender
{
    if(!self.details)
    {
         [self previousFromDB];
    }
    else{
    
        [self previousFromArray];
    }
    
}
-(void) previousFromArray
{
    self.btnNext.enabled = true;
    
    if(self.currentIndex < [self.details count]-1){
        
        self.currentIndex++;
          self.ticketDetail = nil;
        self.ticketDetail = (SLFTicketDetail*)[self.details objectAtIndex:self.currentIndex];
        [self showTicketDetail];
        
        if(self.currentIndex == [self.details count]-1)
        {
            self.btnPrevious.enabled = false;
        }
        
    }else
    {
        self.btnPrevious.enabled = false;
    }
    
    
}
-(void) previousFromDB
{
    self.btnNext.enabled = true;
    
    DBRepository * repo =  [[DBRepository alloc] init];
    SLFTicketDetail * detail =  [repo getPreviousTicketDetail:self.ticketDetail.datetimeInSeconds];
    if(detail)
    {
        self.ticketDetail = nil;
        self.ticketDetail = detail;
        [self showTicketDetail];
    }else
    {
        self.btnPrevious.enabled = false;
    }

}
-(IBAction)onNext :(id)sender
{
    if(!self.details)
    {
        [self nextFromDB];
    }else{
    
        [self nextFromArray];
    }
    
}
-(void) nextFromArray
{
    self.btnPrevious.enabled = true;
    
    if(self.currentIndex > 0){
        
        self.currentIndex--;
        
        self.ticketDetail = nil;
        self.ticketDetail = (SLFTicketDetail*)[self.details objectAtIndex:self.currentIndex];
        [self showTicketDetail];
        
        if(self.currentIndex == 0)
        {
            self.btnNext.enabled = false;
        }

        
    }else
    {
        self.btnNext.enabled = false;
    }
}
-(void) nextFromDB
{
    self.btnPrevious.enabled = true;
    
    DBRepository * repo =  [[DBRepository alloc] init];
    SLFTicketDetail * detail =  [repo getNextTicketDetail:self.ticketDetail.datetimeInSeconds];
    if(detail)
    {
        self.ticketDetail = nil;
        self.ticketDetail = detail;
        [self showTicketDetail];
    }else
    {
        self.btnNext.enabled = false;
    }
}

-(IBAction) onRespond:(id) sender
{
    /*
    if (![MFMailComposeViewController canSendMail]) {
		   NSLog(@"Mail services are not available.");
		   return;
    }

    
    MFMailComposeViewController* composeVC = [[MFMailComposeViewController alloc] init];
		composeVC.mailComposeDelegate = self;
		 
		// Configure the fields of the interface.
		[composeVC setToRecipients:@[@"ServiceDeskApp@span.eu"]];
    
		[composeVC setSubject:[NSString stringWithFormat:@"%@ *ref#24-%d", self.ticketDetail.ticketTitle, self.ticketDetail.ticketID]];
		[composeVC setMessageBody:@"" isHTML:NO];
		 
		// Present the view controller modally.
		[self presentViewController:composeVC animated:YES completion:nil];
    
    */
    
    NSString *toEmail=@"ServiceDeskApp@span.eu";
    NSString *subject=[NSString stringWithFormat:@"%@ *ref#24-%d", self.ticketDetail.ticketTitle, self.ticketDetail.ticketID];
    NSString *body = @"";

   
   //: NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    UIAlertController * actions=   [UIAlertController
                                    alertControllerWithTitle:nil
                                    message:nil
                                    preferredStyle:UIAlertControllerStyleActionSheet];
    
    
    UIAlertAction * microsoftOutlookAction = [UIAlertAction actionWithTitle:@"Microsoft Outlook" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        NSString * email = [NSString stringWithFormat:@"ms-outlook://compose?to=%@&subject=%@&body=%@", toEmail, subject, body];
        email = [email stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
        
    }];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"ms-outlook://"]]) {

     [actions addAction:microsoftOutlookAction];
    }
    
     UIAlertAction *mailActionAction = [UIAlertAction actionWithTitle:@"Mail" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
    
         NSString *email = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@", toEmail,subject,body];
         email = [email stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
         [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
        
    }];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mailto://"]]) {

        [actions addAction:mailActionAction];
    }
    
    
    UIAlertAction *gmailAction = [UIAlertAction actionWithTitle:@"Gmail" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
      
        NSString *email = [NSString stringWithFormat:@"googlegmail:///co?to=%@&subject=%@&body=%@", toEmail,subject,body];
        email = [email stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
        
    }];
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"googlegmail://"]]) {

        [actions addAction:gmailAction];
    }
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
       
        
    }];
    [actions addAction:cancelAction];
    
    
    UIViewController *vc = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    [vc presentViewController:actions animated:YES completion:nil];
    

}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:TRUE completion:nil];
    
}

@end
