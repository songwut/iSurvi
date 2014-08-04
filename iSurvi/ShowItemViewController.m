//
//  ShowItemViewController.m
//  iSurvi
//
//  Created by Songwut on 12/28/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import "ShowItemViewController.h"
#import "AppDelegate.h"
#import "Fav.h"
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>

@interface ShowItemViewController ()
{
    NSManagedObjectContext *context;
    BOOL favBool;
}

@end

@implementation ShowItemViewController
@synthesize itemsObj;
@synthesize bgContentVeiw = _bgContentVeiw;

-(void)postFB
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebook = [[SLComposeViewController alloc] init];
        facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        [facebook setInitialText:[NSString stringWithFormat:@"%@ ",itemNameSub]];
        [facebook addImage:[self burnTextIntoImage:@"Photo From iSurvi Apps iOS" :iconImage]];
        [self presentViewController:facebook animated:YES completion:nil];

    }
}
-(void)postTW
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitter = [[SLComposeViewController alloc] init];
        twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        [twitter setInitialText:[NSString stringWithFormat:@"%@ ",itemNameSub]];
        //[twitter addImage:[self resizeImageToUpload:iconImage]];
        [twitter addImage:[self burnTextIntoImage:@"Photo From iSurvi Apps iOS" :iconImage]];
        [self presentViewController:twitter animated:YES completion:nil];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
    }
    if (buttonIndex == 1) {
        //Twitter
        [self postTW];
    }
    if (buttonIndex == 2) {
        //Facebook
        [self postFB];
    }
}
- (void)socialBtnPressed
{
    NSLog(@"socialBtn Clicked");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Share On Social Network!"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Cancle"
                                          otherButtonTitles:@"Twitter",@"Facebook", nil];
    [alert show];
}
- (UIBarButtonItem *) getSocialBtn
{
    
    socialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageSocial = [UIImage imageNamed:@"iconSocial.png"];
    [socialBtn setImage:imageSocial forState:UIControlStateNormal];
    [socialBtn setFrame:CGRectMake(0.0f,0.0f,imageSocial.size.width, imageSocial.size.height)];
    [socialBtn addTarget:self action:@selector(socialBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithCustomView:socialBtn];
    return searchBarButton;
}
- (NSManagedObjectContext *)managedObjectContext
{
    AppDelegate *appDelegate =(AppDelegate *) [[UIApplication sharedApplication]delegate];
    return appDelegate.managedObjectContext;
}
-(void)setBadgeValueFav
{
    //[self getSumFav];
    UITabBar *tabBar = self.tabBarController.tabBar;
    //Favorite Tab item
    UITabBarItem *item1 = (tabBar.items)[1];
    if ([numFav integerValue] > 0) {
        item1.badgeValue = @"New!";
        
    }else if ([numFav integerValue] < 1) {
        item1.badgeValue = nil;
        numFav = [NSNumber numberWithInt:0];
    }
    /*
    else {
        
        //[UIApplication sharedApplication].self.applicationIconBadgeNumber = 0;
        favPlus = 0;
    }
     */
    NSLog(@"========================");
    NSLog(@"numFav = %@",numFav);
    NSLog(@"========================");
    
}

-(void)insertFav
{
    NSLog(@"Begine insert Fav : !");
    context = [self managedObjectContext];
    Fav *fav = [NSEntityDescription insertNewObjectForEntityForName:@"Fav" inManagedObjectContext:context];
    fav.itemID = itemIDSub;
    fav.itemName = itemNameSub;
    fav.icon = iconSub;
    fav.use = useSub;
    fav.shop = shopSub;
    fav.notice = noticeSub;
    fav.backpack = backpackSub;
    fav.minipack = minipackSub;
    fav.carpack = carpackSub;
    fav.type = typeSub;
    fav.favStatus = [NSNumber numberWithInteger:1];
    
    numFav =[NSNumber numberWithInt:favPlus + 1];
    // update ค่าของ favPlus ให้เท่ากับ numFav
    favPlus = [numFav integerValue];
    NSLog(@"itemID inCoreData : %@",itemIDSub);
    NSLog(@"numFav = %@",numFav);
    NSLog(@"==========================");
    NSError *error;
    if (![context save:&error]) { NSLog(@"insert Fav ERROR : Fool!"); }
}
-(void)deleteFav
{
    NSLog(@"Begine delete Fav : !");
    context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Fav" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    //NSString *stTextSTR = [[NSString alloc]initWithFormat:@".*%@.*" ,@"_"] ;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID = %@",itemsObj.itemID];
    [request setPredicate:predicate];
     
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
        numFav =[NSNumber numberWithInt:favPlus - 1];
        // update ค่าของ favPlus ให้เท่ากับ numFav
        favPlus = [numFav integerValue];
        NSLog(@"itemID outCoreData : %@",itemsObj.itemID);
        NSLog(@"numFav = %@",numFav);
        NSLog(@"==========================");
        
    }
    
}
- (void)searchFav
{
    context = [self managedObjectContext];
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Fav" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    [request setEntity:entityDesc];
    //NSString *stTextSTR = [[NSString alloc]initWithFormat:@".*%@.*" ,@"_"] ;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"itemID == %@",itemIDSub];
    [request setPredicate:predicate];
    
    NSError *error;
    favList = [context executeFetchRequest:request error:&error];
    if (favList.count == 0) {
        
        favCheck = NO;
        imageFav = [UIImage imageNamed:@"iconStarTran.png"];
        NSLog(@"No itemID");
        
    }else {
        
        favCheck = YES;
        imageFav = [UIImage imageNamed:@"iconStar.png"];
        NSLog(@"itemID: %u", favList.count);
    }
    

}
-(void)customFavButton
{
    
    favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favBtn setImage:imageFav forState:UIControlStateNormal];
    [favBtn setFrame:CGRectMake(sizeOfIconShow - imageFav.size.width + 10,
                                sizeOfIconShow - imageFav.size.height +10,
                                imageFav.size.width,
                                imageFav.size.height)];
    [favBtn addTarget:self action:@selector(favBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:favBtn];
}
- (void)favBtnPressed
{
    NSLog(@"Favorite Clicked");
    //[self searchFav];
    if (favCheck == NO) {
        //เช็คว่ายังไม่บันทึก ให้ทำการบันทึก
        [self insertFav];
        //[self setBadgeValueFav];
        UITabBar *tabBar = self.tabBarController.tabBar;
        UITabBarItem *item1 = (tabBar.items)[1];
        item1.badgeValue = @"New!";
        [self searchFav]; //รูปมีการเปลี่ยน
        [favBtn setImage:imageFav forState:UIControlStateNormal];
        NSLog(@"Favorite Insert");
        
    }else {
        //เช็คว่ามีบันทึกใน Favorite แล้วให้ยกเลิก/ลบออกจาก DB
        [self deleteFav];
        //[self setBadgeValueFav];
        [self searchFav]; //รูปมีการเปลี่ยน
        [favBtn setImage:imageFav forState:UIControlStateNormal];
        NSLog(@"Favorite Uninsert");
        
    }
    
    
    /*
    for (UIButton *but in [self.view subviews]) {
        if ([but isKindOfClass:[UIButton class]]) {
            [but setSelected:NO];
        }
    }
    if (!button.selected) {
        button.selected = !button.selected;

    }
     */
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
    NSLog(@"viewWillAppear : ShowitemsViewController");
    favPlus = [numFav integerValue];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
- (void)viewWillDisappear:(BOOL)animated
{
    //[self showTabBar];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    sizeOfIconShow = 100;
    //============================================================
    //ใส่ค่าในตัวแปรเพื่อเรียกใช้ได้ทันที Apps ไม่กระตุก ค่าอยู่ตลอด
    backpackSub= itemsObj.backpack;
    carpackSub= itemsObj.carpack;
    iconSub= itemsObj.icon;
    itemIDSub = itemsObj.itemID;
    itemNameSub = itemsObj.itemName;
    minipackSub = itemsObj.minipack;
    noticeSub = itemsObj.notice;
    shopSub = itemsObj.shop;
    typeSub = itemsObj.type;
    useSub = itemsObj.use;
    self.navigationItem.title = itemNameSub;
    //============================================================
    //ต้องค้นหาหลังจากตัวแปร set ค่าแล้ว
    [self searchFav];
    //[self hideTabBar];
    //============================================================
    //เพิ่มปุ่ม Fav มุมขวาของ navigationbar
    self.navigationItem.rightBarButtonItem = [self getSocialBtn];
    [self customFavButton];
    //self.navigationItem.rightBarButtonItem = [self getFavBtn];
    //============================================================
    
    self.bgContentVeiw.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDK.png"]];
    //============================================================
    //set Effect lightView
    lightView = [[UIView alloc] init];
    [lightView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"lightTer.png"]]];
    [self.view addSubview:lightView];
    //============================================================
    
    //กำหนดปุ่ม ด้านซ้ายเป็นปุ่มแบบ custom
    self.navigationItem.leftBarButtonItem = [self getBackBtn];
    //============================================================
    
    NSLog(@"icon is : %@ ",iconSub);
    iconImage = [UIImage imageNamed:iconSub];
    [self.showicon setImage:[self resizeImageAndCor:iconImage]];
    self.showicon.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.showicon.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.showicon.layer.shadowOpacity = 1.0f;
    self.showicon.layer.shadowRadius = 2.0f;
    
    self.showUse.text = [[NSString alloc]initWithFormat:@"Use : %@",itemsObj.use];
    self.showShop.text = [[NSString alloc]initWithFormat:@"Shop : %@",itemsObj.shop];
    //self.showNotice.text = [[NSString alloc]initWithFormat:@"Notice : %@",itemsObj.notice];

    // Label

    noticeTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.scrollView.bounds.size.width, 0)];
    noticeTextView.font = [UIFont fontWithName:@"Arial" size:14];
    noticeTextView.backgroundColor = [UIColor clearColor];
    noticeTextView.textColor = [UIColor whiteColor];
    noticeTextView.textAlignment = NSTextAlignmentJustified;
    noticeTextView.layer.shadowColor = [[UIColor blackColor] CGColor];
    noticeTextView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    noticeTextView.layer.shadowOpacity = 1.0f;
    noticeTextView.layer.shadowRadius = 1.0f;
    
    [noticeTextView setEditable:NO];
    [noticeTextView setAutoresizesSubviews:YES];
    [noticeTextView setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
     UIViewAutoresizingFlexibleHeight];
    noticeTextView.text = [[NSString alloc]initWithFormat:@"Notice : %@",itemsObj.notice];
    
    [self.scrollView addSubview:noticeTextView];
    //ใส่พื้นหลังให้ Notice
    //UIColor *rgbNews = [self getRGBAsFromImage:iconImage];
    //noticeTextView.backgroundColor = rgbNews;

}
-(void)footerContent
{
    //ใส่ footer ให้ Content เพื่อไม่ให้ Tabbar บัง บันทัด สุดท้าย
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 70)];
    footer.backgroundColor = [UIColor clearColor];
    //self.searchTableView.tableFooterView = footer;
}
-(UIImage*)resizeImageAndCor:(UIImage*)image
{
    //ขนาดปรกติ
    CGRect oldimageRect = CGRectMake(0, 0, sizeOfIconShow, sizeOfIconShow);
    //ขนาดย่อลง
    CGRect newimageRect = CGRectMake(0, 0, 100, 100);
    //เริ่มวาดจากขนาดเดิมคือ oldimageRect
    UIGraphicsBeginImageContextWithOptions(oldimageRect.size,NO,0.0);
    //กำหนด path วาดขนาดหดเล็กลงใน newimageRect
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newimageRect cornerRadius:10.f];
    [path addClip];
    //นำรูปที่วาดใน path ใส่ไปที่ image ในขนาดเดิมคือ oldimageRect
    [image drawInRect:oldimageRect];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
