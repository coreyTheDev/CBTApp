//
//  CBTSessionViewController.m
//  CBTApp
//
//  Created by Corey Zanotti on 10/17/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import "CBTSessionViewController.h"
#import "CBTSectionTableViewCell.h"

@interface CBTSessionViewController ()
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation CBTSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:[self.dateFormatter stringFromDate:[NSDate new]]];
    [self.navigationItem.leftBarButtonItem setTitle:@""];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CBTSectionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBT_TABLEVIEW_CELL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Property Declarations - 
-(NSDateFormatter *)dateFormatter
{
    if (!_dateFormatter)
    {
        _dateFormatter = [[NSDateFormatter alloc]init];
        [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [_dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    return _dateFormatter;
}

-(CBTSession *)cbtSession
{
    if (!_cbtSession)
    {
        _cbtSession = [[CBTSession alloc]initWithEntity:[NSEntityDescription entityForName:@"CBTSession" inManagedObjectContext:self.managedContext] insertIntoManagedObjectContext:self.managedContext];
    }
    return _cbtSession;
}

#pragma mark - UITableViewDelegate and Datasource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CBTSectionTableViewCell *returnCell = [tableView dequeueReusableCellWithIdentifier:CBT_TABLEVIEW_CELL];
    NSString *placeholderText = @"";
    switch (indexPath.row) {
        case 0:
            placeholderText = self.cbtSession.situation?:@"Situation";
            break;
        case 1:
            placeholderText = self.cbtSession.preMood?:@"Mood Before Session";
            break;
        case 2:
            placeholderText = self.cbtSession.thoughtsList?:@"Automatic Thoughts";
            break;
        case 3:
            placeholderText = self.cbtSession.supportingEvidence?:@"Supporting Evidence";
            break;
        case 4:
            placeholderText = self.cbtSession.evidenceAgainst?:@"Evidence Against";
            break;
        case 5:
            placeholderText = self.cbtSession.postMood?:@"Mood Now";
            break;
        default:
            break;
    }
    [returnCell.mainTextView setText:placeholderText];
    return returnCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}
@end
