//
//  CBTSessionViewController.h
//  CBTApp
//
//  Created by Corey Zanotti on 10/17/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CBTSession.h"

@interface CBTSessionViewController : UITableViewController
@property (strong, nonatomic) NSString *cbtID;
@property (strong, nonatomic) CBTSession *cbtSession;
@property (strong, nonatomic) NSManagedObjectContext *managedContext;
@end
