//
//  InroduceModel.m
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "InroduceModel.h"
#import "IntroduceComment.h"

@implementation InroduceModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
       
        _introduce    = [dict objectForKey:@"inc"];
        _price        = [NSString stringWithFormat:@"%@",[dict objectForKey:@"price"]];
        _courseNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"courseTotal"]];
        _coments_num  = [NSString stringWithFormat:@"%@",[[dict objectForKey:@"comments"] objectForKey:@"comments_num"]];
        
        if ([[dict objectForKey:@"course_icon"] count] != 0) {
            NSDictionary *iconDict = [dict objectForKey:@"course_icon"][0];
            _iconImageURL = [iconDict objectForKey:@"icon"];
            _iconWidth    = [[iconDict objectForKey:@"width"] intValue];
            _iconHeight   = [[iconDict objectForKey:@"height"] intValue];
        }
        _imageArray  = [dict objectForKey:@"imgUrl"];
        _course_time = [dict objectForKey:@"course_time"];
     
        _commentArray = [NSMutableArray array];
        NSArray *feed_listArray = [[dict objectForKey:@"comments"] objectForKey:@"feed_list"];
        for (NSDictionary *dict  in feed_listArray) {
            IntroduceComment *comment = [[IntroduceComment alloc] initWithDictionary:dict];
            [_commentArray addObject:comment];
            
        }
        
}
    return self;
}

@end
