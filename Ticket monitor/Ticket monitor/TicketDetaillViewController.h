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


@interface TicketDetaillViewController : UIViewController<SLFHttpClientDelegate>


@property (strong, nonatomic) IBOutlet UISegmentedControl * segmentedControl;
@property (strong, nonatomic) IBOutlet UITextView * textView;

@property (strong, nonatomic)  SLFTicketDetail * ticketDetail;
@property (copy, nonatomic)  NSString * ticketGUID;

-(void) initWithTicketDetail:(SLFTicketDetail*) ticketDetail;

-(void) initWithTicketDetailID:(NSString *)guid;

-(void) showTicketDetail;


@end
