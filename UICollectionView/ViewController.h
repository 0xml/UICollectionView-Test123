//
//  ViewController.h
//  UICollectionView
//
//  Created by Pawel Ropa on 18/04/16.
//  Copyright © 2016 Pawel Ropa. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface ViewController : UICollectionViewController

@property(strong, nonatomic)
    NSFetchedResultsController *fetchedResultsController;
@property(strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
