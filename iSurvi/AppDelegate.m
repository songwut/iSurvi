//
//  AppDelegate.m
//  iSurvi
//
//  Created by Songwut on 12/16/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import "AppDelegate.h"
#import "SBJson.h"
#import "Items.h"

NSNumber *numFav;

@implementation AppDelegate
{
    NSManagedObjectContext *context;
    NSUInteger const kMyNameIdx;
    NSUInteger const kMyMajorIdx;
    NSString * const kMyNameKey;
    NSString * const kMyMajorKey;
}

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
-(void)readJason
{
    //============================================================
    language = [[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0];
    regionFormat = [[NSLocale currentLocale] localeIdentifier];
    NSLog(@"Language is : %@",language);
    NSLog(@"Region Format is : %@",regionFormat);
    
     if ([language isEqualToString:@"th"] || [regionFormat isEqualToString:@"th_TH"])
     {
         lang = @"th";
         hostLive = @"iSurviLive_th";
         NSLog(@"lang is : %@",lang);
     }else {
         lang = @"en";
         hostLive = @"iSurviLive";
         NSLog(@"lang is : %@",lang);
     }

    // ดึงไฟล์ th.json
    filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_",lang] ofType:@"json"];
    //============================================================
    //ใช้ SBJson เก็บเนื้อหามาใส่ itemList ซึ่งตั้งไว้เป็น MutableArray
    NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath      encoding:NSUTF8StringEncoding error:nil];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    itemList = [parser objectWithString:fileContent error:nil];
    
    //แสดงจำนวน row ออกมาใน output
    NSLog(@"Read Json itemList Count: %u", itemList.count);
}
-(void)requestItems
{
    NSLog(@"Begine request CoreData : !");
    [self readJason];
    context = [self managedObjectContext];
    // ตัวนี้สำคัญ ถ้าไม่ใช่ MOC ที่ AppDelegate entity จะเป็น nil
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSError *error = nil;
    NSUInteger dbCount = [context countForFetchRequest:request error:&error];
    //ค้าหา Database ว่ามีหรือไม่
    NSLog(@"Database Count : %u",dbCount);
    
    if (dbCount == 0) {
        NSLog(@"No Data request!");
        //ไม่เจอข้อมูล และสร้างข้อมูลต่อไป
        [self insertItems];
        [self saveLanguage];
        [self saveUpdateCount];
        
    }else if (dbCount < itemList.count) {
        //ฐานข้อมูลมี items น้อยกว่าในไฟล์ Json
        NSLog(@"Data UPDATE!");
        //Update DB
        [self clearItems];
        if (isClear == YES) {
            [self insertItems];
        }else {
            NSLog(@"isClear : NO");
        }
        
    }else {
        NSLog(@"Data Ready!");
        //ข้อมูลพร้อม
    }
    
}
-(void)saveUpdateCount
{
    NSLog(@"Begine save UpdateCount : !");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSString stringWithFormat:@"%i",0] forKey:@"UpdateCountValue"];
    
    [defaults setObject:[NSString stringWithFormat:@"%i",30] forKey:@"UpdateResultValue"];
    
    [defaults synchronize];
    
    
}
-(void)saveLanguage
{
    NSLog(@"Begine save Language : !");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:lang forKey:@"LanguageValue"];
    
    [defaults setObject:hostLive forKey:@"HostLiveValue"];
    [defaults synchronize];
}
-(void)clearItems
{
    NSLog(@"Begine Clear CoreData : !");
    isClear = NO;
    context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    NSError *error;
    favList = [context executeFetchRequest:request error:&error];
    
    if (favList.count <= 0) {
        NSLog(@"No itemID");
        
    }else {
        int countFav = 0;
        for (NSManagedObject *obj in favList) {
            [context deleteObject:obj];
            ++countFav; //เผื่อลบหลายตัวในคราวเดียว
        }
        [context save:&error];
        isClear = YES;
    }
    /*
    //=======
    NSError * error = nil;
    NSArray * cars = [context executeFetchRequest:request error:&error];

    //error handling goes here
    for (NSManagedObject * car in cars) {
        [context deleteObject:car];
        NSLog(@"Clear CoreData outCoreData : %@",car);
    }
    NSError *saveError = nil;
    [context save:&saveError];
    //more error handling here
     */
    
}
-(void)insertItems
{
    //[self readJason];
    NSLog(@"Begine insert CoreData : !");
    NSNumberFormatter * toNumber = [[NSNumberFormatter alloc] init];
    [toNumber setNumberStyle:NSNumberFormatterDecimalStyle];
    
    context = [self managedObjectContext];
    // ค่า setting ภาษาเมื่อ เปิด apps ครั้งแรก
    
    
    for (NSDictionary *dataDict in itemList) {
        
        Items *items = [NSEntityDescription insertNewObjectForEntityForName:@"Items" inManagedObjectContext:context];

        NSNumber *itemID = [toNumber numberFromString:[dataDict objectForKey:@"itemID"]];
        NSString *itemName = [dataDict objectForKey:@"itemName"];
        NSString *icon = [dataDict objectForKey:@"icon"];
        NSString *use = [dataDict objectForKey:@"use"];
        NSString *shop = [dataDict objectForKey:@"shop"];
        NSString *notice = [dataDict objectForKey:@"notice"];
        NSNumber *backpack = [dataDict objectForKey:@"backpack"];
        NSNumber *minipack = [dataDict objectForKey:@"minipack"];
        NSNumber *carpack = [dataDict objectForKey:@"carpack"];
        NSNumber *type = [dataDict objectForKey:@"type"];
        
        items.itemID = itemID;
        items.itemName = itemName;
        NSLog(@"itemName inCoreData : %@",items.itemName);
        items.icon = icon;
        items.use = use;
        NSLog(@"use inCoreData : %@",items.use);
        items.shop = shop;
        items.notice = notice;
        items.backpack = backpack;
        items.minipack = minipack;
        items.carpack = carpack;
        items.type = type;
        NSLog(@"==========================");
        NSError *error;
        if (![context save:&error]) {
            NSLog(@"insert ERROR : Fool!");
        }
    }
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self requestItems];
    //[self insertItems];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}
#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.


- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"itemsModel" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ItemsCoreData.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
