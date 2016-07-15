//
//  MyDairyModel.m
//  果动
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MyDairyModel.h"

@implementation MyDairyModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[dict objectForKey:@"time"] intValue]];
        
        _date         = [formatter stringFromDate:confromTimesp];
        _dairy_id     = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _coachContent = [NSString stringWithFormat:@"果动: %@",[dict objectForKey:@"coach_content"]];
        _title        = [dict objectForKey:@"title"];
        if (![[dict objectForKey:@"user_content"] isKindOfClass:[NSNull class]]) {
            _userContent = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user_content"]];
        } else {
            _userContent = @"";
        }
        
        _photoArray   = [dict objectForKey:@"photo_list"];
        
    }
    return self;
}


@end
