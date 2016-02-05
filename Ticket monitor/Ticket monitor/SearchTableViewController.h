//
//  SearchTableViewController.h
//  Ticket monitor
//
//  Created by Administrator on 05/02/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, SLFFilterType) {
    SLFCompanyFilter = 0,
    SLFSubjectFilter = 1,
    SLFServiceFilter = 2
    
};


@interface SearchTableViewController : UITableViewController


@property (strong, nonatomic) IBOutlet UISearchBar * searchBar;
@property (assign, nonatomic)  SLFFilterType  FilterType;
@property (strong, nonatomic)  NSMutableArray * items;

@property (assign, nonatomic)  long  checkedIndex;

-(void) initCustom;
@end
