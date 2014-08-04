//
//  Fav.h
//  iSurvi
//
//  Created by Songwut on 1/15/13.
//  Copyright (c) 2013 Songwut. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Fav : NSManagedObject

@property (nonatomic, retain) NSNumber * backpack;
@property (nonatomic, retain) NSNumber * carpack;
@property (nonatomic, retain) NSNumber * itemID;
@property (nonatomic, retain) NSNumber * favStatus;
@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSNumber * minipack;
@property (nonatomic, retain) NSString * notice;
@property (nonatomic, retain) NSString * shop;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * use;

@end
