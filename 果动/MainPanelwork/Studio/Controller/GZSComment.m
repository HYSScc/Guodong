//
//  GZSComment.m
//  果动
//
//  Created by mac on 15/4/24.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "GZSComment.h"

@implementation GZSComment
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        
        
        
        self.func_id =   [dictionary objectForKey:@"func_id"];
        self.func_name = [dictionary objectForKey:@"func_name"];
        self.class_id =  [dictionary objectForKey:@"class_id"];
        self.rmb =       [dictionary objectForKey:@"rmb"];
        
        self.time = [dictionary objectForKey:@"time"];
        self.status = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"status"]];
        self.alert = [dictionary objectForKey:@"alert"];
        NSLog(@"self.rmb   %@   self.class_id  %@",self.rmb,self.class_id);
    }
    return self;
}
@end
