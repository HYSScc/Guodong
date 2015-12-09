//
//  Message.m
//  果动
//
//  Created by mac on 15/9/24.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "Message.h"

@implementation Message
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        
        self.name = [dictionary objectForKey:@"name"];
        self.func_id = [dictionary objectForKey:@"func_id"];
        self.rmb = [dictionary objectForKey:@"rmb"];
        self.course_time = [dictionary objectForKey:@"course_time"];
    }
    return self;
}

@end
