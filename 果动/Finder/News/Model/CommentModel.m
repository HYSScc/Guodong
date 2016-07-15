//
//  CommentModel.m
//  果动
//
//  Created by mac on 16/5/24.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "CommentModel.h"
#import "NewsDetailsReply.h"
@implementation CommentModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        _headImgString = [dict objectForKey:@"headimg"];
        _nickName      = [dict objectForKey:@"nickname"];
        _dateString    = [dict objectForKey:@"friendtime"];
        _contentString = [dict objectForKey:@"info"];
        _comment_id    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"id"]];
        _replyArray    = [NSMutableArray array];
        _user_id       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
        
        for (NSDictionary *replyDict in [dict objectForKey:@"replay_list"]) {
            NewsDetailsReply *reply = [[NewsDetailsReply alloc] initWithDictionary:replyDict];
            [_replyArray addObject:reply];
            
        }
        
    }
    return self;
}


@end
