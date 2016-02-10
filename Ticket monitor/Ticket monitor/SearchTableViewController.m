//
//  SearchTableViewController.m
//  Ticket monitor
//
//  Created by Administrator on 05/02/16.
//  Copyright © 2016 Domagoj Fabricni. All rights reserved.
//

#import "SearchTableViewController.h"
#import "DBRepository.h"
#import "Globals.h"
#import "SLFHttpClient.h"
#import "DataModels.h"

@interface SearchTableViewController ()

@end

@implementation SearchTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isFiltering = false;
    self.searchBar.delegate = self;
    self.searchBar.showsCancelButton= false;
    
    self.tableView.tableHeaderView = self.searchBar;
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) initCustom
{
     DBRepository * repo =  [[DBRepository alloc] init];
    self.isFiltering = false;

    switch (self.FilterType) {
            
        case SLFCompanyFilter:
            
            self.items = [repo getAllCompanies:nil];
            
            break;
        case SLFServiceFilter:
            
            self.items = [repo getAllServices:nil];
            break;
        case SLFSubjectFilter:
            
            self.items = [repo getAllSubjects:nil];
            break;
            
        default:
            break;
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if(self.isFiltering)
    {
        self.searchTableView = tableView;
    }
    NSInteger count = 0;
    count  = [self.items count];
    
    return count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"DefaultCell"];
    
    
    if (cell == nil) {
        
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"DefaultCell"];
    
        
    }
    
    if(self.checkedIndex == indexPath.row)
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else
        cell.accessoryType = UITableViewCellAccessoryNone;
    
    SLFCompany * company = nil;
    SLFService * service = nil;
    SLFSubject * subject = nil;
    
    switch (self.FilterType) {
            
        case SLFCompanyFilter:
            
           company  = (SLFCompany *)[self.items objectAtIndex:indexPath.row];
            cell.textLabel.text = company.name;
            
            break;
        case SLFServiceFilter:
            service = (SLFService*) [self.items objectAtIndex:indexPath.row];
            cell.textLabel.text = service.name;
            break;
        case SLFSubjectFilter:
            
            subject = (SLFSubject*) [self.items objectAtIndex:indexPath.row];
            
            cell.textLabel.text = subject.name;
            
            break;
            
        default:
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     self.checkedIndex = indexPath.row;
    if(self.isFiltering)
    {
        [self.searchTableView  reloadData];
         [self pickIt];
    }
        else
            [self.tableView reloadData];
}

-(void) pickIt
{
    DBRepository * repo =  [[DBRepository alloc] init];
    
    SLFCompany * company = nil;
    SLFService * service = nil;
    SLFSubject * subject = nil;
    NSString * value = nil;
    NSString * valueDisplayText = nil;
    
    switch (self.FilterType) {
            
        case SLFCompanyFilter:
            
            company  = (SLFCompany *)[self.items objectAtIndex:self.checkedIndex];
            value = [ NSString stringWithFormat:@"%d" ,company.ID ];
            valueDisplayText  = company.name;
            
            break;
        case SLFServiceFilter:
            service = (SLFService*) [self.items objectAtIndex:self.checkedIndex];
            value = [ NSString stringWithFormat:@"%d" ,service.ID ];
            valueDisplayText  = service.name;
            break;
        case SLFSubjectFilter:
            
            subject = (SLFSubject*) [self.items objectAtIndex:self.checkedIndex];
            value = [ NSString stringWithFormat:@"%d" ,subject.ID ];
            valueDisplayText  = subject.name;
            
            
            break;
            
        default:
            break;
    }
    
    
    //do something when click button
    NSDateFormatter * dateFormater = [[NSDateFormatter alloc]init];
    dateFormater.dateFormat =  @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    
    SLFSubscription * subs= [[SLFSubscription alloc] init];
    subs.iDProperty = [[NSUUID UUID] UUIDString];
    subs.subscriptionGroupID  =  self.groupID;
    subs.ruleTypeID =  self.FilterType;
    subs.value =  value;
    subs.valueDisplayText = valueDisplayText;
    subs.lastCheckPoint =  [dateFormater stringFromDate:[NSDate date]];
    subs.active = true;
    
    [repo saveSubscription:subs syncStatus:0 ];
    
    //[self dismissViewControllerAnimated:true completion:nil];
    [self.navigationController popViewControllerAnimated:TRUE];
}

-(IBAction)onDone :(id)sender
{
    
   
    [self pickIt];
    
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    DBRepository * repo =  [[DBRepository alloc] init];
    
    self.isFiltering =  ![searchText isEqualToString:@"" ];
    
    
    
    switch (self.FilterType) {
            
        case SLFCompanyFilter:
            
            self.items = [repo getAllCompanies:searchText];
            
            break;
        case SLFServiceFilter:
            
            self.items = [repo getAllServices:searchText];
            break;
        case SLFSubjectFilter:
            
            self.items = [repo getAllSubjects:searchText];
            break;
            
        default:
            break;
    }
    
    self.searchTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.searchTableView reloadData];
    
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
