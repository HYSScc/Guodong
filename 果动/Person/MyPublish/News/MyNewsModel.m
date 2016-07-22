//
//  MyNewsModel.m
//  果动
//
//  Created by mac on 16/6/23.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MyNewsModel.h"

@implementation MyNewsModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        _headimgUrl = [dict objectForKey:@"headimg"];
        _nickName   = [dict objectForKey:@"nickname"];
        _date       = [dict objectForKey:@"friendtime"];
        _content    = [dict objectForKey:@"content"];
        _photoUrl   = [[dict objectForKey:@"img"][0] objectForKey:@"url"];
        
        _height     = [[[dict objectForKey:@"img"][0] objectForKey:@"height"] intValue];
        _widht      = [[[dict objectForKey:@"img"][0] objectForKey:@"width"] intValue];
        _ipraises   = [ NSString stringWithFormat:@"%@",[dict objectForKey:@"ipraises"]];
        _praises    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"praises"]];
        _comments   = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comments"]];
        
        _talk_id    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"talkid"]];
        
    }
    return self;
}


@end
