//
//  TicketDetaillViewController.h
//  Ticket monitor
//
//  Created by Administrator on 15/01/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModels.h"
#import "SLFHttpClient.h"


@interface TicketDetaillViewController : UIViewController<SLFHttpClientDelegate,UITableViewDataSource, UITableViewDelegate>


@property (strong, nonatomic) IBOutlet UISegmentedControl * segmentedControl;
@property (strong, nonatomic) IBOutlet UITextView * textView;
@property (strong, nonatomic) IBOutlet UIView * infoView;
@property (strong, nonatomic) IBOutlet UITextView * ticketMasterTextView;
@property (strong, nonatomic) IBOutlet UITableView * tableView;
@property (strong, nonatomic)  SLFTicketDetail * ticketDetail;

/*
@property (strong, nonatomic) IBOutlet UILabel * lblCompany;
@property (strong, nonatomic) IBOutlet UILabel * lblService;
@property (strong, nonatomic) IBOutlet UILabel * lblSubject;
@property (strong, nonatomic) IBOutlet UILabel * lblPriority;
*/

//@property (strong, nonatomic)  SLFSubject * ticketSubject;
//@property (strong, nonatomic)  SLFService * ticketService;
//@property (strong, nonatomic)  SLFCompany * ticketCompany;

@property (copy, nonatomic)  NSString * ticketGUID;

-(void) initWithTicketDetail:(SLFTicketDetail*) ticketDetail;

-(void) initWithTicketDetailID:(NSString *)guid;

-(void) showTicketDetail;
//-(void) showTicketInfo;
-(void) refreshTicketDetail;

-(IBAction)segmentChangeViewValueChanged:(UISegmentedControl *)SControl;

-(void)showMessage:(NSString*)message withTitle:(NSString *)title;

@end
