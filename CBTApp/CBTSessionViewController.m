//
//  CBTSessionViewController.m
//  CBTApp
//
//  Created by Corey Zanotti on 10/17/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import "CBTSessionViewController.h"
#import "CBTSectionTableViewCell.h"
#import "HotThoughtSelectionTableViewController.h"

#define PLACEHOLDER_TEXT_SITUATION @"What's going on?"
#define PLACEHOLDER_TEXT_PREMOOD @"How are you feeling?"
#define PLACEHOLDER_TEXT_AUTOMATIC_THOUGHTS @"List your thoughts"
#define PLACEHOLDER_TEXT_HOT_THOUGHT @"Select the thought that's bothering you the most."
#define PLACEHOLDER_TEXT_SUPPORTING_EVIDENCE @"What supports this thought?"
#define PLACEHOLDER_TEXT_EVIDENCE_AGAINST @"What doesn't support this thought"
#define PLACEHOLDER_TEXT_ALTERNATIVE_THOUGHT @"Is there an alternative thought that is closer to the truth?"
#define PLACEHOLDER_TEXT_POST_MOOD @"How are you feeling now?"

#define UNICODE_BULLET @"\u2022"



#define NUMBER_OF_CBT_FIELDS 8.0
@interface CBTSessionViewController () <UITextViewDelegate, HotThoughtSelectionDelegate>
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSMutableArray *automaticThoughts;
@end

@implementation CBTSessionViewController
{
    NSInteger sizeOfActiveTextView;
    NSString *temporaryAutomaticThoughtString;
    BOOL inHotThoughtSelection;
    NSArray *automaticThoughts;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(saveDataToContextAndDismissView)]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CBTSectionTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CBT_TABLEVIEW_CELL];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 110;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    temporaryAutomaticThoughtString = @"";
    inHotThoughtSelection = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationItem setTitle:[self.dateFormatter stringFromDate:self.cbtSession.date]];
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
        _cbtSession.date = [NSDate new];
    }
    return _cbtSession;
}
-(NSMutableArray *)automaticThoughts
{
    if (!_automaticThoughts)
        _automaticThoughts = [NSMutableArray new];
    return _automaticThoughts;
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
//            [returnCell.mainTextView setUserInteractionEnabled:NO];
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
    return NUMBER_OF_CBT_FIELDS;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

#pragma mark - UITextViewDelegate Methods

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:PLACEHOLDER_TEXT_POST_MOOD] || [textView.text isEqualToString:PLACEHOLDER_TEXT_ALTERNATIVE_THOUGHT] || [textView.text isEqualToString:PLACEHOLDER_TEXT_AUTOMATIC_THOUGHTS] || [textView.text isEqualToString:PLACEHOLDER_TEXT_EVIDENCE_AGAINST] || [textView.text isEqualToString:PLACEHOLDER_TEXT_PREMOOD] || [textView.text isEqualToString:PLACEHOLDER_TEXT_SITUATION] || [textView.text isEqualToString:PLACEHOLDER_TEXT_SUPPORTING_EVIDENCE])
    {
        textView.text = textView.tag == 0?@"":[NSString stringWithFormat:@"%@ ",UNICODE_BULLET];
    }
    if (textView.tag == 3)
    {
        inHotThoughtSelection = YES;
    }
    if (textView.tag != 0)
    {
        UIToolbar* keyboardToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
        keyboardToolbar.barStyle = UIBarStyleBlackTranslucent;
        UIBarButtonItem *nextItem = [[UIBarButtonItem alloc]initWithTitle:textView.tag+1>=NUMBER_OF_CBT_FIELDS?@"Done":@"Next" style:UIBarButtonItemStyleDone target:self action:@selector(moveToNextItem:)];
        nextItem.tag = textView.tag;
        nextItem.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(dismissTextViewKeyboard)];
        cancelItem.tintColor = [UIColor whiteColor];
        keyboardToolbar.items = [NSArray arrayWithObjects:cancelItem
                                 ,
                                 [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                 nextItem,
                                 nil];
        [keyboardToolbar sizeToFit];
        textView.inputAccessoryView = keyboardToolbar;
    }
    switch (textView.tag) {
        case 0:
        case 3:
            textView.returnKeyType = UIReturnKeyNext;
            break;
        case 1:
        case 2:
        case 4:
        case 5:
        case 6:
            textView.returnKeyType = UIReturnKeyDefault;
            break;
        case 7:
            textView.returnKeyType = UIReturnKeyDone;
            break;
        default:
            break;
    }
    
    sizeOfActiveTextView = textView.text.length;
    return YES;
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    //if a newline character is in the first section remove it and jump to the next section
    if ([textView.text characterAtIndex:textView.text.length-1] == '\n' && textView.tag == 0)
    {
        //save the string if the text contains anything
        if (textView.text.length > 1)
            [self setString:[textView.text substringWithRange:NSMakeRange(0, textView.text.length - 2)] forCBTSection:textView.tag];
        
        textView.text = [textView.text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        CBTSectionTableViewCell *nextTableViewCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:textView.tag + 1 inSection:0]];
        
        [nextTableViewCell.mainTextView becomeFirstResponder];
        
        return;

    }
    CGSize size = textView.bounds.size;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(size.width, CGFLOAT_MAX)];
    
    //This block of code will adjust the scroll position of the uitableview
    CGFloat ceilingOfHeight = ceilf(size.height);
    CGFloat ceilingOfNewHeight = ceilf(newSize.height);
    if (ceilingOfHeight != ceilingOfNewHeight){
        [UIView setAnimationsEnabled:NO];
        [self.tableView beginUpdates];
        [self.tableView endUpdates];
        [UIView setAnimationsEnabled:YES];
        
        NSIndexPath *indexPathForThisCell = [NSIndexPath indexPathForRow:textView.tag inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPathForThisCell atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    //this line of code detects a new line character thats been added to the textview opposed to one thats encountered because of a deletion.
    if (textView.tag == 2)
    {
        temporaryAutomaticThoughtString = [NSString stringWithFormat:@"%@%c",temporaryAutomaticThoughtString,[textView.text characterAtIndex:textView.text.length - 1]];
    }
    if ([textView.text characterAtIndex:textView.text.length-1] == '\n' && sizeOfActiveTextView < textView.text.length)
    {
        if (textView.tag == 2)
        {
            //new automatic thought has been entered we need to grab it and put it in the array
            [self.automaticThoughts addObject:temporaryAutomaticThoughtString];
            temporaryAutomaticThoughtString = @"";
        }
        textView.text = [NSString stringWithFormat:@"%@%@ ",textView.text,UNICODE_BULLET];
    }
    sizeOfActiveTextView = textView.text.length;
}

-(BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - UI Methods
//This method is called when the next button is pressed on the keyboard toolbar
-(void)moveToNextItem:(UIBarButtonItem *)nextBarButtonItem
{
    CBTSectionTableViewCell *thisTableViewCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nextBarButtonItem.tag inSection:0]];
    
    //save the string to the cbt core data model
    [self setString:thisTableViewCell.mainTextView.text forCBTSection:nextBarButtonItem.tag];
    
    //end editing if we're at the end of the list of textviews determined by the tag
    if (nextBarButtonItem.tag + 1 == NUMBER_OF_CBT_FIELDS)
    {
        [self.view endEditing:YES];
    } else if (nextBarButtonItem.tag == 2)//launch the automatic thought selection screen if we're at indexTag == 2
    {
        automaticThoughts = [thisTableViewCell.mainTextView.text componentsSeparatedByString:@"\n"];
        [self performSegueWithIdentifier:@"selectHotThought" sender:self];
    } else
    {
        
        CBTSectionTableViewCell *nextTableViewCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:nextBarButtonItem.tag + 1 inSection:0]];
        
        [nextTableViewCell.mainTextView becomeFirstResponder];
    }
}
-(void)dismissTextViewKeyboard
{
    [self.view endEditing:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[HotThoughtSelectionTableViewController class]])
    {
        HotThoughtSelectionTableViewController *hotThoughtSelectionViewController = segue.destinationViewController;
        hotThoughtSelectionViewController.automaticThoughts = automaticThoughts;
        [hotThoughtSelectionViewController setDelegate:self];
        self.navigationItem.title = @"";
    }
}

