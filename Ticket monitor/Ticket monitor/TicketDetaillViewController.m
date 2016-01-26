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

@interface TicketDetaillViewController ()

@end

@implementation TicketDetaillViewController


-(void) initWithTicketDetail:(SLFTicketDetail*) ticketDetail
{
   
  
    self.ticketGUID = ticketDetail.gUID;
    self.ticketDetail = ticketDetail;
      
    
}

-(void) initWithTicketDetailID:(NSString *)guid
{
   
        self.ticketGUID = guid;
        DBRepository * repo =  [[DBRepository alloc] init];    
        self.ticketDetail = [repo getTicketDetail:guid];
   
}

-(void) showTicketDetail
{
    self.textView.text = [NSString stringWithFormat:@"%@  \n %@ ",self.ticketDetail.detailDescription, self.ticketDetail.detailNote ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // get from server if there is none here
    if(!self.ticketDetail )
    {
        //trz pull from server
        SLFHttpClient * httpClient =  [SLFHttpClient sharedSLFHttpClient];
        httpClient.delegate = self;
        [httpClient getDetailByGUID:self.ticketGUID];
    }else{
        
        [self showTicketDetail];
    }
    
    
    
}
-(void)slfHTTPClient:(SLFHttpClient *)client didFinishedWithPullingAndUpdating:(id)object
{
    
    DBRepository * repo =  [[DBRepository alloc] init];
    self.ticketDetail = [repo getTicketDetail:self.ticketGUID];
    
    client.delegate = nil;
    [self showTicketDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
