//
//  OrderDataModel.m
//  果动
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "OrderDataModel.h"

@implementation OrderDataModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
     
         _classOrPachage = [dict objectForKey:@"type"];          // 单次课还是套餐
        
        if ([_classOrPachage isEqualToString:@"gdcourse"]) {
            
            _courseNumber   = [dict objectForKey:@"course_status"]; // 第几节课
            _order_id       = [dict objectForKey:@"order_id"];
            _photoNumber    = [dict objectForKey:@"number"];
            _pre_time       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pre_time"]];      // 订课时间
            _courseName     = [dict objectForKey:@"course"];
            _course_status  = [NSString stringWithFormat:@"%@",[dict objectForKey:@"gd_status"]];
            _statusName     = [dict objectForKey:@"order_status"]; // 订单的状态 （已完成、、）
            _userName       = [dict objectForKey:@"name"];
            _userPlace      = [dict objectForKey:@"place"];
            _course_type    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"course_type"]];
            _class_id       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"class_id"]];
            _pre_time_area  = [dict objectForKey:@"pre_time_area"];
            
            
            _coach_info = [dict objectForKey:@"coach_info"];
            if ([_coach_info count] != 0) {
                
                _coachName = [_coach_info objectForKey:@"username"];
                
                if ([[_coach_info objectForKey:@"gender"] intValue] == 1) {
                    _coachSex = @"男";
                } else {
                    _coachSex = @"女";
                }
                
                _coachHeadImgUrl = [_coach_info objectForKey:@"headimg"];
            }

        } else {
            
            // 套餐详情介绍副券
            _pay_amount   = [NSString stringWithFormat:@"%@",[dict objectForKey:@"pay_amount"]];
            _package_name = [dict objectForKey:@"package_name"];
            _package_content = [dict objectForKey:@"package_content"];
            _reward       = [dict objectForKey:@"reward"];
            _pay_status   = [dict objectForKey:@"pay_status"];
            
        }
        
        
        
        
        
        
    }
    return self;
}

@end
