//
//  HotThoughtSelectionTableViewController.h
//  CBTApp
//
//  Created by Corey Zanotti on 11/15/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HotThoughtSelectionDelegate <NSObject>
-(void)hotThoughtSelected:(NSString *)hotThought;
@end

@interface HotThoughtSelectionTableViewController : UITableViewController
@property (weak, nonatomic) id<HotThoughtSelectionDelegate> delegate;
@property (strong, nonatomic) NSArray *automaticThoughts;
@end

