//
//  addMessageCourse.m
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "addMessageCourse.h"

@implementation addMessageCourse
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _func_id       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"func_id"]];
        _oneClassPrice = [NSString stringWithFormat:@"%@",[dict objectForKey:@"rmb"]];
        _oneClassTime  = [NSString stringWithFormat:@"%@",[dict objectForKey:@"course_time"]];
        _name          = [dict objectForKey:@"name"];
        _class_id      = [NSString stringWithFormat:@"%@",[dict objectForKey:@"class_id"]];
    }
    return self;
}

@end
