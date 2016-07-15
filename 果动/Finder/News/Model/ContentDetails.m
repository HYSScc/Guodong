//
//  ContentDetails.m
//  果动
//
//  Created by mac on 16/6/8.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ContentDetails.h"

@implementation ContentDetails
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _isPraise      = [NSString stringWithFormat:@"%@",[dict objectForKey:@"ipraises"]];
        _headImgString = [dict objectForKey:@"headimg"];
        _nickName      = [dict objectForKey:@"nickname"];
        _timeString    = [dict objectForKey:@"friendtime"];
        _content       = [dict objectForKey:@"content"];
        _photoArray    = [dict objectForKey:@"img"];
        _likeNumber    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"praises"]];
        _commentNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comments"]];;
        _likeHeadImgArray = [dict objectForKey:@"praise_list"];
        _commentsArray = [dict objectForKey:@"comments_list"];
        _talk_id       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"talkid"]];
        _user_id       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"uid"]];
   
    }
    return self;
}

@end
