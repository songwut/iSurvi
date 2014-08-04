//
//  EssentalViewController.h
//  iSurvi
//
//  Created by Songwut on 12/16/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAd/iAd.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "CustomItemsCell.h"
#import "Items.h"

@class SearchViewController;

@interface EssentalViewController : UIViewController <ADBannerViewDelegate, UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UINavigationBarDelegate>
{
    NSMutableArray *tweetsAll;
    NSString *hostLive;
    CGRect adRect;
    ADBannerView *adView;
    
    NSDictionary *itemDict;
    NSArray *itemList;
    NSArray *itemArray;
    NSArray *typeList;
    
    UIColor *addBgTable;
    UIView *bgSelected;
    
    UIImageView *bgimage;
    UIImageView *typeImg;
    UILabel *typeLabel;
    UILabel *typeDetail;
    
    UITableViewCell *cell;
    UIImage *imageAcc;
    UIImage *imageStar;
    UIButton *buttonAcc;
    
    NSString *typeGroup;
    int typeRow;
    
    NSArray *langList;
    NSString *langPrefix;
    
    NSString *typeTitle;
    NSString *packTitle;
    NSString *eventTitle;
    
    
}

@property (weak, nonatomic) IBOutlet UIView *mainBgView;
@property (nonatomic, assign) BOOL adVisible;
@property (strong, nonatomic) SearchViewController *searchViewController;
@property (weak, nonatomic) IBOutlet UITableView *typeTableView;

@property (strong, nonatomic) IBOutlet UIButton *typeBTN;
@property (strong, nonatomic) IBOutlet UIButton *packBTN;
//รอ update ชนิดของภัยภิบัติ
//@property (strong, nonatomic) IBOutlet UIButton *allBTN;
@property (strong, nonatomic) IBOutlet UIImageView *bgTypebar;

@property (nonatomic , strong) UIManagedDocument *itemsDatabase;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) SettingObj *settingObj;
@end


