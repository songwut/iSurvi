//
//  FavoriteViewController.m
//  iSurvi
//
//  Created by Songwut on 1/15/13.
//  Copyright (c) 2013 Songwut. All rights reserved.
//

#import "FavoriteViewController.h"
#import "ShowItemViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "Fav.h"

@interface FavoriteViewController ()
{
    NSManagedObjectContext *context;
}
@end

@implementation FavoriteViewController
@synthesize itemsDatabase = _itemsDatabase;

-(void)shadowOfNavBar
{
    //============================================================
    // แสงเงาของ navigationController
    //self.navigationController.navigationBar.clipsToBounds = NO;
    float shadowOffset = 1.5f;shadowOffset = MIN(MAX(shadowOffset, 1), 3);
    
    //Ensure that the shadow radius is between 1 and 3
    float shadowRadius = MIN(MAX(shadowOffset, 1), 3);
    
    //apply the offset and radius
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0, shadowOffset);
    self.navigationController.navigationBar.layer.shadowRadius = shadowRadius;
    self.navigationController.navigationBar.layer.shadowColor = [UIColor colorWithRed:0.146 green:0.861 blue:0.966 alpha:1.000].CGColor;
    self.navigationController.navigationBar.layer.shadowOpacity = 1.0;
    
    //============================================================
}
- (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    return appDelegate.managedObjectContext;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"viewWillAppear : searchTableViewController");
    [self searchItems];
    [self.searchTableView reloadData];
    //[self refreshNewCell];
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item1 = (tabBar.items)[1];
    item1.badgeValue = nil;
    
}

