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
        SLFHttpClient * httpClient =  [SLFHttpClient sharedSLFHttpClient];
        httpClient.delegate = self;
        [httpClient getDetailByGUID:self.ticketGUID];
             
    });
        
    }else{
        
        [self showTicketDetail];
    }
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
        if (self.segmentedControl.selectedSegmentIndex == 0 )
        {
            self.textView.text = [NSString stringWithFormat:@"%@  \n %@ ",self.ticketDetail.detailDescription, self.ticketDetail.detailNote ];
        }else if(self.segmentedControl.selectedSegmentIndex == 1){
            self.textView.text=self.ticketDetail.ticketMasterDescription;
        }
        else {
            
            [self.tableView  reloadData];
        }
        
        
        
        
        
        
    
    [[[DBRepository alloc] init] markTicketAsRead:self.ticketDetail.gUID];
    }else
    {
        self.textView.text = @"";
    }

   
    
     [self showTicketInfo];
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
        self.infoView.hidden = true;
        [self showTicketDetail];
        
        
    }
    else if (SControl.selectedSegmentIndex==1)
    {
         self.textView.hidden  = false;
         self.infoView.hidden = true;
         self.textView.text  = self.ticketDetail.ticketMasterDescription;
        
    }
else if (SControl.selectedSegmentIndex==2)
    {
         self.textView.hidden  = true;
         self.infoView.hidden = false;
        [self showTicketInfo];
    }

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    DBRepository * repo =  [[DBRepository alloc] init];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DefaultCell"];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    
   
            
           
    if (indexPath.row == 0) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"Company: " ];
        
        if(self.ticketDetail && self.ticketDetail.companyID > 0){
            
            NSString * name = [repo getCodeItemName:@"Company" identifer:self.ticketDetail.companyID];
            
            if(name)
            {
                cell.textLabel.text = [NSString stringWithFormat:@"Company: %@", name ];
            } 
            
        }
    }
    
    
    
    
            
        if (indexPath.row == 1) {
            
            cell.textLabel.text = [NSString stringWithFormat:@"Service: " ];
            
            if(self.ticketDetail &&  self.ticketDetail.serviceID > 0){
                
                NSString * name = [repo getCodeItemName:@"Service" identifer:self.ticketDetail.serviceID];
                
                if(name)
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"Service: %@", name ];
                }
                
            }
        }
    
      if (indexPath.row == 2) {
          
            cell.textLabel.text = [NSString stringWithFormat:@"Subject: " ];
          
            if(self.ticketDetail &&  self.ticketDetail.subjectID > 0){
                
                NSString * name = [repo getCodeItemName:@"Subject" identifer:self.ticketDetail.subjectID];
                
                if(name)
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"Subject: %@", name ];
                }
                
            }
            
      }
    
      if (indexPath.row == 3) {
          
            cell.textLabel.text = [NSString stringWithFormat:@"Priority: " ];
          
            if(self.ticketDetail &&  self.ticketDetail.priorityID > 0){
                
                int priority = self.ticketDetail.priorityID;
                
                if (priority == 9) {
                    cell.textLabel.text =@"Priority: 1";
                }
                if (priority == 8) {
                    cell.textLabel.text =@"Priority: 2";
                }
                if (priority == 7) {
                    cell.textLabel.text =@"Priority: 3";
                }
                if (priority == 6) {
                    cell.textLabel.text =@"Priority: 4";
                }
               
            }
            
      }
    
    if (indexPath.row == 4) {
        
        if (self.ticketDetail) {
            NSTimeZone *outputTimeZone = [NSTimeZone localTimeZone];
            NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
            
            NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
            [dateFormater setTimeZone:gmt];
            dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
            
            NSDate* date= [dateFormater dateFromString: self.ticketDetail.datetime];
            
            dateFormater.dateFormat =  @"dd.MM. HH:mm:ss";
            [dateFormater setTimeZone:outputTimeZone];
            
            cell.textLabel.text = [NSString stringWithFormat:@"Time: %@",[dateFormater stringFromDate:date] ];
        }else{
            cell.textLabel.text = [NSString stringWithFormat:@"Time: " ];
        }
       
               
    }
    
    
    
    return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

-(CGFloat)  tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


-(void) showTicketInfo
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
