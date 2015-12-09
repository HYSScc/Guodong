//
//  QuestionComment.m
//  果动
//
//  Created by mac on 15/5/21.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "QuestionComment.h"

@implementation QuestionComment
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    
       if (self = [super init])
    {
        self.question = [dictionary objectForKey:@"question"];
        self.ID = [dictionary objectForKey:@"id"];
        NSLog(@"self.ID  %@",self.ID);
    }
    return self;
}

@end
