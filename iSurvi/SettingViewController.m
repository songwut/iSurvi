//
//  FirstViewController.m
//  iSurvi
//
//  Created by Songwut on 12/16/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import "SettingViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingViewController ()

@end

@implementation SettingViewController
- (IBAction)goToWeb:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://isurvi.com"]];
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
- (void)viewDidLoad
{
    [super viewDidLoad];
    customNavBar
    customTabBar
    [self shadowOfNavBar];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgDK.png"]];
    
    addBgTable = [UIColor clearColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
