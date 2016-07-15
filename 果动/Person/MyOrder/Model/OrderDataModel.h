//
//  OrderDataModel.h
//  果动
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderDataModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *courseNumber;
@property (nonatomic,retain) NSString *classOrPachage;
@property (nonatomic,retain) NSString *order_id;
@property (nonatomic,retain) NSString *photoNumber;
@property (nonatomic,retain) NSString *pre_time;
@property (nonatomic,retain) NSString *courseName;
@property (nonatomic,retain) NSString *course_status;
@property (nonatomic,retain) NSString *statusName;
@property (nonatomic,retain) NSString *userName;
@property (nonatomic,retain) NSString *userPlace;
@property (nonatomic,retain) NSString *course_type;
@property (nonatomic,retain) NSString *class_id;
@property (nonatomic,retain) NSString *pre_time_area;

@property (nonatomic,retain) NSString *coachName;
@property (nonatomic,retain) NSString *coachSex;
@property (nonatomic,retain) NSString *coachHeadImgUrl;
@property (nonatomic,retain) NSDictionary *coach_info;

@property (nonatomic,retain) NSString *package_content;
@property (nonatomic,retain) NSString *package_name;
@property (nonatomic,retain) NSString *reward;
@property (nonatomic,retain) NSString *pay_amount;
@property (nonatomic,retain) NSString *pay_status;

@end
