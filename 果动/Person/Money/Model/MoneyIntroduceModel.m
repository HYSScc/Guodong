//
//  MoneyIntroduceModel.m
//  果动
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MoneyIntroduceModel.h"

@implementation MoneyIntroduceModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _title   = [dict objectForKey:@"title"];
        _content = [dict objectForKey:@"content"];
    }
    return self;
}

@end
