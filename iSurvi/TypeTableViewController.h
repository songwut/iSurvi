//
//  TypeTableViewController.h
//  iSurvi
//
//  Created by Songwut on 12/22/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CustomTypeCell.h"
@interface TypeTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    NSMutableArray *itemArray;
    NSArray *itemList;
    UIImageView *bgimage;
    UIImageView *typeImg;
}
@property (nonatomic , strong) UIManagedDocument *itemsDatabase;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
