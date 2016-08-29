//
//  addMessageModel.m
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "addMessageModel.h"
#import "addMessageCourse.h"

@implementation addMessageModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        
        
        _topImageUrl    = [[dict objectForKey:@"banner"] objectForKey:@"imgurl"];
        _topImageHeight = [[[dict objectForKey:@"banner"] objectForKey:@"height"] intValue];
      
        
        _timeArray  = [dict objectForKey:@"pre_times"];
        
        if ([[dict objectForKey:@"icon"] count] != 0)
        {
            NSDictionary *iconDict = [dict objectForKey:@"icon"][0];
            _iconImageUrl = [iconDict objectForKey:@"icon"];
            _iconHeight   = [[iconDict objectForKey:@"height"] intValue];
            _iconWidth    = [[iconDict objectForKey:@"width"] intValue];
        }
        
        _package_balance = [NSString stringWithFormat:@"%@",[dict objectForKey:@"package_balance"]];
        
        _isHaveFree      = [dict objectForKey:@"freecourse"];
        
        _courseArray     = [NSMutableArray array];
       
        NSArray *courseArray = [dict objectForKey:@"course"];
        
        for (NSDictionary *dict in courseArray) {
            addMessageCourse *course = [[addMessageCourse alloc] initWithDictionary:dict];
            [_courseArray addObject:course];
        }
       
        NSDictionary *rechargeDict = [dict objectForKey:@"recharge_img"];
        _rechargeUrl    = [rechargeDict objectForKey:@"img"];
        _rechargeWidth  = [NSString stringWithFormat:@"%@",[rechargeDict objectForKey:@"width"]];
        _rechargeHeight = [NSString stringWithFormat:@"%@",[rechargeDict objectForKey:@"height"]];
        
        
        NSDictionary *userDict = [dict objectForKey:@"userInfo"];
        _user_name             = [userDict objectForKey:@"name"];
        _user_phone            = [userDict objectForKey:@"phone"];
        _user_address          = [userDict objectForKey:@"address"];
        
        
        _packageArray = [dict objectForKey:@"package"];
        
        _user_money    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"money"]];
        _user_balance = [NSString stringWithFormat:@"%@",[dict objectForKey:@"balance"]];
        _limit_time    = [[dict objectForKey:@"limit_time"] intValue] * 3600;
        
    }
    return self;
}

@end
