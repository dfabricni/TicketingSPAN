//
//  SearchTableViewController.h
//  Ticket monitor
//
//  Created by Administrator on 05/02/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSInteger, SLFFilterType) {
    SLFCompanyFilter = 2,
    SLFSubjectFilter = 4,
    SLFServiceFilter = 3
    
};


@interface SearchTableViewController : UITableViewController< UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem * rightButtonDone;
@property (strong, nonatomic) IBOutlet UISearchBar * searchBar;
@property (assign, nonatomic)  SLFFilterType  FilterType;
@property (strong, nonatomic)  NSMutableArray * items;
@property (copy, nonatomic)  NSString * groupID;
@property (weak, nonatomic)  UITableView * searchTableView;
@property (assign, nonatomic)  long  checkedIndex;

@property (assign, nonatomic)  BOOL  isFiltering;
@property (assign, nonatomic)  BOOL  notIn;

-(void) initCustom;

-(IBAction)onDone :(id)sender;

@end
