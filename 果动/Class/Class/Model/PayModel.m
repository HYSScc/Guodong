//
//  PayModel.m
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "PayModel.h"

@implementation PayModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        _remark = [dict objectForKey:@"publicity_code"];
        _price  = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
        _classNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"number"]];
        _package_id  = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
    }
    return self;
}

@end
