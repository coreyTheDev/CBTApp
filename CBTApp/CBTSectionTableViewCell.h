//
//  CBTSectionTableViewCell.h
//  CBTApp
//
//  Created by Corey Zanotti on 10/27/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import <UIKit/UIKit.h>
#define CBT_TABLEVIEW_CELL @"CBT_TABLEVIEW_CELL"
@interface CBTSectionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;

@end
