//
//  exerciseComment.m
//  果动
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "exerciseComment.h"

@implementation exerciseComment
- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {

        self.coach = [dictionary objectForKey:@"coach"];
        self.time = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"time"]];
        self.ID = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"id"]];
        self.isview = [NSString stringWithFormat:@"%@", [dictionary objectForKey:@"isview"]];
    }
    return self;
}

@end
