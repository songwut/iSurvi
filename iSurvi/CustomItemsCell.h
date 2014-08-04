//
//  typeCell.h
//  iSurvi
//
//  Created by Songwut on 12/17/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomItemsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconBlank;

@property (weak, nonatomic) IBOutlet UIImageView *imgCell;
@property (weak, nonatomic) IBOutlet UILabel *labelCell;

@property (weak, nonatomic) IBOutlet UILabel *detailCell;
@property (weak, nonatomic) IBOutlet UIButton *favBTN;

@end
