//
//  typeTableViewController.m
//  iSurvi
//
//  Created by Songwut on 12/22/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import "typeTableViewController.h"
#import "SBJson.h"
#import "Items.h"

@interface typeTableViewController ()

@end

@implementation typeTableViewController
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
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"typeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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

@end
