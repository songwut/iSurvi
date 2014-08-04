//
//  ItemsObj.h
//  iSurvi
//
//  Created by Songwut on 1/4/13.
//  Copyright (c) 2013 Songwut. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsObj : NSObject
/*
 {
 NSNumber *itemID;
 NSString *itemName;
 NSString *icon;
 NSString *use;
 NSString *shop;
 NSString *notice;
 NSNumber *backpack;
 NSNumber *minipack;
 NSNumber *carpack;
 NSNumber *type;
 }
 */
@property (nonatomic) NSNumber *itemID;
@property (nonatomic, strong) NSString *itemName;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *use;
@property (nonatomic, strong) NSString *shop;
@property (nonatomic, strong) NSString *notice;
@property (nonatomic, strong) NSNumber *backpack;
@property (nonatomic, strong) NSNumber *minipack;
@property (nonatomic, strong) NSNumber *carpack;
@property (nonatomic, strong) NSNumber *type;
@end
