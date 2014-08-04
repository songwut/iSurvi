//
//  typeCell.m
//  iSurvi
//
//  Created by Songwut on 12/17/12.
//  Copyright (c) 2012 Songwut. All rights reserved.
//
/*
 // Label
 typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(62, 5, 230, 21)];
 typeLabel.font = [UIFont fontWithName:@"Arial" size:17];
 typeLabel.backgroundColor = [UIColor clearColor];
 typeLabel.textColor = [UIColor whiteColor];
 typeLabel.shadowColor = [UIColor blackColor];
 typeLabel.shadowOffset = CGSizeMake(2, 1);
 [typeLabel setAutoresizesSubviews:YES];
 [typeLabel setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
 
 // Detail
 typeDetail =[[UILabel alloc] initWithFrame:CGRectMake(62, 20, 230, 27)];
 typeDetail.numberOfLines = 2;
 typeDetail.font = [UIFont fontWithName:@"Arial" size:11.5 ];
 typeDetail.backgroundColor = [UIColor clearColor];
 typeDetail.textColor = [UIColor whiteColor];
 [typeDetail setAutoresizesSubviews:YES];
 [typeDetail setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
 UIViewAutoresizingFlexibleHeight];
 */
#import "CustomItemsCell.h"

@implementation CustomItemsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [_labelCell setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
         UIViewAutoresizingFlexibleHeight];
        [_detailCell setAutoresizingMask:UIViewAutoresizingFlexibleWidth |
         UIViewAutoresizingFlexibleHeight];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
