//
//  IntroduceComment.m
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "IntroduceComment.h"

@implementation IntroduceComment
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _headimg  = [dict objectForKey:@"headimg"];
        _nickName = [dict objectForKey:@"nickname"];
        _content  = [dict objectForKey:@"content"];
    }
    return self;
}

@end
