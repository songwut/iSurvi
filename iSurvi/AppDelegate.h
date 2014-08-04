//
//  AppDelegate.h
//  iSurvi
//
//  Created by Songwut on 12/16/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "SettingObj.h"
#import "ShowItemViewController.h"
extern  NSNumber *numFav;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    
    NSString *filePath;
    NSArray *itemList;
    NSDictionary *itemDict;
    NSData *itemsData;

    NSString *hostLive;
    NSString *lang;
    NSString *language;
    NSString *regionFormat;
    BOOL isClear;
    NSArray *favList;
}

//#define customTabbar UIImage *tabBarBG = [UIImage imageNamed:@"bgTabbar.png"];[self.tabBarController.tabBar setBackgroundImage:tabBarBG];[self.tabBarController.tabBar setTintColor:tabBarBG];

// custom NavigationBar
#define customNavBar [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bgTitlebar.png"] forBarMetrics:UIBarMetricsDefault];[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];

// custom tabBar
#define customTabBar [self.tabBarController.tabBar setBackgroundImage:[UIImage imageNamed:@"bgTabbar.png"]];[self.tabBarController.tabBar setSelectionIndicatorImage:[UIImage imageNamed:@"blank.png"]];

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SettingObj *settingObj;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
@end
