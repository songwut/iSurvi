//
//  EssentalViewController.m
//  iSurvi
//
//  Created by Songwut on 12/16/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import "EssentalViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJson.h"
#import "itemsTableViewController.h"
#import "SearchViewController.h"



@interface EssentalViewController ()
{
    NSManagedObjectContext *context;
    int checkSelect;
    int widthOfCell;
    CGFloat screenWidth;
}
@property (nonatomic) int typeMode;
@end

@implementation EssentalViewController {
    NSArray *recipes;
}
-(void)readHostLive
{
    //ระบบแจ้งข่าวใหม่
    NSLog(@"Begine read UpdateResult : !");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    hostLive = [defaults objectForKey:@"HostLiveValue"];
    
}
- (void)fetchTweets
{
    //ตัวfilter ให้แสดงล่าสุดกี่ row
    // %23 = Tag  (#)
    // %40 = Mention (@)
    NSString *tweetStrAll = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%%40%@",hostLive] ;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* dataAll = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: tweetStrAll]];
        NSError* error;
        @try {
            NSLog(@"tweets ok");
            NSDictionary *jsonResultsAll = [NSJSONSerialization JSONObjectWithData:dataAll options:kNilOptions error:&error];
            tweetsAll = [jsonResultsAll objectForKey:@"results"];
            
        }
        @catch ( NSException *e ) {
            NSLog(@"tweets internet Error");
        }
        @finally {
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self readUpdateCount];
        });
    });
    
}

-(void)readUpdateCount
{
    //ระบบแจ้งข่าวใหม่
    NSLog(@"Begine read UpdateCount : !");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSUInteger UpdateCountOld = [[defaults objectForKey:@"UpdateCountValue"] intValue];
    NSLog(@"UpdateCountNew : %lu",(unsigned long)tweetsAll.count);
    NSLog(@"UpdateCountOld : %lu",(unsigned long)UpdateCountOld);
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item2 = (tabBar.items)[2];

    if (tweetsAll.count > UpdateCountOld) {
        
        item2.badgeValue = @"New!";
        
    }else {

    }
    
    
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    //[UIView beginAnimations:@"animateAdBannerOn" context:NULL];
    //banner.frame = CGRectOffset(banner.frame, 0, 0.0f);
    //NSLog(@"load banner height : %f",banner.frame.size.height);
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:1];
    [UIView commitAnimations];
}
-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [banner setAlpha:0];
    [UIView commitAnimations];
}

- (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    return appDelegate.managedObjectContext;
}

