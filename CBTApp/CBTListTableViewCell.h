//
//  CBTListTableViewCell.h
//  CBTApp
//
//  Created by Corey Zanotti on 12/2/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import <UIKit/UIKit.h>
#define TABLEVIEW_CELL_CBT_LIST_MAIN @"TABLEVIEW_CELL_CBT_LIST_MAIN"

@interface CBTListTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@end
