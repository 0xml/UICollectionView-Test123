//
//  SectionPerson+CoreDataProperties.h
//  UICollectionView
//
//  Created by Pawel Ropa on 18/04/16.
//  Copyright © 2016 Pawel Ropa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SectionPerson.h"

NS_ASSUME_NONNULL_BEGIN

@interface SectionPerson (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *givenName;
@property (nullable, nonatomic, retain) NSString *familyName;
@property (nullable, nonatomic, retain) Contact *contact;

@end

NS_ASSUME_NONNULL_END
