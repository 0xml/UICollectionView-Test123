//
//  ViewController.m
//  UICollectionView
//
//  Created by Pawel Ropa on 18/04/16.
//  Copyright © 2016 Pawel Ropa. All rights reserved.
//

#import "ViewController.h"

#import "Contact.h"
#import "SectionPerson.h"

#import "CollectionViewCell.h"

NSString *const kDidSeedDatabase = @"kDidSeedDatabase";

@interface ViewController () <UICollectionViewDelegate,
                              UICollectionViewDataSource,
                              NSFetchedResultsControllerDelegate>
@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view, typically from a nib.

  if ([[NSUserDefaults standardUserDefaults] boolForKey:kDidSeedDatabase] ==
      NO) {

    NSManagedObjectContext *context =
        [self.fetchedResultsController managedObjectContext];

    [context performBlock:^{
      // Seeding db
      for (NSUInteger i = 0; i < 20; i++) {
        @autoreleasepool {
          for (NSUInteger j = 0; j < 100; j++) {
            NSUInteger u = i * 100 + j;
            [self insertNewObjectNumber:u];
          }

          NSError *error = nil;
          if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
          }

          NSLog(@"another 100 %lu", i);

          [context refreshAllObjects];
        }
      }

      NSError *error = nil;
      if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
      }
    }];

    dispatch_async(dispatch_get_main_queue(), ^{
      [self.fetchedResultsController performFetch:nil];
      [self.collectionView reloadData];
    });

    NSLog(@"Finished seeding database");

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kDidSeedDatabase];
  }
}

- (void)insertNewObjectNumber:(NSUInteger)number {
  NSManagedObjectContext *context =
      [self.fetchedResultsController managedObjectContext];
  Contact *contact =
      [NSEntityDescription insertNewObjectForEntityForName:@"Contact"
                                    inManagedObjectContext:context];
  SectionPerson *sectionPerson =
      [NSEntityDescription insertNewObjectForEntityForName:@"SectionPerson"
                                    inManagedObjectContext:context];
  contact.section = sectionPerson;
  contact.name = [NSString stringWithFormat:@"Contact %lu", number];
  sectionPerson.givenName =
      [NSString stringWithFormat:@"Section Person %lu", number];
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
  if (_fetchedResultsController != nil) {
    return _fetchedResultsController;
  }

  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  // Edit the entity name as appropriate.
  NSEntityDescription *entity =
      [NSEntityDescription entityForName:@"Contact"
                  inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];

  // Set the batch size to a suitable number.
  [fetchRequest setFetchBatchSize:20];
  [fetchRequest setIncludesPropertyValues:NO];

  // Edit the sort key as appropriate.
  NSSortDescriptor *sortDescriptor =
      [[NSSortDescriptor alloc] initWithKey:@"section.givenName" ascending:NO];

  [fetchRequest setSortDescriptors:@[ sortDescriptor ]];

  // Edit the section name key path and cache name if appropriate.
  // nil for section name key path means "no sections".
  NSFetchedResultsController *aFetchedResultsController =
      [[NSFetchedResultsController alloc]
          initWithFetchRequest:fetchRequest
          managedObjectContext:self.managedObjectContext
            sectionNameKeyPath:nil
                     cacheName:@"Master"];
  aFetchedResultsController.delegate = self;
  self.fetchedResultsController = aFetchedResultsController;

  NSError *error = nil;
  if (![self.fetchedResultsController performFetch:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }

  return _fetchedResultsController;
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  id<NSFetchedResultsSectionInfo> sectionInfo =
      [self.fetchedResultsController sections][section];
  return [sectionInfo numberOfObjects];
}

// The cell that is returned must be retrieved from a call to
// -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  CollectionViewCell *cell = (CollectionViewCell *)[collectionView
      dequeueReusableCellWithReuseIdentifier:@"Cell"
                                forIndexPath:indexPath];

  Contact *contact =
      [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.label.text = contact.name;

  return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {
  return [[self.fetchedResultsController sections] count];
}

#pragma mark - NSFetchedResultsController

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(nullable NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(nullable NSIndexPath *)newIndexPath {
  NSLog(@"didChangedObject");
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
  NSLog(@"didChangedSection");
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  NSLog(@"willChangeContent");
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  NSLog(@"didChangeContent");
}

@end
