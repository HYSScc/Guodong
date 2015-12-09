//
//  MingXiComment.m
//  果动
//
//  Created by mac on 15/6/15.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "MingXiComment.h"

@implementation MingXiComment
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.money = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"money"]];
         self.code = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"code"]];
         self.types = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"types"]];
         self.time = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"time"]];
        
        
        
       
    }
    return self;
}

@end
