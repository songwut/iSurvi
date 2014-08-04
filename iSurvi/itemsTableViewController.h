//
//  itemsTableViewController.h
//  iSurvi
//
//  Created by Songwut on 12/21/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CustomItemsCell.h"

@class ShowItemViewController;

@interface itemsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
{
    NSDictionary *exercise;
    NSDictionary *itemDict;
    NSMutableArray *itemArray;
    NSDictionary *dataDic;
    NSArray *itensListDB;
    UIImageView *bgimage;
    UIImage *originalImage;
    UIImage *blankImage;
    UIView *bgSelected;
    UIImage *imageStar;
    UIButton *buttonAcc;
    UIButton *starbtn;
    
    UIView *lightView;
    float screenW;
}
@property (strong, nonatomic) NSString *recipeTitle;
@property (strong, nonatomic) NSString *GroupMode;
@property (nonatomic) int GroupSub;
@property (weak, nonatomic) IBOutlet UITableView *itemsTableView;
@property (strong, nonatomic) ShowItemViewController *showItemViewController;

@property (nonatomic , strong) UIManagedDocument *itemsDatabase;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
