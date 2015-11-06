//
//  CBTListTableViewController.m
//  CBTApp
//
//  Created by Corey Zanotti on 10/17/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import "CBTListTableViewController.h"
#import "CBTBase.h"
#import "CBTSessionViewController.h"

#define CBT_TABLEVIEW_CELL @"CBT_TABLEVIEW_CELL"

#define HEIGHT_OF_TABLEVIEW_CELL 55.0

@interface CBTListTableViewController ()
@property (strong, nonatomic) NSArray *listOfCBTSessions;
@property (strong, nonatomic) NSDateFormatter *dateFormatterForCBTSessions;
-(void)populateListOfCBTSessions;
@end

@implementation CBTListTableViewController
{
    CBTBase *selectedSession;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    [self populateListOfCBTSessions];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationItem setTitle:@"C.B.T. Sessions"];
    [self populateListOfCBTSessions];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Property Methods and Class Functions
-(NSDateFormatter *)dateFormatterForCBTSessions
{
    if (!_dateFormatterForCBTSessions)
    {
        _dateFormatterForCBTSessions = [[NSDateFormatter alloc]init];
        [_dateFormatterForCBTSessions setDateStyle:NSDateFormatterShortStyle];
        [_dateFormatterForCBTSessions setTimeStyle:NSDateFormatterShortStyle];
    }
    return _dateFormatterForCBTSessions;
}

-(void)populateListOfCBTSessions
{
    if (!self.managedContext)
    {
        return;
    }
    //create fetch request for specific items
    NSFetchRequest *requestForCBTSessions = [[NSFetchRequest alloc] initWithEntityName:@"CBTBase"];
    //TODO: need items sorted
    
    //fetch items
    NSError *fetchError = nil;
    self.listOfCBTSessions = [self.managedContext executeFetchRequest:requestForCBTSessions error:&fetchError];
    
    if (fetchError)
    {
        NSLog(@"failed to fetch items");
    }
    
    //realod data
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listOfCBTSessions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CBT_TABLEVIEW_CELL forIndexPath:indexPath];

    CBTBase *cbtSessionForThisCell = [self.listOfCBTSessions objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:cbtSessionForThisCell.name];
    [cell.detailTextLabel setText:[self.dateFormatterForCBTSessions stringFromDate:cbtSessionForThisCell.date]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return HEIGHT_OF_TABLEVIEW_CELL;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedSession = [self.listOfCBTSessions objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"existingSessionViewController" sender:self];
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


#pragma mark - Navigation -

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    CBTSessionViewController *cbtSessionViewController = (CBTSessionViewController*)segue.destinationViewController;
    cbtSessionViewController.managedContext = self.managedContext;
    self.navigationItem.title = @"";
    
    if ([segue.identifier isEqualToString:@"existingSessionViewController"])
    {
        NSFetchRequest *requestForCurrentSession = [NSFetchRequest fetchRequestWithEntityName:@"CBTSession"];
        NSPredicate *predicateForCurrentSession = [NSPredicate predicateWithFormat:@"date == %@",selectedSession.date];
        [requestForCurrentSession setPredicate:predicateForCurrentSession];
        
        NSError *fetchError;
        NSArray *results;
        results = [self.managedContext executeFetchRequest:requestForCurrentSession error:&fetchError];
        
        if (fetchError)
        {
            NSLog(@"Couldn't find corresponding session");
        }
        else
        {
            cbtSessionViewController.cbtSession = [results lastObject];
        }
    }
}

@end
