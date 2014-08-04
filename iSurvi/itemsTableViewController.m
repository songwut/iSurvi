//
//  itemsTableViewController.m
//  iSurvi
//
//  Created by Songwut on 12/21/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "itemsTableViewController.h"
#import "SBJson.h"
#import "ShowItemViewController.h"
#import "Fav.h"
#import "AppDelegate.h"

@interface itemsTableViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation itemsTableViewController

@synthesize itemsDatabase = _itemsDatabase;
@synthesize GroupMode = _GroupMode;
@synthesize GroupSub = _GroupSub;


- (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    return appDelegate.managedObjectContext;
}
- (void)lightTop
{
    screenW = self.view.frame.size.width;
    lightView.frame = CGRectMake(0, 0, screenW, 30);
    NSLog(@"itemsTableView frame w : %f", screenW);
}
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //[self lightTop];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    //[self lightTop];
    NSLog(@"viewWillAppear : itemsTableViewController");
    if ([_GroupMode isEqual: @"type"]) {
        [self searchType];
    }
    if ([_GroupMode isEqual: @"pack"]) {
        
        switch (_GroupSub) {
            case 1:
                [self searchMinipack];
                break;
            case 2:
                [self searchBackpack];
                break;
            case 3:
                [self searchCarpack];
                break;
            default:
                break;
        }
        
    }
    
}
-(void)searchMinipack
{
    context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"minipack = %i",1];
    [request setPredicate:predicate];
    
    NSError *error;
    itensListDB = [context executeFetchRequest:request error:&error];
    
    if (itensListDB.count <= 0) {
        NSLog(@"No Mini Pack Data request!");
        //ไม่เจอข้อมูล และสร้างข้อมูลต่อไป
    }else {
        NSLog(@"Mini Pack Data Ready! : %i",itensListDB.count);
        //ข้อมูลพร้อม
    }
}
-(void)searchBackpack
{
    context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"backpack = %i",1];
    [request setPredicate:predicate];
    
    NSError *error;
    itensListDB = [context executeFetchRequest:request error:&error];
    
    if (itensListDB.count <= 0) {
        NSLog(@"No Back Pack Data request!");
        //ไม่เจอข้อมูล และสร้างข้อมูลต่อไป
    }else {
        NSLog(@"Back Pack Data Ready! : %i",itensListDB.count);
        //ข้อมูลพร้อม
    }
}
-(void)searchCarpack
{
    context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"carpack = %i",1];
    [request setPredicate:predicate];
    
    NSError *error;
    itensListDB = [context executeFetchRequest:request error:&error];
    
    if (itensListDB.count <= 0) {
        NSLog(@"No Car Pack Data request!");
        //ไม่เจอข้อมูล และสร้างข้อมูลต่อไป
    }else {
        NSLog(@"Car Pack Data Ready! : %i",itensListDB.count);
        //ข้อมูลพร้อม
    }
}

-(void)searchType
{
    context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Items" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    //Query ข้อมูลจากเงื่อนไข type = ตัวแปร
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %i",_GroupSub];
    [request setPredicate:predicate];
    //เรียง itemName ตามตัวอักษร
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"itemName" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSError *error;
    itensListDB = [context executeFetchRequest:request error:&error];
    
    if (itensListDB.count <= 0) {
        NSLog(@"No Type Data request!");
        //ไม่เจอข้อมูล และสร้างข้อมูลต่อไป
    }else {
        NSLog(@"Type Data Ready! : %i",itensListDB.count);
        //ข้อมูลพร้อม
    }
}

-(void)fetchItemsDataIntoDocument:(UIManagedDocument *)document
{
    dispatch_queue_t fetchQ = dispatch_queue_create("Items fetcher", NULL);
    dispatch_async(fetchQ, ^{
        [document.managedObjectContext performBlock:^{
            for (NSDictionary *dataDict in itensListDB) {
                //[Items itemsWithItemsInfo:dataDict inManagedObjectContext:document.managedObjectContext];
            }
        }];
    });
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)addFav:(id)sender {
    NSLog(@"addFac Click");
    /*
     UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
     NSIndexPath *clickedButtonPath = [self.itemsTableView indexPathForCell:clickedCell];
     NSLog(@"clickedCell: %@", clickedCell);
     NSLog(@"clickedButtonPath: %@", clickedButtonPath);
     */
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"didSelectRow");
    //[self setAndShowItemsContent];
    
}
- (void)setAndShowItemsContent
{
    //self.typeMode = _typeMode;
    //segue
    [self performSegueWithIdentifier:@"ShowItemsContent" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"ShowItemsContent"]) {
        
        NSIndexPath *indexPath = [self.itemsTableView indexPathForSelectedRow];
        ShowItemViewController *showItemViewController = segue.destinationViewController;
        showItemViewController.itemsObj = [itensListDB objectAtIndex:indexPath.row];
        //ส่ง typeName ที่ได้เลือกใน row ของ typeTableView ไปเป็นตัวแปร RecipeTitle
        //NSIndexPath *indexPath = [self.itemsTableView indexPathForSelectedRow];
        //ใช้ exerciseType ช่วยแยก arrayย่อย ใน typeList
        //NSDictionary *exerciseItems = [itensListDB objectAtIndex:indexPath.row];
        //[segue.destinationViewController setTitleContent:[exerciseItems valueForKey:@"typeName"]];
        //NSLog(@"indexPath Selected : %@", [exerciseItems valueForKey:@"typeName"]);
        
    }
}

