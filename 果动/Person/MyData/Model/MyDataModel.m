//
//  MyDataModel.m
//  果动
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MyDataModel.h"

@implementation MyDataModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"time"] intValue]];
        _time = [formatter stringFromDate:confromTimesp];
        
        
        _leftImageUrl = [[dict allKeys] containsObject:@"after"] ? [dict objectForKey:@"after"] : @"";
        _rightImageUrl = [[dict allKeys] containsObject:@"before"] ? [dict objectForKey:@"before"] : @"";
        
        _height     = [NSString stringWithFormat:@"%@",[dict objectForKey:@"height"]];
        _weight     = [NSString stringWithFormat:@"%@",[dict objectForKey:@"weight"]];
        _waistline  = [NSString stringWithFormat:@"%@",[dict objectForKey:@"waistline"]];
        _hip        = [NSString stringWithFormat:@"%@",[dict objectForKey:@"hip"]];
        _rcrus      = [NSString stringWithFormat:@"%@",[dict objectForKey:@"rcrus"]];
        _lcrus      = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lcrus"]];
        _rham       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"rham"]];
        _lham       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"lham"]];
        _rtar       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"rtar"]];
        _ltar       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ltar"]];
        _rtaqj      = [NSString stringWithFormat:@"%@",[dict objectForKey:@"rtaqj"]];
        _ltaqj      = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ltaqj"]];
        _bust_relax = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bust_relax"]];
        _bust_exp   = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bust_exp"]];
        _gstj       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"gstj"]];
        _jjxy       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"jjxy"]];
        _kjsy       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"kjsy"]];
        _abdomen    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"abdomen"]];
        _fat_ham    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fat_ham"]];
        _total      = [NSString stringWithFormat:@"%@",[dict objectForKey:@"total"]];
        _fat        = [NSString stringWithFormat:@"%@",[dict objectForKey:@"fat"]];
        _ytbl       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ytbl"]];
        _bmi        = [NSString stringWithFormat:@"%@",[dict objectForKey:@"bmi"]];
        _static_heart_rate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"static_heart_rate"]];
        _blood_pressure    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"blood_pressure"]];
        _target_heart_rate = [NSString stringWithFormat:@"%@",[dict objectForKey:@"target_heart_rate"]];
    }
    return self;
}

@end
