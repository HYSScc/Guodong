//
//  CLComment.m
//  果动
//
//  Created by mac on 15/3/11.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "CLComment.h"

@implementation CLComment



-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        
       
        
        self.func_id = [dictionary objectForKey:@"func_id"];
        self.name = [dictionary objectForKey:@"name"];
        self.rmb = [dictionary objectForKey:@"rmb"];
       
       
       
    }
    return self;
}

@end
