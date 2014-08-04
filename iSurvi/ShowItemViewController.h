//
//  ShowItemViewController.h
//  iSurvi
//
//  Created by Songwut on 12/28/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemsOBJ.h"
#import "iAd/iAd.h"


@interface ShowItemViewController : UIViewController <ADBannerViewDelegate>
{
    
    float sizeOfIconShow;
    UIImage *imageSocial;
    UIButton *socialBtn;
    UIView *lightView;
    float screenW;
    UIImage *iconImage;
    
    //UILabel *noticeLabel;
    UITextView *noticeTextView;
    
    NSArray *favList;
    BOOL favCheck;
    
    UIImage *imageFav;
    UIButton *favBtn;
    NSInteger favPlus;
    
    NSNumber * backpackSub;
    NSNumber * carpackSub;
    NSString * iconSub;
    NSNumber * itemIDSub;
    NSString * itemNameSub;
    NSNumber * minipackSub;
    NSString * noticeSub;
    NSString * shopSub;
    NSNumber * typeSub;
    NSString * useSub;

}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UILabel *showUse;
@property (weak, nonatomic) IBOutlet UIImageView *showicon;
@property (weak, nonatomic) IBOutlet UILabel *showShop;
@property (weak, nonatomic) IBOutlet UIView *bgContentVeiw;
@property (nonatomic, strong) ItemsObj *itemsObj;

@end
