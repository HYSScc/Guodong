//
//  addCoachModel.m
//  果动
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "addCoachModel.h"

@implementation addCoachModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _coachImageName = [dict objectForKey:@"headimg"];
        _coachName      = [dict objectForKey: @"username"];
        _coach_id       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
        _has_course     = [[dict objectForKey:@"has_course"] boolValue];
    }
    return self;
}

@end
