//
//  CBTSessionViewController.m
//  CBTApp
//
//  Created by Corey Zanotti on 10/17/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import "CBTSessionViewController.h"
#import "CBTSectionTableViewCell.h"

#define PLACEHOLDER_TEXT_SITUATION @"What's going on?"
#define PLACEHOLDER_TEXT_PREMOOD @"How are you feeling?"
#define PLACEHOLDER_TEXT_AUTOMATIC_THOUGHTS @"List your thoughts"
#define PLACEHOLDER_TEXT_HOT_THOUGHT @"What thought is bothering you the most?"
#define PLACEHOLDER_TEXT_SUPPORTING_EVIDENCE @"What supports this thought?"
#define PLACEHOLDER_TEXT_EVIDENCE_AGAINST @"What doesn't support this thought"
#define PLACEHOLDER_TEXT_ALTERNATIVE_THOUGHT @"Is there an alternative thought that is closer to the truth?"
#define PLACEHOLDER_TEXT_POST_MOOD @"How are you feeling now?"


@interface CBTSessionViewController () <UITextViewDelegate>
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation CBTSessionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:[self.dateFormatter stringFromDate:[NSDate new]]];
    [self.navigationItem.leftBarButtonItem setTitle:@""];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CBTSectionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBT_TABLEVIEW_CELL];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 110;
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
    NSString *mainText = @"";
    
    switch (indexPath.row) {
        case 0:
            mainText = self.cbtSession.situation?:PLACEHOLDER_TEXT_SITUATION;
            placeholderText = @"Situation";
            break;
        case 1:
            mainText = self.cbtSession.preMood?:PLACEHOLDER_TEXT_PREMOOD;
            placeholderText = @"Mood";
            break;
        case 2:
            placeholderText = @"Automatic Thoughts";
            mainText = self.cbtSession.thoughtsList?:PLACEHOLDER_TEXT_AUTOMATIC_THOUGHTS;
            break;
        case 3:
            placeholderText = @"Hot Thought";
            mainText = self.cbtSession.hotThought?:PLACEHOLDER_TEXT_HOT_THOUGHT;
            break;
        case 4:
            placeholderText = @"Supporting Evidence";
            mainText = self.cbtSession.supportingEvidence?:PLACEHOLDER_TEXT_SUPPORTING_EVIDENCE;
            break;
        case 5:
            placeholderText = @"Evidence Against";
            mainText = self.cbtSession.evidenceAgainst?:PLACEHOLDER_TEXT_AUTOMATIC_THOUGHTS;
            break;
        case 6:
            placeholderText = @"Alternative Thought";
            mainText = self.cbtSession.alternativeThought?:PLACEHOLDER_TEXT_ALTERNATIVE_THOUGHT;
            break;
        case 7:
            placeholderText = @"Mood Now";
            mainText = self.cbtSession.postMood?:PLACEHOLDER_TEXT_POST_MOOD;
        default:
            break;
    }
    [returnCell.sectionLabel setText:placeholderText];
    [returnCell.mainTextView setText:mainText];
    [returnCell.mainTextView setDelegate:self];
    returnCell.mainTextView.tag = indexPath.row;
    
    return returnCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITextViewDelegate Methods
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACEHOLDER_TEXT_POST_MOOD] || [textView.text isEqualToString:PLACEHOLDER_TEXT_ALTERNATIVE_THOUGHT] || [textView.text isEqualToString:PLACEHOLDER_TEXT_AUTOMATIC_THOUGHTS] || [textView.text isEqualToString:PLACEHOLDER_TEXT_EVIDENCE_AGAINST] || [textView.text isEqualToString:PLACEHOLDER_TEXT_HOT_THOUGHT] || [textView.text isEqualToString:PLACEHOLDER_TEXT_PREMOOD] || [textView.text isEqualToString:PLACEHOLDER_TEXT_SITUATION] || [textView.text isEqualToString:PLACEHOLDER_TEXT_SUPPORTING_EVIDENCE])
    {
        textView.text = @"";
    }
    
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    /*
     //everytime the text is changed we need to adjust the height of the view
     self.userProfile.about = textView.text
     let aboutHeaderCell = self.tableView.headerViewForSection(6) as! EditProfileTableViewHeader
     let widthConstraint = NSLayoutConstraint(item: aboutHeaderCell.expandingTextView!, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem:nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: (aboutHeaderCell.expandingTextView?.frame.size.width)!)
     
     aboutHeaderCell.addConstraint(widthConstraint)
     let size = aboutHeaderCell.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
     aboutHeaderCell.removeConstraint(widthConstraint)
     if ((size.height + 1.0) != aboutHeaderCell.frame.size.height)
     {
     print ("frame of about cell before adjustment = %d", aboutHeaderCell.frame)
     print ("frame of text view before adjustment = %d", aboutHeaderCell.expandingTextView!.frame)
     //            aboutHeaderCell.frame.size.height = size.height + 1.0;
     //            aboutHeaderCell.layoutIfNeeded()
     
     self.tableView.reloadSections(NSIndexSet(indexesInRange: NSMakeRange(7, 4)), withRowAnimation: .None)
     print ("frame of about cell after adjustment = %d", aboutHeaderCell.frame)
     print ("frame of text view after adjustment = %d", aboutHeaderCell.expandingTextView!.frame)
     
     
     aboutHeaderCell.frame.size.height = size.height + 1.0;
     aboutHeaderCell.layoutIfNeeded()
     }

     */
}
@end