#pragma mark - Data Methods
-(void)setString:(NSString *)cbtData forCBTSection:(NSInteger)section
{
    switch (section) {
        case 0:
            self.cbtSession.situation = cbtData;
            break;
        case 1:
            self.cbtSession.preMood = cbtData;
            break;
        case 2:
            self.cbtSession.thoughtsList = cbtData;
            break;
        case 3:
            self.cbtSession.hotThought = cbtData;
            break;
        case 4:
            self.cbtSession.supportingEvidence = cbtData;
            break;
        case 5:
            self.cbtSession.evidenceAgainst = cbtData;
            break;
        case 6:
            self.cbtSession.alternativeThought = cbtData;
            break;
        case 7:
            self.cbtSession.postMood = cbtData;
            break;
        default:
            break;
    }
}

-(void)saveDataToContextAndDismissView
{
    //Attempt to save any existing keyboard input before exiting view
    for (int i = 0; i < NUMBER_OF_CBT_FIELDS; i++)
    {
        CBTSectionTableViewCell *cbtSectionCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        if ([cbtSectionCell.mainTextView isFirstResponder])
        {
            [self setString:cbtSectionCell.mainTextView.text forCBTSection:i];
            break;
        }
    }
    
    
    self.cbtSession.name = self.cbtSession.situation;
    
    NSError *savingError;
    [self.managedContext save:&savingError];
    
    if (savingError)
    {
        NSLog(@"Couldn't save to Core Data");
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HotThoughtSelectionDelegate
-(void)hotThoughtSelected:(NSString *)hotThought
{
    self.cbtSession.hotThought = hotThought;
    [self.navigationController popViewControllerAnimated:YES];
    CBTSectionTableViewCell *hotThoughtCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    [hotThoughtCell.mainTextView setText:hotThought];
    [self.tableView reloadData];
//    CBTSectionTableViewCell *automaticThoughtsCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
//    [automaticThoughtsCell.mainTextView resignFirstResponder];
    CBTSectionTableViewCell *supportingEvidenceCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [supportingEvidenceCell.mainTextView becomeFirstResponder];
}
@end
