//
//  Studio.m
//  果动
//
//  Created by mac on 15/4/27.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "Studio.h"

@implementation Studio
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        
        self.place = [dictionary objectForKey:@"place"];
        self.ID = [dictionary objectForKey:@"id"];
        
      
        
        //  NSLog(@"self.time   %@",self.time);
    }
    return self;
}
@end