//@synthesize tabBar = _tabBar;
@synthesize typeBTN = _typeBTN;
@synthesize packBTN = _packBTN;
//@synthesize allBTN = _allBTN;
@synthesize typeMode = _typeMode;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"didSelectRow");
    [self setAndShowItems];
    
    /*
     if (selection) {
     //[self.typeTableView deselectRowAtIndexPath:selection animated:YES];
     NSLog(@"selection: %@", selection);
     }
     */
}
- (void)setAndShowItems
{
    //self.typeMode = _typeMode;
    //segue
    [self performSegueWithIdentifier:@"ShowItems" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowSearch"]) {
        
    }
    
    if ([segue.identifier isEqualToString:@"ShowItems"]) {
        NSIndexPath *selection = [self.typeTableView indexPathForSelectedRow];
        typeRow = selection.row + 1;
        // +1 เพราะเปลี่ยนการนับ row เริ่มจาก 0 เป็นเริ่มจากนับ 1
        NSLog(@"selection in Type Row: %d", typeRow);
        //ส่ง typeGroup ไปเป็นตัวแปร GroupMode ชนิดหลัก
        [segue.destinationViewController setGroupMode:typeGroup];
        //ส่ง typeRow ไปเป็นตัวแปร GroupSub items ใน ชนิดหลัก
        [segue.destinationViewController setGroupSub:typeRow];
        
        //ส่ง typeName ที่ได้เลือกใน row ของ typeTableView ไปเป็นตัวแปร RecipeTitle
        NSIndexPath *indexPath = [self.typeTableView indexPathForSelectedRow];
        //ใช้ exerciseType ช่วยแยก arrayย่อย ใน typeList
        NSDictionary *exerciseType = [typeList objectAtIndex:indexPath.row];
        [segue.destinationViewController setRecipeTitle:[exerciseType valueForKey:@"typeName"]];
        NSLog(@"indexPath Selected : %@", [exerciseType valueForKey:@"typeName"]);
        
    }
}
-(void)animationLoadNewCell
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
    [self.typeTableView beginUpdates];
    [self.typeTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    [self.typeTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
    [self.typeTableView endUpdates];
    //โหลดข้อมูลใหม่ธรรมดา
    //[self.typeTableView reloadData];
}

-(void)footerTableView
{
    //ใส่ footer ให้ TableView เพื่อไม่ให้ Tabbar บัง cell สุดท้าย
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 50+33)];
    footer.backgroundColor = [UIColor clearColor];
    [footer addSubview:adView];
    self.typeTableView.tableFooterView = footer;
    
    
}
-(void)readLanguage
{
    NSLog(@"Begine read Language : !");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    langPrefix = [defaults objectForKey:@"LanguageValue"];
    NSLog(@"langPrefix: %@", langPrefix);
    
    if ([langPrefix isEqualToString:@"th_"]) {
        typeTitle = @"ชนิด";
        packTitle = @"กระเป๋า";
        eventTitle = @"เหตุการณ์";
    }else {
        typeTitle = @"Type";
        packTitle = @"Pack";
        eventTitle = @"Event";
    }
}
-(void)typeChange
{
    
    
    if (_typeBTN.selected == YES) {
        NSString *langFile = [NSString stringWithFormat:@"%@_type",langPrefix];
        NSLog(@"langFile: %@", langFile);
        // ดึงไฟล์ th.json
        NSString *filePath = [[NSBundle mainBundle] pathForResource:langFile ofType:@"json"];
        //============================================================
        //ใช้ SBJson เก็บเนื้อหามาใส่ itemList ซึ่งตั้งไว้เป็น MutableArray
        NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath      encoding:NSUTF8StringEncoding error:nil];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        typeList = [parser objectWithString:fileContent error:nil];
        
        typeGroup = @"type";
        NSLog(@"Type Group: %@", typeGroup);
        //แสดงจำนวน row ออกมาใน output
        NSLog(@"typeList TYPE Count: %lu", (unsigned long)typeList.count);
        [self animationLoadNewCell];
        
    }else if (_packBTN.selected == YES) {
        NSString *langFile = [NSString stringWithFormat:@"%@_pack",langPrefix];
        NSLog(@"langFile: %@", langFile);
        // ดึงไฟล์ th.json
        NSString *filePath = [[NSBundle mainBundle] pathForResource:langFile ofType:@"json"];
        //============================================================
        //ใช้ SBJson เก็บเนื้อหามาใส่ itemList ซึ่งตั้งไว้เป็น MutableArray
        NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath      encoding:NSUTF8StringEncoding error:nil];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        typeList = [parser objectWithString:fileContent error:nil];
        typeGroup = @"pack";
        NSLog(@"Type Group: %@", typeGroup);
        //แสดงจำนวน row ออกมาใน output
        NSLog(@"typeList PACK Count: %lu", (unsigned long)typeList.count);
        [self animationLoadNewCell];
    }/*else if (_allBTN.selected == YES) {
        NSString *langFile = [NSString stringWithFormat:@"%@_event",langPrefix];
        NSLog(@"langFile: %@", langFile);
        // ดึงไฟล์ th.json
        NSString *filePath = [[NSBundle mainBundle] pathForResource:langFile ofType:@"json"];
        //============================================================
        //ใช้ SBJson เก็บเนื้อหามาใส่ itemList ซึ่งตั้งไว้เป็น MutableArray
        NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath      encoding:NSUTF8StringEncoding error:nil];
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        typeList = [parser objectWithString:fileContent error:nil];
        typeGroup = @"event";
        NSLog(@"Type Group: %@", typeGroup);
        //แสดงจำนวน row ออกมาใน output
        NSLog(@"typeList Event Count: %lu", (unsigned long)typeList.count);
        [self animationLoadNewCell];
    }*/
    
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    adRect = CGRectMake(adView.frame.origin.x, 0, self.view.frame.size.width, adView.frame.size.height);
    
    adView.frame = CGRectOffset(adRect, 0, 0);
    
    //CGRect frame = CGRectMake(cell.frame.size.width  - imageUp.size.width, cell.frame.size.height - imageUp.size.height, imageUp.size.width, imageUp.size.height);
    /*
     CGRect screenBound = [[UIScreen mainScreen] bounds];
     CGSize screenSize = screenBound.size;
     CGFloat screenHeight = screenSize.height;
     //CGFloat screenWidth = screenSize.width;
     NSLog(@"screenHeight: %f", screenHeight);
     */
}
- (UIBarButtonItem *) getSearchBtn
{
    UIButton * searchBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *imageSearch = [UIImage imageNamed:@"iconTopSearch.png"];
    [searchBtn setImage:imageSearch forState:UIControlStateNormal];
    [searchBtn setFrame:CGRectMake(0.0f,0.0f,imageSearch.size.width, imageSearch.size.height)];
    [searchBtn addTarget:self action:@selector(searchBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithCustomView:searchBtn];
    return searchBarButton;
}
- (void)searchBtnPressed
{
    //[self.navigationController popViewControllerAnimated:YES];
    NSLog(@"search Clicked");
    [self setAndShowSearch];
}
- (void)setAndShowSearch
{
    //self.typeMode = _typeMode;
    //segue
    [self performSegueWithIdentifier:@"ShowSearch" sender:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //============================================================
     adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adRect = CGRectMake(adView.frame.origin.x, 0, self.view.frame.size.width, adView.frame.size.height);
    
     adView.frame = CGRectOffset(adRect, 0, 0);
    
    //self.typeTableView.tableHeaderView = adView;
     adView.delegate = self;
    //============================================================
    [[self typeTableView]setDelegate:self];
    [[self typeTableView]setDataSource:self];
    //self.typeTableView.frame.size.height = 300.0f;
    [self readLanguage];
    // กำหนดให้เลือกปุ่มใดปุ่มหนึ่งบน Typr Bar
    [self.typeBTN setSelected:YES ];
    //============================================================
    self.navigationItem.rightBarButtonItem = [self getSearchBtn];
    //============================================================
    //แสดง theme ที่ออกแบบไว้
    customNavBar
    //[self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    customTabBar
    //[self shadowOfNavBar];
    [self configBTN];
    [self typeChange];
    [self footerTableView];
    
    //[self readJason];

    //============================================================
    
    //============================================================
    // insert json ลง core data
    // พื้นหลัง tableView
    //addBgTable = [UIColor colorWithPatternImage:[UIImage imageNamed:@"blank.png"]];
    self.mainBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDK.png"]];

    addBgTable = [UIColor clearColor];
    bgSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgSelected.png"] ];
    //============================================================
    // อีกตัวอย่างที่ใช้งานได้
    /*
     NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
     id jsonObjects = [NSJSONSerialization JSONObjectWithData:fileData options:NSJSONReadingMutableContainers error:nil];
     //NSLog(@"Path: %@", jsonObjects);
     // values in foreach loop
     for (NSDictionary *dataDict in jsonObjects) {
     NSString *itemName = [dataDict objectForKey:@"itemName"];
     NSString *icon = [dataDict objectForKey:@"icon"];
     NSString *use = [dataDict objectForKey:@"use"];
     NSString *shop = [dataDict objectForKey:@"shop"];
     NSString *notice = [dataDict objectForKey:@"notice"];
     NSString *backpack = [dataDict objectForKey:@"backpack"];
     NSString *minipack = [dataDict objectForKey:@"minipack"];
     NSString *type = [dataDict objectForKey:@"type"];
     
     NSLog(@"itemName = %@",itemName);
     NSLog(@"icon = %@",icon);
     NSLog(@"use = %@",use);
     NSLog(@"shop = %@",shop);
     NSLog(@"notice = %@",notice);
     NSLog(@"backpack = %@",backpack);
     NSLog(@"minipack = %@",minipack);
     NSLog(@"type = %@",type);
     NSLog(@"====================");
     
     }
     NSLog(@"OBJ = %@",itemName);
     */
    //============================================================
    // custom Search Bar (need Outlet)
    //[self.searchBar setBackgroundImage:[UIImage imageNamed:@"bgSearchbar.png"]];
    
    //============================================================
    // custom Type Bar
    
    // พื้นหลังทั้งหมด
    
    self.view.backgroundColor = addBgTable;
    //พื้นหลัง TypeBar
    UIColor *Typebar = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgTypebar.png"]];
    self.bgTypebar.backgroundColor = Typebar;
    
    [self.typeBTN setTitle:typeTitle forState:UIControlStateNormal ];
    [self.typeBTN setBackgroundImage:[UIImage imageNamed:@"bgBtn_Select.png"] forState:UIControlStateSelected];
    [self.typeBTN addTarget:self action:@selector(changeGroup:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.packBTN setTitle:packTitle forState:UIControlStateNormal];
    [self.packBTN setBackgroundImage:[UIImage imageNamed:@"bgBtn_Select.png"] forState:UIControlStateSelected];
    [self.packBTN addTarget:self action:@selector(changeGroup:) forControlEvents:UIControlEventTouchUpInside];
    /*
    [self.allBTN setTitle:eventTitle forState:UIControlStateNormal];
    [self.allBTN setBackgroundImage:[UIImage imageNamed:@"bgBtn_Select.png"] forState:UIControlStateSelected];
    [self.allBTN addTarget:self action:@selector(changeGroup:) forControlEvents:UIControlEventTouchUpInside];
    */
    
    
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
    //[self.tabBarController.tabBar.bounds.size.height:44.0];
    
    
    [self hideTabBar];
    [self showTabBar];
    [self readHostLive];
    //readHostLive ต้องมาก่อน fetchTweets เพราะมีการรับค่าตัวแปรใน readHostLive
    [self fetchTweets];
    
}

- (void)hideTabBar {
    UITabBar *tabBar = self.tabBarController.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
    UIView *window = parent.superview;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect tabFrame = tabBar.frame;
                         //+20 เพราะใช้ tabbar แบบปรับแต่งสูงกว่าปรกติ
                         tabFrame.origin.y = CGRectGetMaxY(window.bounds)+20;
                         tabBar.frame = tabFrame;
                         content.frame = window.bounds;
                     }];
    
}
- (void)showTabBar {
    UITabBar *tabBar = self.tabBarController.tabBar;
    UIView *parent = tabBar.superview; // UILayoutContainerView
    UIView *content = [parent.subviews objectAtIndex:0];  // UITransitionView
    UIView *window = parent.superview;
    
    [UIView animateWithDuration:0.5
                     animations:^{
                         CGRect tabFrame = tabBar.frame;
                         tabFrame.origin.y = CGRectGetMaxY(window.bounds) - CGRectGetHeight(tabBar.frame);
                         tabBar.frame = tabFrame;
                         
                         CGRect contentFrame = content.frame;
                         contentFrame.size.height -= tabFrame.size.height;
                     }];
}
-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"Essental viewWillAppear");
    
    adRect = CGRectMake(adView.frame.origin.x, 0, self.view.frame.size.width, adView.frame.size.height);
    adView.frame = CGRectOffset(adRect, 0, 0);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.4];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.view cache:YES];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView commitAnimations];
    
    
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController*)viewController
{
    
    
    // prepare your view switching
    //[[[ViewController view]layer]addAnimation:transition forKey:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeGroup:(UIButton *)button{
    
    for (UIButton *but in [self.view subviews]) {
        if ([but isKindOfClass:[UIButton class]] && ![but isEqual:button]) {
            [but setSelected:NO];
            [self typeChange];
        }
    }
    if (!button.selected) {
        button.selected = !button.selected;
        [self typeChange];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
     if (tableView == self.tableView1) {
     return 10;
     } else if (tableView == self.tableView2) {
     return 20;
     }
     */
    //return [itemArray count];
    return [typeList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //กำหนด SeparatorStyle ให้ tableView
    
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    tableView.backgroundColor = addBgTable;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgCell.png"] ];
    
    [self configBTN];
    
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    //============================================================
    if ([typeGroup isEqual: @"type"] || [typeGroup isEqual: @"pack"] ) {
        NSDictionary *exercise = [typeList objectAtIndex:indexPath.row];
        typeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[exercise valueForKey:@"typeIcon"]]];
        typeLabel.text = [exercise valueForKey:@"typeName"];
        typeDetail.text = [exercise valueForKey:@"typeDis"];
        
    }else if ([typeGroup isEqual: @"event"]) {
        // กลุ่มใหม่
        NSDictionary *exercise = [typeList objectAtIndex:indexPath.row];
        typeImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[exercise valueForKey:@"eventIcon"]]];
        typeLabel.text = [exercise valueForKey:@"eventName"];
        typeDetail.text = [exercise valueForKey:@"eventDis"];
    }
    //============================================================
    
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowGray.png"]];
    [cell.contentView addSubview:bgimage];
    [cell.contentView addSubview:typeImg];
    [cell.contentView addSubview:typeLabel];
    [cell.contentView addSubview:typeDetail];
    //[cell.contentView addSubview:buttonAcc];
    
    
    //cell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.backgroundView = bgimage;
    //cell.accessoryView = buttonAcc;
    
    
    [cell setSelectedBackgroundView:bgSelected];
    //cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    
    
    return cell;
}
#pragma mark - Table view delegate
-(void) goToDetail:(id) sender
{
    
    UITableViewCell *clickedCell = (UITableViewCell *)[[sender superview] superview];
    
    NSIndexPath *clickedButtonPath = [self.typeTableView indexPathForCell:clickedCell];
    NSLog(@"clickedCell: %@", clickedCell);
    NSLog(@"clickedButtonPath: %@", clickedButtonPath);
}




- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    /*
     DetailViewController *detailView =[[DetailViewController alloc]init];
     [self.navigationController pushViewController:detailView animated:YES];
     */
    NSLog(@"click ass");
}
-(void)configBTN
{
    // Label
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 0, 230, 21)];
    typeLabel.font = [UIFont fontWithName:@"Arial" size:17];
    typeLabel.backgroundColor = [UIColor clearColor];
    typeLabel.textColor = [UIColor whiteColor];
    typeLabel.shadowColor = [UIColor blackColor];
    typeLabel.shadowOffset = CGSizeMake(2, 1);
    [typeLabel setAutoresizesSubviews:YES];
    [typeLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
     UIViewAutoresizingFlexibleHeight];
    
    // Detail
    typeDetail =[[UILabel alloc] initWithFrame:CGRectMake(62, 20, 230, 27)];
    typeDetail.numberOfLines = 2;
    typeDetail.font = [UIFont fontWithName:@"Arial" size:11 ];
    typeDetail.backgroundColor = [UIColor clearColor];
    typeDetail.textColor = [UIColor whiteColor];
    [typeDetail setAutoresizesSubviews:YES];
    [typeDetail setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
     UIViewAutoresizingFlexibleHeight];
    
    
    
    
    // ปุ่มย่อนใน cell
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

- (void)viewDidUnload {
    [self setTypeTableView:nil];
    [self setMainBgView:nil];
    [super viewDidUnload];
}
@end
