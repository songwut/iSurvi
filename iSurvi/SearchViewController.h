//
//  SearchViewController.h
//  iSurvi
//
//  Created by Songwut on 1/2/13.
//  Copyright (c) 2013 Songwut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CustomItemsCell.h"

@class ShowItemViewController;

@interface SearchViewController : UIViewController < UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    
    
    NSDictionary *itemDict;
    NSMutableArray *itemArray;
    NSDictionary *dataDic;
    NSArray *itensListDB;
    //NSMutableArray *itensFilter;
    NSArray *filtered;
    BOOL isFilter;
    UIImageView *bgimage;
    UIImageView *itemImg;
    UIImageView *itemImgBG;
    
    NSDictionary *exercise;
    
    UIImage *originalImage;
    UILabel *itemLabel;
    UILabel *itemDetail;
    
    UITableViewCell *cell;
    UIColor *addBgTable;
    UIView *bgSelected;
    UIImage *imageAcc;
    UIImage *imageStar;
    UIButton *buttonAcc;
    UIButton *starbtn;
    
    NSFetchRequest *request;
    NSPredicate *predicate;
    
}
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (strong, nonatomic) ShowItemViewController *showItemViewController;
@property (nonatomic , strong) UIManagedDocument *itemsDatabase;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