-(void)searchItems
{
    
    context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Fav" inManagedObjectContext:context];
    request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    
    //Query ข้อมูลจากเงื่อนไข type = ตัวแปร
    //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %i",1];
    [request setPredicate:predicate];
    
    //เรียง itemName ตามตัวอักษร
    NSSortDescriptor *sortDesc = [NSSortDescriptor sortDescriptorWithKey:@"itemName" ascending:YES];
    [request setSortDescriptors:[NSArray arrayWithObject:sortDesc]];
    
    NSError *error;
    itensListDB = [context executeFetchRequest:request error:&error];
    
    if (itensListDB.count <= 0) {
        NSLog(@"No Search Data request!");
        //ไม่เจอข้อมูล และสร้างข้อมูลต่อไป
    }else {
        NSLog(@"Search Data Ready! : %i",itensListDB.count);
        //ข้อมูลพร้อม
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
    [self.searchTableView beginUpdates];
    [self.searchTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.searchTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.searchTableView endUpdates];
    //โหลดข้อมูลใหม่ธรรมดา
    //[self.typeTableView reloadData];
}
-(void)footerTableView
{
    //ใส่ footer ให้ TableView เพื่อไม่ให้ Tabbar บัง cell สุดท้าย
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 70)];
    footer.backgroundColor = [UIColor clearColor];
    self.searchTableView.tableFooterView = footer;
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
    [self.searchBar resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self searchItems];
    
    [[self searchTableView]setDelegate:self];
    [[self searchTableView]setDataSource:self];
    self.searchBar.delegate = self;
    
    customNavBar
    customTabBar
    [self shadowOfNavBar];
    //itemArray = [[NSMutableArray alloc] initWithArray:itensListDB];
    itemArray = [[NSMutableArray alloc] initWithObjects:@"one",@"two",@"tree",@"fore", nil];
    //============================================================
    //custom Search Bar (need Outlet)
    [self.searchBar setBackgroundImage:[UIImage imageNamed:@"bgSearchbar.png"]];
    
    //============================================================
    [self configBTN];
    [self footerTableView];
    //[self refreshNewCell];
    
    //============================================================
    //กำหนดปุ่ม Back ด้านซ้ายเป็นปุ่มแบบ custom
    //self.navigationItem.leftBarButtonItem = [self getBackBtn];
    //============================================================
    // พื้นหลัง tableView
    //addBgTable = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgContent.png"]];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDK.png"]];
    addBgTable = [UIColor clearColor];
    bgSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgSelected.png"] ];
    self.searchTableView.backgroundColor = addBgTable;
    //============================================================
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)keyboardShow:(NSNotification *)note
{
    CGRect keyboardFrame;
    [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
    CGRect tableViewFrame = self.searchTableView.frame;
    tableViewFrame.size.height = keyboardFrame.size.height;
    NSLog(@"tableViewFrame keyboardShow : %f",tableViewFrame.size.height);
    [self.searchTableView setFrame:tableViewFrame];
}
- (void)keyboardHide:(NSNotification *)note
{
    CGRect tableViewFrame = self.view.bounds;
    //ปรับ tableViewFrame จากตำแหน่งของ searchBar
    tableViewFrame.size.height = self.view.bounds.size.height - self.searchBar.bounds.size.height;
    tableViewFrame.origin.y = self.searchBar.bounds.origin.y + self.searchBar.bounds.size.height;
    NSLog(@"tableViewFrame keyboardHide : %f",tableViewFrame.size.height);
    //[self.searchTableView setFrame:self.view.bounds]; //ใช้เมื่อ searchBar อยู่ในลำดับเดียวกับ cell
    [self.searchTableView setFrame:tableViewFrame];
    [self footerTableView];
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length == 0) {
        
        isFilter = NO;
        NSLog(@"isFilter NO ");
        
        
    }else {
        isFilter = YES;
        NSLog(@"isFilter YES");
        NSString *searchTextSTR = [[NSString alloc]initWithFormat:@".*%@.*" ,searchText] ;
        NSLog(@"searchTextSTR : %@",searchTextSTR);
        NSPredicate *preItemName = [NSPredicate predicateWithFormat:@"itemName MATCHES[c] %@",searchTextSTR];
        NSLog(@"preItemName : %@",preItemName);
        filtered  = [itensListDB filteredArrayUsingPredicate:preItemName];
        NSLog(@"filtered count : %u",filtered.count);
        // for ทำงานเฉพราะ Array มิติเดียว เท่านั้น
        /*
         for (NSString *str in itemArray) {
         NSRange stringRange = [str rangeOfString:searchText options:NSCaseInsensitiveSearch];
         NSLog(@"stringRange : %i",stringRange.length);
         if (stringRange.location != NSNotFound) {
         [itensFilter addObject:str];
         NSLog(@"itensFilter count : %i",itensFilter.count);
         }
         }
         */
        
    }
    //[self.searchTableView reloadData];
    [self searchItems];
    [self refreshNewCell];
    
    
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [self.searchBar resignFirstResponder];
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
    
    if (isFilter) {
        return [filtered count];
        
    }
    //return [itemArray count];
    
    return [itensListDB count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //กำหนด SeparatorStyle ให้ tableView
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    //tableView.backgroundColor = addBgTable;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgCell.png"] ];
    
    [self configBTN];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    //============================================================
    //exercise = [itensListDB objectAtIndex:indexPath.row];
    if (!isFilter) {
        exercise = [itensListDB objectAtIndex:indexPath.row];
        //itemLabel.text = [exercise valueForKey:@"itemName"];
        //itemDetail.text = [exercise valueForKey:@"notice"];
        
    }else {
        exercise = [filtered objectAtIndex:indexPath.row];
        //itemLabel.text = [filtered valueForKey:@"itemName"];
        //itemDetail.text = [filtered valueForKey:@"notice"];
    }
    
    //exercise = [itensFilter objectAtIndex:indexPath.row];
    //cell.textLabel.text = [exercise valueForKey:@"itemName"];
    //typeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[exercise valueForKey:@"typeIcon"]]];
    itemImgBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconBlank.png"]];
    originalImage = [UIImage imageNamed:[exercise valueForKey:@"icon"]];
    itemImg = [[UIImageView alloc] initWithImage:[self resizeImageAndCor:originalImage]];
    itemLabel.text = [exercise valueForKey:@"itemName"];
    itemDetail.text = [exercise valueForKey:@"use"];
    //============================================================
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowGray.png"]];
    [cell.contentView addSubview:bgimage];
    [cell.contentView addSubview:itemImg];
    [cell.contentView addSubview:itemImgBG];
    [cell.contentView addSubview:itemLabel];
    [cell.contentView addSubview:itemDetail];
    //[cell.contentView addSubview:buttonAcc];
    
    
    //cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.backgroundView = bgimage;
    //cell.accessoryView = buttonAcc;
    
    
    [cell setSelectedBackgroundView:bgSelected];
    
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //CGRect tableViewFrame = self.searchTableView.frame;
    //NSLog(@"tableViewFrame keyboardShow didload : %f",tableViewFrame.size.height);
    
    return cell;
    
    //[self refreshNewCell];
    
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
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        //NSIndexPath *indexPath = [self.searchTableView indexPathForSelectedRow];
        if (!isFilter) {
            exercise = [itensListDB objectAtIndex:indexPath.row];
        }else {
            exercise = [filtered objectAtIndex:indexPath.row];
        }
        [self deleteFav];
        
    }
}
-(void)deleteFav
{
    NSLog(@"Begine delete Fav : !");
    context = [self managedObjectContext];
    NSEntityDescription *entityDescDel = [NSEntityDescription entityForName:@"Fav" inManagedObjectContext:context];
    NSFetchRequest *requestDel = [[NSFetchRequest alloc]init];
    [requestDel setEntity:entityDescDel];
    
    NSPredicate *predicateDel = [NSPredicate predicateWithFormat:@"itemID = %@",[exercise valueForKey:@"itemID"]];
    [requestDel setPredicate:predicateDel];
    
    NSError *error;
    itensListDB = [context executeFetchRequest:requestDel error:&error];
    
    if (itensListDB.count <= 0) {
        NSLog(@"No itemID");
        
    }else {
        int countFav = 0;
        for (NSManagedObject *obj in itensListDB) {
            [context deleteObject:obj];
            ++countFav; //เผื่อลบหลายตัวในคราวเดียว
        }
        [context save:&error];

        NSLog(@"itemID outCoreData : %@",[exercise valueForKey:@"itemID"]);
        NSLog(@"==========================");
        [self searchItems];
        [self refreshNewCell];
        //[self.searchTableView reloadData];
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    [self setAndShowItemsContent];
}

-(void)configBTN
{
    // Label
    itemLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 0, 230, 21)];
    itemLabel.font = [UIFont fontWithName:@"Arial" size:17];
    itemLabel.backgroundColor = [UIColor clearColor];
    itemLabel.textColor = [UIColor whiteColor];
    itemLabel.shadowColor = [UIColor blackColor];
    itemLabel.shadowOffset = CGSizeMake(2, 1);
    [itemLabel setAutoresizesSubviews:YES];
    [itemLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
     UIViewAutoresizingFlexibleHeight];
    
    // Detail
    itemDetail =[[UILabel alloc] initWithFrame:CGRectMake(62, 20, 230, 27)];
    itemDetail.numberOfLines = 2;
    itemDetail.font = [UIFont fontWithName:@"Arial" size:11 ];
    itemDetail.backgroundColor = [UIColor clearColor];
    itemDetail.textColor = [UIColor whiteColor];
    [itemDetail setAutoresizesSubviews:YES];
    [itemDetail setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
     UIViewAutoresizingFlexibleHeight];
    
    
    
    
    // ปุ่มย่อนใน Cell
    imageAcc = [UIImage imageNamed:@"arrowup.png"];
    buttonAcc = [UIButton  buttonWithType:UIButtonTypeCustom];
    [buttonAcc setBackgroundColor:[UIColor clearColor]];
    [buttonAcc setBackgroundImage:imageAcc forState:UIControlStateNormal];
    CGRect frame = CGRectMake(cell.frame.size.width  - imageAcc.size.width, cell.frame.size.height - imageAcc.size.height, imageAcc.size.width, imageAcc.size.height);
    buttonAcc.frame = frame;
    [buttonAcc addTarget:self action:@selector(goToDetail:)
        forControlEvents:UIControlEventTouchUpInside];
    [buttonAcc setBackgroundImage:imageAcc forState:UIControlStateHighlighted];
    
}
- (void)setAndShowItemsContent
{
    //self.typeMode = _typeMode;
    //segue
    [self performSegueWithIdentifier:@"FavoriteShowItemsContent" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"FavoriteShowItemsContent"]) {
        
        NSIndexPath *indexPath = [self.searchTableView indexPathForSelectedRow];
        ShowItemViewController *showItemViewController = segue.destinationViewController;
        
        if (!isFilter) {
            showItemViewController.itemsObj = [itensListDB objectAtIndex:indexPath.row];
        }else {
            showItemViewController.itemsObj = [filtered objectAtIndex:indexPath.row];
        }
        //ส่ง typeName ที่ได้เลือกใน row ของ typeTableView ไปเป็นตัวแปร RecipeTitle
        //NSIndexPath *indexPath = [self.itemsTableView indexPathForSelectedRow];
        //ใช้ exerciseType ช่วยแยก arrayย่อย ใน typeList
        //NSDictionary *exerciseItems = [itensListDB objectAtIndex:indexPath.row];
        //[segue.destinationViewController setTitleContent:[exerciseItems valueForKey:@"typeName"]];
        //NSLog(@"indexPath Selected : %@", [exerciseItems valueForKey:@"typeName"]);
        
    }
}


@end
