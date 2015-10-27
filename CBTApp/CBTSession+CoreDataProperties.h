//
//  CBTSession+CoreDataProperties.h
//  CBTApp
//
//  Created by Corey Zanotti on 10/27/15.
//  Copyright © 2015 Corey Zanotti. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CBTSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface CBTSession (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *alternativeThought;
@property (nullable, nonatomic, retain) NSString *evidenceAgainst;
@property (nullable, nonatomic, retain) NSString *postMood;
@property (nullable, nonatomic, retain) NSString *preMood;
@property (nullable, nonatomic, retain) NSString *supportingEvidence;
@property (nullable, nonatomic, retain) NSString *thoughtsList;
@property (nullable, nonatomic, retain) NSString *situation;

@end

NS_ASSUME_NONNULL_END
