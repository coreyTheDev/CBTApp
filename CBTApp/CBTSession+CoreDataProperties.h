//
//  CBTSession+CoreDataProperties.h
//  CBTApp
//
//  Created by Corey Zanotti on 10/17/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CBTSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBTSession (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *thoughtsList;
@property (nullable, nonatomic, retain) NSNumber *preMood;
@property (nullable, nonatomic, retain) NSData *supportingEvidence;
@property (nullable, nonatomic, retain) NSData *evidenceAgainst;
@property (nullable, nonatomic, retain) NSData *alternativeThought;
@property (nullable, nonatomic, retain) NSNumber *postMood;
@property (nullable, nonatomic, retain) NSData *preMoodList;

@end

NS_ASSUME_NONNULL_END
