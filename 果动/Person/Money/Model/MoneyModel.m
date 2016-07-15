//
//  MoneyModel.m
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MoneyModel.h"

@implementation MoneyModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
       
        _code  = [NSString stringWithFormat:@"%@",[dict objectForKey:@"code"]];
        _types = [dict objectForKey:@"types"];
        _money = [NSString stringWithFormat:@"￥%@",[dict objectForKey:@"money"]];
        _inc   = [dict objectForKey:@"inc"];
        _expires = [dict objectForKey:@"expires"];
        
        
    }
    return self;
}



@end
