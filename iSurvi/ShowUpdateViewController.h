//
//  ShowUpdateViewController.h
//  iSurvi
//
//  Created by Songwut on 1/24/13.
//  Copyright (c) 2013 Songwut. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>

@interface ShowUpdateViewController : UIViewController <UIWebViewDelegate>
{
    UIButton *socialBtn;
    UIImage *imageSocial;
    NSURL *urlNow;
}
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *preload;
@property (weak, nonatomic) IBOutlet UIWebView *updateWebView;
@property (strong, nonatomic) id detailUpdate;
@property (strong, nonatomic) NSString *userUpdate;
@property (strong, nonatomic) NSString *urlUpdate;
@property (strong, nonatomic) NSString *hostLive;

@end
