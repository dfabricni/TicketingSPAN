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
        //trz pull from server
        SLFHttpClient * httpClient =  [SLFHttpClient sharedSLFHttpClient];
        httpClient.delegate = self;
        [httpClient getDetailByGUID:self.ticketGUID];
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
    self.textView.text = [NSString stringWithFormat:@"%@  \n %@ ",self.ticketDetail.detailDescription, self.ticketDetail.detailNote ];
    
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
    dispatch_async(dispatch_get_main_queue(), ^{
        
    NSLog(@"Network error:   %@",   [error userInfo]);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    client.delegate  = nil;
    
    [self showMessage:@"Error synchronizing data"
            withTitle:@"Error"];
  });
}
-(void)slfHTTPClient:(SLFHttpClient *)client didFinishedWithPullingAndUpdating:(id)object
{
     dispatch_async(dispatch_get_main_queue(), ^{
         
         DBRepository * repo =  [[DBRepository alloc] init];
         self.ticketDetail = [repo getTicketDetail:self.ticketGUID];
         [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
         client.delegate = nil;
         [self showTicketDetail];
         
    });
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

-(void) showTicketInfo
{
    DBRepository * repo =  [[DBRepository alloc] init];
    
    
    if( self.ticketDetail.companyID > 0){
        
       NSString * name = [repo getCodeItemName:@"Company" identifer:self.ticketDetail.companyID];
        
        if(name)
        {
            self.lblCompany.text = name;
        }
        
    }
    
    if( self.ticketDetail.serviceID > 0){
        
         NSString * name = [repo getCodeItemName:@"Service" identifer:self.ticketDetail.serviceID];
        
        if(name)
        {
            self.lblService.text = name;
        }
    }

    if( self.ticketDetail.subjectID > 0){
        
         NSString * name = [repo getCodeItemName:@"Subject" identifer:self.ticketDetail.subjectID];
        
        if(name)
        {
            self.lblSubject.text = name;
        }
    }

    
    if( self.ticketDetail.priorityID > 0){
        
       
        self.lblPriority.text = [NSString stringWithFormat:@"%d", self.ticketDetail.priorityID ];
       
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
