//
//  priceList.m
//  果动
//
//  Created by mac on 15/12/22.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "priceList.h"

@implementation priceList
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.price_classes_id = [dictionary objectForKey:@"classes_id"];
        self.price_id = [dictionary objectForKey:@"id"];
        self.price_num = [dictionary objectForKey:@"num"];
        self.price_name = [dictionary objectForKey:@"name"];
        self.price_rmb = [dictionary objectForKey:@"rmb"];
       
    }
    return self;
}

@end
