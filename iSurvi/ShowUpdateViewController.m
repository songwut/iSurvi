//
//  ShowUpdateViewController.m
//  iSurvi
//
//  Created by Songwut on 1/24/13.
//  Copyright (c) 2013 Songwut. All rights reserved.
//

#import "ShowUpdateViewController.h"


@interface ShowUpdateViewController ()

@end

@implementation ShowUpdateViewController

@synthesize detailUpdate = _detailUpdate;
@synthesize urlUpdate = _urlUpdate;
@synthesize userUpdate = _userUpdate;
@synthesize hostLive = _hostLive;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)postFB
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        SLComposeViewController *facebook = [[SLComposeViewController alloc] init];
        facebook = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebook setInitialText:[NSString stringWithFormat:@"@%@ : %@",_hostLive,_detailUpdate]];
        [self presentViewController:facebook animated:YES completion:nil];
    }
}
-(void)postTW
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        SLComposeViewController *twitter = [[SLComposeViewController alloc] init];
        twitter = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [twitter setInitialText:[NSString stringWithFormat:@"@%@ @%@ ",_hostLive,_userUpdate]];
        [self presentViewController:twitter animated:YES completion:nil];
        
    }
}
- (void)socialBtnPressed
{
    [self postTW];
}
- (UIBarButtonItem *) getSocialBtn
{
    
    socialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageSocial = [UIImage imageNamed:@"iconMention.png"];
    [socialBtn setImage:imageSocial forState:UIControlStateNormal];
    [socialBtn setFrame:CGRectMake(0.0f,0.0f,imageSocial.size.width, imageSocial.size.height)];
    [socialBtn addTarget:self action:@selector(socialBtnPressed) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *searchBarButton = [[UIBarButtonItem alloc] initWithCustomView:socialBtn];
    
    return searchBarButton;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //กำหนดปุ่ม ด้านซ้ายเป็นปุ่มแบบ custom
    self.navigationItem.leftBarButtonItem = [self getBackBtn];
    //self.navigationItem.rightBarButtonItem = [self getSocialBtn];
    //============================================================
    // self.navigationItem.title = @"Test";
    // ; leftBarButtonItem.title = @"TestAgain";
    NSURL *urlFromList = [NSURL URLWithString: _urlUpdate];
    NSURLRequest *requestUrl = [NSURLRequest requestWithURL: urlFromList];
    [self.updateWebView loadRequest: requestUrl];
}
-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.preload startAnimating];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.preload stopAnimating];
    self.preload.hidden = true;
    urlNow = self.updateWebView.request.mainDocumentURL;
}
- (void)viewDidUnload
{
    [self setUpdateWebView:nil];
    [self setPreload:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
