//
//  Contact+CoreDataProperties.h
//  UICollectionView
//
//  Created by Pawel Ropa on 18/04/16.
//  Copyright © 2016 Pawel Ropa. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Contact.h"

NS_ASSUME_NONNULL_BEGIN

@interface Contact (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSManagedObject *section;

@end

NS_ASSUME_NONNULL_END
