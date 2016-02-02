//
//  SecondViewController.m
//  Ticket monitor
//
//  Created by Domagoj Fabricni on 27/11/15.
//  Copyright © 2015 Domagoj Fabricni. All rights reserved.
//

#import "SecondViewController.h"
#import "DBRepository.h"
#import "Globals.h"
#import "SLFHttpClient.h"
#import "NewGroupViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.editing = false;
   // [self.tableView setEditing:TRUE animated:TRUE];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void) viewWillAppear:(BOOL)animated
{
    DBRepository * repo =  [[DBRepository alloc] init];
    
    self.groups = [repo getAllGroups];
    [self.tableView reloadData];	
    
}
-(void) viewDidAppear:(BOOL)animated
{

}
-(IBAction)onRemove :(id)sender
{
    
    [self.tableView setEditing:!self.editing animated:TRUE];
    
    self.editing = !self.editing;
   /*
    if(self.editing)
        self.leftButtonRemove.title = @"Stop";
    else
        self.leftButtonRemove.title = @"Delete";
    */
}

-(IBAction)onNew :(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NewGroupViewController *vc = (NewGroupViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NewGroup"];
    
    
    [self.navigationController pushViewController:vc animated:TRUE];
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    // If row is deleted, remove it from the list.

    if (editingStyle == UITableViewCellEditingStyleDelete) {

        //SimpleEditableListAppDelegate *controller = (SimpleEditableListAppDelegate *)[[UIApplication sharedApplication] delegate];
        DBRepository * repo =  [[DBRepository alloc] init];
        SLFGroup* group = (SLFGroup*) [self.groups objectAtIndex:[indexPath row]];
        
        group.active =  false;
        //[controller removeObjectFromListAtIndex:indexPath.row];

        [repo saveGroup:group];
        self.groups = [repo getAllGroups];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

    }

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
        
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        
    }
    
    
    
    SLFGroup * group = self.groups[indexPath.row];
    
    cell.textLabel.text = group.name;
    cell.detailTextLabel.text= group.groupOperation;
    
    return cell;

}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NewGroupViewController *vc = (NewGroupViewController*)[storyboard instantiateViewControllerWithIdentifier:@"NewGroup"];
    SLFGroup * group = [self.groups objectAtIndex:indexPath.row];
        
    [vc initWithGroup:group];
    
    [self.navigationController pushViewController:vc animated:TRUE];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(self.groups)
        return [self.groups count];
    else
        return 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
