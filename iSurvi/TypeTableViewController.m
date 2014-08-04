//
//  TypeTableViewController.m
//  iSurvi
//
//  Created by Songwut on 12/22/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import "TypeTableViewController.h"
#import "SBJson.h"
@interface TypeTableViewController ()

@end

@implementation TypeTableViewController
@synthesize itemsDatabase = _itemsDatabase;


-(void)setupFetchedResultsController
{
    // self.fetchedResultsController = ....
    
}
-(void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.itemsDatabase.fileURL path]]) {
        //ตรวจสอบว่า itemsDatabase ได้ออกไปจาก Disk แล้ว ถ้าไม่แล้วไป หลังจากนั้นสร้าง
        [self.itemsDatabase saveToURL:self.itemsDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.itemsDatabase.documentState == UIDocumentStateClosed) {
        //เมื่อเปิดใช้ document ถูกปิดอยู่
        [self.itemsDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.itemsDatabase.documentState == UIDocumentStateNormal) {
        //เมื่อเปิดใช้ document อยู่
        [self setupFetchedResultsController];
    }
}
-(void)setItemsDatabase:(UIManagedDocument *)itemsDatabase
{
    //เงื่อไขทำให้ set ข้อมูลล่าสุดของ itemsDatabase ให้ตัวมันเอง
    if (_itemsDatabase!= itemsDatabase) {
        _itemsDatabase = itemsDatabase;
        [self useDocument];
    }
}
/*
 -(void)viewWillAppear:(BOOL)animated
 {
 [self viewWillAppear:animated];
 
 //ถ้า view แสดง ให้ itemsDatabase เป็น nil แล้วโหลดใหม่
 if (!self.itemsDatabase) {
 NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
 url = [url URLByAppendingPathComponent:@"Default Items DataBase"];
 self.itemsDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
 }
 
 }
 */
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //============================================================
    //แสดง theme ที่ออกแบบไว้
    customNavBar
    customTabBar
    //============================================================
    // ดึงไฟล์ th.json
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"th" ofType:@"json"];
    
    
    //============================================================
    //ใช้ SBJson เก็บเนื้อหามาใส่ itemList ซึ่งตั้งไว้เป็น MutableArray
    NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath      encoding:NSUTF8StringEncoding error:nil];
    SBJsonParser *parser = [[SBJsonParser alloc] init];
    itemList = [parser objectWithString:fileContent error:nil];
    //แสดงจำนวน row ออกมาใน output
    NSLog(@"itemList Count: %u", itemList.count);
    
    //============================================================
    // insert json ลง core data
    
    
    
    // พื้นหลัง tableView
    //addBgTable = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgContent.png"]];
    
    //============================================================
    // custom Type Bar
    
    // พื้นหลังทั้งหมด
    UIColor *addBgImg = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgContent.png"]];
    self.view.backgroundColor = addBgImg;
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
    return [itemList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"typeCell";
    
    CustomTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgCell.png"] ];
    typeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icontype1.png"] ];
    
    
    
    
    UIImage *imageUp = [UIImage imageNamed:@"arrowup.png"];
    UIImage *imageDown = [UIImage imageNamed:@"arrowdown.png"];
    UIButton *buttonAcc = [UIButton buttonWithType:UIButtonTypeCustom];
    CGRect frame = CGRectMake(cell.frame.size.width  - imageUp.size.width, cell.frame.size.height - imageUp.size.height, imageUp.size.width, imageUp.size.height);
    buttonAcc.frame = frame;
    [buttonAcc setBackgroundImage:imageUp forState:UIControlStateNormal];
    [buttonAcc setBackgroundImage:imageUp forState:UIControlStateHighlighted];
    [buttonAcc setBackgroundImage:imageDown forState:UIControlStateApplication];
    //[buttonAcc addTarget:self action:@selector(accessoryButtonTapped:event:)  forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = buttonAcc;
    cell.backgroundView = bgimage;
    
    NSDictionary *exercise = [itemList objectAtIndex:indexPath.row];
    //cell.textLabel.text = [exercise valueForKey:@"itemName"];
    cell.labelCell.text = [exercise valueForKey:@"itemName"];
    cell.detailCel.text = [exercise valueForKey:@"notice"];
    
    /*
    // Set up the cell…
    switch (indexPath.row) {
        case 0:
            cell.primaryLabel.text = @"Meeting on iPhone Development";
            cell.secondaryLabel.text = @"Sat 10:30";
            cell.myImageView.image = [UIImage imageNamed:@"meeting_color.png"];
            break;
        case 1:
            cell.primaryLabel.text = @"Call With Client";
            cell.secondaryLabel.text = @"Planned";
            cell.myImageView.image = [UIImage imageNamed:@"call_color.png"];
            break;
        case 2:
            cell.primaryLabel.text = @"Appointment with Joey";
            cell.secondaryLabel.text = @"2 Hours";
            cell.myImageView.image = [UIImage imageNamed:@"calendar_color.png"];
            break;
        case 3:
            cell.primaryLabel.text = @"Call With Client";
            cell.secondaryLabel.text = @"Planned";
            cell.myImageView.image = [UIImage imageNamed:@"call_color.png"];
            break;
        case 4:
            cell.primaryLabel.text = @"Appointment with Joey";
            cell.secondaryLabel.text = @"2 Hours";
            cell.myImageView.image = [UIImage imageNamed:@"calendar_color.png"];
            break;
        default:
            break;
    }
    */
    return cell;

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}


@end
