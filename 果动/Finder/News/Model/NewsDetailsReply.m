//
//  NewsDetailsReply.m
//  果动
//
//  Created by mac on 16/6/8.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "NewsDetailsReply.h"

@implementation NewsDetailsReply
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _content    = [dict objectForKey:@"content"];
        _timeString = [dict objectForKey:@"friendtime"];
        _sourceName = [[dict objectForKey:@"source_user"] objectForKey:@"nickname"];
        _sourceHeadImg = [[dict objectForKey:@"source_user"] objectForKey:@"headimg"];
        _targetName    = [[dict objectForKey:@"target_user"] objectForKey:@"nickname"];
        _reply_id      = [NSString stringWithFormat:@"%@",[dict objectForKey:@"replay_id"]];
        _user_id       = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"source_user"] objectForKey:@"uid"]];
    }
    return self;
}

@end
