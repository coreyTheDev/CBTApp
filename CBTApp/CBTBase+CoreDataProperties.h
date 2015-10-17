//
//  CBTBase+CoreDataProperties.h
//  CBTApp
//
//  Created by Corey Zanotti on 10/17/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CBTBase.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBTBase (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *id;

@end

NS_ASSUME_NONNULL_END
