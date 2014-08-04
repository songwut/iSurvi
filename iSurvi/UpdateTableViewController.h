//
//  UpdateTableViewController.h
//  iSurvi
//
//  Created by Songwut on 1/24/13.
//  Copyright (c) 2013 Songwut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iAd/iAd.h"

@interface UpdateTableViewController : UITableViewController <ADBannerViewDelegate>
{
    UIButton *socialBtn;
    UIImage *imageSocial;
    
    int UpdateResult;
    CGRect adRect;
    ADBannerView *adView;
    
    NSString *hostLiveData;
    NSMutableArray *tweets;
    NSMutableArray *tweetsAll;
    BOOL isDragging;
    BOOL isLoading;
    NSString *textLoading;
    
    UIColor *addBgTable;
    UIView *bgSelected;
    UIImageView *bgimage;
    
    UILabel *updateLabel;
    UILabel *updateDetail;
    UINavigationController *navigationBar;
    UIActivityIndicatorView *activity;
    NSString *refreshMsg;
    UILabel *loadText;
}

@property (nonatomic, retain) NSURLConnection *connection;
@property (strong, nonatomic) IBOutlet UITableView *updateTableView;
@property (nonatomic, strong) UIView *refreshHeader;
@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) UILabel *topLabel;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, copy) NSString *textLoading;
@property (nonatomic, strong) NSString *mainStr;
- (void)refresh;
- (void)fetchTweets;
@end
