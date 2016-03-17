//
//  OrderComment.h
//  果动
//
//  Created by mac on 15/3/16.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderComment : NSObject
@property (nonatomic,retain)NSString *order_id;
@property (nonatomic,retain)NSString *pre_time;//订课时间
@property (nonatomic,retain)NSString *create_time;//下单时间
@property (nonatomic,retain)NSString *place;
@property (nonatomic,retain)NSString *course;//课程
@property (nonatomic,retain)NSString *status;//状态
@property (nonatomic,retain)NSString *gd_status;
@property (nonatomic,retain)NSString *number;//电话
@property (nonatomic,retain)NSString *coachName;
@property (nonatomic,retain)NSString *sex;
@property (nonatomic,retain)NSString *headimg;
@property (nonatomic,retain)NSString *coachClass;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSDictionary *coach_info;
@property (nonatomic,retain)NSString *cur;
@property (nonatomic,retain)NSString *total;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
