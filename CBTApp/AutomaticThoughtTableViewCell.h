//
//  AutomaticThoughtTableViewCell.h
//  CBTApp
//
//  Created by Corey Zanotti on 11/15/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import <UIKit/UIKit.h>
#define HOT_THOUGHT_CELL @"HOT_THOUGHT_CELL"
@interface AutomaticThoughtTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *mainTextView;

@end