-(void)refreshNewCell
{
    
    /*
     Also, the "withRowAnimation" is not exactly a boolean, but an animation style:
     UITableViewRowAnimationFade,
     UITableViewRowAnimationRight,
     UITableViewRowAnimationLeft,
     UITableViewRowAnimationTop,
     UITableViewRowAnimationBottom,
     UITableViewRowAnimationNone,
     UITableViewRowAnimationMiddle
     */
    //โหลดข้อมูลใหม่ด้วย Animation
    [self.itemsTableView beginUpdates];
    [self.itemsTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    [self.itemsTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    [self.itemsTableView endUpdates];
    //โหลดข้อมูลใหม่ธรรมดา
    //[self.typeTableView reloadData];
}
-(void)footerTableView
{
    //ใส่ footer ให้ TableView เพื่อไม่ให้ Tabbar บัง cell สุดท้าย
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 70)];
    footer.backgroundColor = [UIColor clearColor];
    self.itemsTableView.tableFooterView = footer;
}
- (UIBarButtonItem *) getBackBtn
{
    UIButton * backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageBack = [UIImage imageNamed:@"arrowBack.png"];
    [backBtn setImage:imageBack forState:UIControlStateNormal];
    [backBtn setFrame:CGRectMake(0.0f,0.0f,imageBack.size.width, imageBack.size.height)];
    [backBtn addTarget:self action:@selector(backBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    return backBarButton;
}
- (void)backBtnPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        //ถ้าเลือกปุ่ม Cancel ให้กลับไปหน้า Essental List อัตโนมัติ
        [self backBtnPressed];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //set Effect lightView
    /*
    lightView = [[UIView alloc] init];
    [lightView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lightTer.png"]]];
    [self.view addSubview:lightView];
     */
    //============================================================
    
    [self refreshNewCell];
    
    //============================================================
    //กำหนดชื่อใส่ใน navigation TitleBar
    self.navigationItem.title = _recipeTitle;
    if (_recipeTitle == nil) {
        NSLog(@"recipeTitle : nil");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Content Not Available!"
                                                        message:@"You can get new content VERY SOON."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];

    }
    //============================================================
    //กำหนดปุ่ม ด้านขวา
    /*
     UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
     self.navigationItem.rightBarButtonItem = addButton;
     self.showItemViewController = (ShowItemViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
     */
    //============================================================
    //กำหนดปุ่ม ด้านซ้ายเป็นปุ่มแบบ custom
    self.navigationItem.leftBarButtonItem = [self getBackBtn];
    //============================================================
    //แสดง theme ที่ออกแบบไว้
    customNavBar
    customTabBar
    [self footerTableView];
    [self refreshNewCell];
    // insert json ลง core data
    
    
    
    // พื้นหลัง tableView
    //addBgTable = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgContent.png"]];
    
    //============================================================
    // custom Type Bar
    
    // พื้นหลังทั้งหมด
    UIView *patternView = [[UIView alloc] initWithFrame:self.tableView.frame];
    patternView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDK.png"]];
    patternView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundView = patternView;
    bgSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgSelected.png"] ];
    //============================================================
    // custom Tab Bar
    
    UIImage *selectedImage0 = [UIImage imageNamed:@"Main_icon_Select_list.png"];
    UIImage *unselectedImage0 = [UIImage imageNamed:@"Main_icon_Unselect_list.png"];
    UIImage *selectedImage1 = [UIImage imageNamed:@"Main_icon_Select_fav.png"];
    UIImage *unselectedImage1 = [UIImage imageNamed:@"Main_icon_Unselect_fav.png"];
    UIImage *selectedImage2 = [UIImage imageNamed:@"Main_icon_Select_news.png"];
    UIImage *unselectedImage2 = [UIImage imageNamed:@"Main_icon_Unselect_news.png"];
    UIImage *selectedImage3 = [UIImage imageNamed:@"Main_icon_Select_setting.png"];
    UIImage *unselectedImage3 = [UIImage imageNamed:@"Main_icon_Unselect_setting.png"];
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item0 = (tabBar.items)[0];
    UITabBarItem *item1 = (tabBar.items)[1];
    UITabBarItem *item2 = (tabBar.items)[2];
    UITabBarItem *item3 = (tabBar.items)[3];
    // แจ้งเตือนใน tabBarItem
    //item1.badgeValue = @"1";
    
    [item0 setFinishedSelectedImage:selectedImage0 withFinishedUnselectedImage:unselectedImage0];
    [item1 setFinishedSelectedImage:selectedImage1 withFinishedUnselectedImage:unselectedImage1];
    [item2 setFinishedSelectedImage:selectedImage2 withFinishedUnselectedImage:unselectedImage2];
    [item3 setFinishedSelectedImage:selectedImage3 withFinishedUnselectedImage:unselectedImage3];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [itensListDB count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"itemsCell";
    
    //CustomItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CustomItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgCell.png"] ];
    
    imageStar = [UIImage imageNamed:@"blank.png"];
    
    [cell.favBTN setBackgroundImage:imageStar forState:UIControlStateNormal];
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowGray.png"]];
    cell.backgroundView = bgimage;
    
    [cell setSelectedBackgroundView:bgSelected];
    
    
    exercise = [itensListDB objectAtIndex:indexPath.row];
    //imgCell เป็น UIImagesView จึงต้องใช้ setImage
    //[cell.imgCell setImage:[UIImage imageNamed:@"iconBlank.png"]];
    //itemImgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconBlank.png"]];
    originalImage = [UIImage imageNamed:[exercise valueForKey:@"icon"]];
    blankImage = [UIImage imageNamed:@"iconBlank.png"];
    [cell.iconBlank setImage:blankImage];
    [cell.imgCell setImage:[self resizeImageAndCor:originalImage]];
    cell.labelCell.text = [exercise valueForKey:@"itemName"];
    cell.detailCell.text = [exercise valueForKey:@"use"];
    
    //[cell.contentView addSubview:itemImgBG];
    
    return cell;
    //[self refreshNewCell];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        //NSIndexPath *indexPath = [self.searchTableView indexPathForSelectedRow];
        exercise = [itensListDB objectAtIndex:indexPath.row];
        [self insertFav];
        UITabBar *tabBar = self.tabBarController.tabBar;
        UITabBarItem *item1 = (tabBar.items)[1];
        item1.badgeValue = @"New!";
    }
}
-(void)insertFav
{
    NSLog(@"Begine insert Fav : !");
    Fav *fav = [NSEntityDescription insertNewObjectForEntityForName:@"Fav" inManagedObjectContext:context];
    fav.itemID = [exercise valueForKey:@"itemID"];
    fav.itemName = [exercise valueForKey:@"itemName"];
    fav.icon = [exercise valueForKey:@"icon"];
    fav.use = [exercise valueForKey:@"use"];
    fav.shop = [exercise valueForKey:@"shop"];
    fav.notice = [exercise valueForKey:@"notice"];
    fav.backpack = [exercise valueForKey:@"backpack"];
    fav.minipack = [exercise valueForKey:@"minipack"];
    fav.carpack = [exercise valueForKey:@"carpack"];
    fav.type = [exercise valueForKey:@"type"];
    fav.favStatus = [NSNumber numberWithInteger:1];
    
    NSError *error;
    if (![context save:&error]) { NSLog(@"insert Fav ERROR : Fool!"); }
}
-(UIImage*)resizeImageAndCor:(UIImage*)image
{
    //ขนาดปรกติ
    CGRect oldimageRect = CGRectMake(0, 0, 60, 60);
    //ขนาดย่อลง
    CGRect newimageRect = CGRectMake(7, 7, 47, 47);
    //เริ่มวาดจากขนาดเดิมคือ oldimageRect
    UIGraphicsBeginImageContextWithOptions(oldimageRect.size,NO,0.0);
    //กำหนด path วาดขนาดหดเล็กลงใน newimageRect
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newimageRect cornerRadius:5.f];
    [path addClip];
    //นำรูปที่วาดใน path ใส่ไปที่ image ในขนาดเดิมคือ oldimageRect
    [image drawInRect:oldimageRect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
-(UIImage*)resizeImage:(UIImage*)image {
    
    CGSize newSize = CGSizeMake(60, 60);
    UIGraphicsBeginImageContext(newSize);
    // Draw image1
    UIGraphicsBeginImageContext(CGSizeMake(newSize.width, newSize.height));
    [image drawInRect:CGRectMake(0.0, 0.0, newSize.width, newSize.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
