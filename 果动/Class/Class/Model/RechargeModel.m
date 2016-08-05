//
//  RechargeModel.m
//  果动
//
//  Created by mac on 16/7/6.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "RechargeModel.h"

@implementation RechargeModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        _titleName   = [dict objectForKey:@"name"];
        _price       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
        _classNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"number"]];
        _type_id     = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        
    }
    return self;
}

@end