-(UIImage*)resizeImageToUpload:(UIImage*)image
{
    //ขนาดปรกติ
    CGRect oldimageRect = CGRectMake(0, 0, 600, 600);
    //ขนาดย่อลง
    CGRect newimageRect = CGRectMake(25, 25, 550, 550);
    //เริ่มวาดจากขนาดเดิมคือ oldimageRect
    UIGraphicsBeginImageContextWithOptions(oldimageRect.size,NO,0.0);
    //กำหนด path วาดขนาดหดเล็กลงใน newimageRect
    [image drawInRect:oldimageRect];
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:newimageRect cornerRadius:20.f];
    [path addClip];
    //นำรูปที่วาดใน path ใส่ไปที่ image ในขนาดเดิมคือ oldimageRect
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
- (UIImage *)burnTextIntoImage:(NSString *)text :(UIImage *)img {
    
    UIGraphicsBeginImageContext(img.size);
    
    CGRect aRectangle = CGRectMake(0,0, img.size.width, img.size.height);
    [img drawInRect:aRectangle];
    
    [[UIColor grayColor] set];    // set text color
    NSInteger fontSize = 16;
    if ( [text length] > 200 ) {
        fontSize = 10;
    }
    UIFont *font = [UIFont boldSystemFontOfSize: fontSize];   // set text font
    
    [ text drawInRect : aRectangle withFont : font];
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    [self resizeImageToUpload:theImage];
    UIGraphicsEndImageContext();     // clean  up the context.
    return theImage;
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
- (UIColor *)getRGBAsFromImage:(UIImage*)image
//+ (NSArray*)getRGBAsFromImage:(UIImage*)image atX:(int)xx andY:(int)yy count:(int)count
{
    //NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    UIColor *newColor;
    
    // First get the image into your data buffer
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef ctx = CGBitmapContextCreate(rawData, width, height,
                                                 bitsPerComponent, bytesPerRow, colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    
    CGContextDrawImage(ctx, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(ctx);
    
    // Now your rawData contains the image data in the RGBA8888 pixel format.
    //int byteIndex = (bytesPerRow * xx) + yy * bytesPerPixel;
    int byteIndex = (bytesPerRow * 20) + 20 * bytesPerPixel;
    //for (int ii = 0 ; ii < count ; ++ii)
    for (int ii = 0 ; ii < 1 ; ++ii)
    {
        CGFloat red   = (rawData[byteIndex]     * 1.0) / 255.0;
        CGFloat green = (rawData[byteIndex + 1] * 1.0) / 255.0;
        CGFloat blue  = (rawData[byteIndex + 2] * 1.0) / 255.0;
        CGFloat alpha = (rawData[byteIndex + 3] * 0) + 1.0;
        byteIndex += 4;
        
        //UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        //[result addObject:acolor];
        newColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
    }
    
    free(rawData);
    
    //return acolor;
    return newColor;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidUnload {
    [self setShowShop:nil];
    [self setShowicon:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
