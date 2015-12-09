//
//  appointViewController.h
//  私练
//
//  Created by z on 15/1/27.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface appointViewController : UIViewController


@property (nonatomic,retain)NSString *func_id;
@property (nonatomic,retain)NSString *rmb;
@property (nonatomic,retain)NSString *class_id;
@property (nonatomic,retain)NSString *ishave;
@property (nonatomic,retain)NSString *total;
@property (nonatomic,assign)int type;
@property (nonatomic,retain)NSString *isVIP;
@property (nonatomic,retain)NSString *isFirst;
@property (nonatomic,retain)NSString *discont;
@property (nonatomic,retain)NSString *course_time;
@property (nonatomic,assign)int personNumber;
@property (nonatomic,retain)NSMutableArray *course;
@property (nonatomic,retain)NSString *youhuijuan;
@property (nonatomic,retain)NSString *alertString;
@property (nonatomic,retain)NSString *userinfo_name;
@property (nonatomic,retain)NSString *userinfo_number;
@property (nonatomic,retain)NSString *userinfo_address;
@property (nonatomic,retain) NSArray *dateArray;
@property (nonatomic,retain)NSString *vip_cards;
@end
