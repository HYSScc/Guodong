//
//  MainController.h
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainController : UIViewController
@property (nonatomic,retain)NSString *citys;
@property (nonatomic,retain)NSString *order_id,*type;
@property (nonatomic,copy)void(^block)(void);
@property (nonatomic,retain)NSString *status,*elseStr;
@property (nonatomic,retain)NSMutableArray *scrimgArray;
@property (nonatomic,retain)NSString *vip;
@property (nonatomic,retain)NSString *address;
@end
