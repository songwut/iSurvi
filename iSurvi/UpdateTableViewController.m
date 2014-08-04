//
//  UpdateTableViewController.m
//  iSurvi
//
//  Created by Songwut on 1/24/13.
//  Copyright (c) 2013 Songwut. All rights reserved.
//

#import "UpdateTableViewController.h"
#import "ShowUpdateViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>

@interface UpdateTableViewController ()

@end

@implementation UpdateTableViewController
@synthesize textLoading, refreshHeader, topLabel,  spinner, tweets, mainStr;

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
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
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    adRect = CGRectMake(adView.frame.origin.x, 0, self.view.frame.size.width, adView.frame.size.height);
    adView.frame = CGRectOffset(adRect, 0, 0);
}
- (void)socialBtnPressed
{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitter = [[SLComposeViewController alloc] init];
        twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitter setInitialText:[NSString stringWithFormat:@"@%@ ",hostLiveData]];
        [self presentViewController:twitter animated:YES completion:nil];
        /*
         bug Zombies ยังแก้ไม่ได้
        [twitter setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *msgout;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    msgout = @"Tweet Cancelled";
                    break;
                case SLComposeViewControllerResultDone:
                    msgout = @"Tweet Cuccessfuld";
                    break;
                    
                default:
                    break;
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tweet" message:msgout delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }];
         */
    }
    
}
- (UIBarButtonItem *) getSocialBtn
{
    
    socialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageSocial = [UIImage imageNamed:@"iconTw.png"];
    [socialBtn setImage:imageSocial forState:UIControlStateNormal];
    [socialBtn setFrame:CGRectMake(0.0f,0.0f,imageSocial.size.width, imageSocial.size.height)];
    [socialBtn addTarget:self action:@selector(socialBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithCustomView:socialBtn];
    return searchBarButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    customNavBar
    customTabBar
    [self shadowOfNavBar];
    self.navigationItem.rightBarButtonItem = [self getSocialBtn];
    //============================================================
    adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adRect = CGRectMake(adView.frame.origin.x, 0, self.view.frame.size.width, adView.frame.size.height);
    
    adView.frame = CGRectOffset(adRect, 0, 0);
    //self.typeTableView.tableHeaderView = adView;
    adView.delegate = self;
    //============================================================
    //textLoading = @"Loading...";
    //[self addRefreshHeader];
    
    //[self stopLoading];
    // พื้นหลัง tableView
    //addBgTable = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDK.png"]];
    //addBgTable = [UIColor clearColor];
    UIView *patternView = [[UIView alloc] initWithFrame:self.tableView.frame];
    patternView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDK.png"]];
    patternView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundView = patternView;
    //self.tableView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDK.png"]];
    bgSelected = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgSelected.png"] ];
    
    //self.updateTableView.backgroundColor = addBgTable;
    //============================================================
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:nil action:@selector(refresh)
             forControlEvents:UIControlEventValueChanged];
    refreshControl.tintColor = [UIColor colorWithRed:0.146 green:0.861 blue:0.966 alpha:1.000];
    self.refreshControl = refreshControl;
    refreshMsg = [NSString stringWithFormat:@"Pull Down to Refresh"];
    
    refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:refreshMsg
                                                                     attributes:@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica" size:11.0]}];
    //============================================================
    [self fetchTweets];
    
    //[self.tableView reloadData];
    [self refreshNewCell];
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.hidesWhenStopped = YES;
    [self addActivity];
    //============================================================
    [self footerTableView];
}
-(void)footerTableView
{
    //ใส่ footer ให้ TableView เพื่อไม่ให้ Tabbar บัง cell สุดท้าย
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 50+33)];
    footer.backgroundColor = [UIColor clearColor];
    [footer addSubview:adView];
    self.updateTableView.tableFooterView = footer;
}
- (void)addActivity
{
    [activity setColor:[UIColor colorWithRed:0.146 green:0.861 blue:0.966 alpha:1.000]];
    
    [activity setFrame:CGRectMake((self.view.frame.size.width/2)-10, 100, 20, 20)];

    loadText = [[UILabel alloc] initWithFrame:CGRectMake((self.tableView.frame.size.width/2)-50, 130, 200, 20)];
    loadText.backgroundColor = [UIColor clearColor];
    loadText.font = [UIFont fontWithName:@"Arial" size:11];
    loadText.textColor = [UIColor whiteColor];
    loadText.text = refreshMsg;
    [self.updateTableView addSubview:loadText];
    [self.updateTableView addSubview:activity];
    
    [activity startAnimating];
}
- (void)viewWillAppear:(BOOL)animated {
    
    UITabBar *tabBar = self.tabBarController.tabBar;
    UITabBarItem *item2 = (tabBar.items)[2];
    item2.badgeValue = nil;
    
    [super viewWillAppear:animated];
    
    adRect = CGRectMake(adView.frame.origin.x,0,self.view.frame.size.width,adView.frame.size.height);
    adView.frame = CGRectOffset(adRect, 0, 0);
}
- (void)refresh {
    NSLog(@"Refreshing");
    [self fetchTweets];
    
    [self performSelector:@selector(updateTable) withObject:nil afterDelay:2.2f];
}
- (void)updateTable
{
    //[self.tableView reloadData];
    [self refreshNewCell];
    [self.refreshControl endRefreshing];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSLog(@"Launching Something");
        //replace appname with any specific name you want
        
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/appname"]];
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/iSurviLive"]];
    }
}
-(void)saveUpdateCount
{
    if (tweets.count == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"can't connect to server !"
                                                        message:@"Server Under Construction"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else {
        NSLog(@"Begine save UpdateCount : !");
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[NSString stringWithFormat:@"%i",tweetsAll.count] forKey:@"UpdateCountValue"];
        [defaults synchronize];
    }
    
}
-(void)readUpdateResult
{
    //ระบบแจ้งข่าวใหม่
    NSLog(@"Begine read UpdateResult : !");
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    UpdateResult = [[defaults objectForKey:@"UpdateResultValue"] intValue];
    hostLiveData = [defaults objectForKey:@"HostLiveValue"];
    NSLog(@"UpdateResult : %i",UpdateResult);

}
- (void)fetchTweets
{
    // %23 = Tag  (#)
    // %40 = Mention (@)
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self readUpdateResult];
    NSString *tweetAllStr = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%%40%@",hostLiveData];
    //NSString *tweetStr = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%%23iSurviUpdate&rpp=%i",UpdateResult] ;
    NSString *tweetStr = [NSString stringWithFormat:@"http://search.twitter.com/search.json?q=%%40%@&rpp=%i",hostLiveData,UpdateResult] ;
    NSLog(@"tweetStr : %@",tweetStr);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* dataAll = [NSData dataWithContentsOfURL:[NSURL URLWithString: tweetAllStr]];
        
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:tweetStr]];
        
        NSError* error;
        //NSLog(@"Pull Down Refresh.");
        @try {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            //ถ้าดึง tweet จากหน้า user ไม่ต้องใช้ NSDictionary
            //tweets = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            NSDictionary *jsonResultsAll = [NSJSONSerialization JSONObjectWithData:dataAll options:kNilOptions error:&error];
            tweetsAll = [jsonResultsAll objectForKey:@"results"];
            NSDictionary *jsonResults = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
            tweets = [jsonResults objectForKey:@"results"];
            
            NSLog(@"tweetsAll : %i",tweetsAll.count);
            NSLog(@"tweets : %i",tweets.count);
        }
        @catch ( NSException *e ) {
            NSLog(@"Catch.");
        }
        @finally {
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.tableView reloadData];
            [self refreshNewCell];
            [self saveUpdateCount];
        });
        
    });
}
-(void)refreshNewCell
{
    /*
     UITableViewRowAnimationFade,
     UITableViewRowAnimationRight,
     UITableViewRowAnimationLeft,
     UITableViewRowAnimationTop,
     UITableViewRowAnimationBottom,
     UITableViewRowAnimationNone,
     UITableViewRowAnimationMiddle
     */
    //โหลดข้อมูลใหม่ด้วย Animation
    [self.updateTableView beginUpdates];
    [self.updateTableView deleteSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.updateTableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    [self.updateTableView endUpdates];
    //โหลดข้อมูลใหม่ธรรมดา
    //[self.updateTableView reloadData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellUpdate"; // set in storyboard attributes too
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    bgimage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bgCell.png"] ];
    cell.backgroundView = bgimage;
    [cell setSelectedBackgroundView:bgSelected];
    
    NSDictionary *tweet = [tweets objectAtIndex:indexPath.row];
    //NSString *idStr = [tweet objectForKey:@"id_str"];
    //NSLog(@"urls : %@",idStr);
    NSString *text = [tweet objectForKey:@"text"];
    //NSString *name = [[tweet objectForKey:@"user"] objectForKey:@"name"];
    NSString *name = [tweet objectForKey:@"from_user_name"];
    NSString *date = [tweet objectForKey:@"created_at"];
    //NSString *name = [[[tweet objectForKey:@"results"] objectForKey:@"from_user"] objectForKey:@"from_user_name"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ : %@",name,date];
    cell.detailTextLabel.text = text;
    
    [cell.textLabel setBackgroundColor:[UIColor clearColor]];
    [cell.detailTextLabel setBackgroundColor:[UIColor clearColor]];
    
    //NSString *imageUrl = [[tweet objectForKey:@"user"] objectForKey:@"profile_image_url"];
    //NSString *imageUrl = [tweet objectForKey:@"profile_image_url"];
    //NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
    //cell.imageView.image = [UIImage imageWithData:data];
    
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowGray.png"]];
    //[cell.contentView addSubview:updateLabel];
    //[cell.contentView addSubview:updateDetail];
    [activity stopAnimating];
    loadText.text = @"";

    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setAndShowUpdate];
}
- (void)setAndShowUpdate
{
    //self.typeMode = _typeMode;
    //segue
    [self performSegueWithIdentifier:@"ShowUpdate" sender:self];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowUpdate"]) { //
        
        NSInteger row = [[self tableView].indexPathForSelectedRow row];
        NSDictionary *tweet = [tweets objectAtIndex:row];
        
        ShowUpdateViewController *showUpdateViewController = segue.destinationViewController;
        //showUpdateViewController.detailUpdate = [tweet objectForKey:@"text"] ;
        NSString *fromUser = [tweet objectForKey:@"from_user"];
        NSString *idStr = [tweet objectForKey:@"id_str"];
        NSString *urlStr = [NSString stringWithFormat:@"https://twitter.com/%@/status/%@",fromUser,idStr];
        showUpdateViewController.userUpdate = fromUser;
        showUpdateViewController.detailUpdate = [tweet objectForKey:@"text"] ;
        showUpdateViewController.urlUpdate = urlStr;
        showUpdateViewController.hostLive = hostLiveData;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
- (void)viewDidUnload {
    [self setUpdateTableView:nil];
    [super viewDidUnload];
}
@end
