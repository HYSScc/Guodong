//
//  ContentModel.m
//  果动
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ContentModel.h"

@implementation ContentModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.isPraise   =[NSString stringWithFormat:@"%@",[dict objectForKey:@"ipraises"]] ;
        
        
        self.headImgUrl = [dict objectForKey:@"headimg"] ? [dict objectForKey:@"headimg"] : NULL;
        self.nameString = [dict objectForKey:@"nickname"] ? [dict objectForKey:@"nickname"] : NULL;
        
        self.dateString = [dict objectForKey:@"friendtime"] ? [dict objectForKey:@"friendtime"] : NULL;
        self.contentString = [dict objectForKey:@"content"] ? [dict objectForKey:@"content"] : NULL;
        self.conetntImgArray = [dict objectForKey:@"photos"] ? [dict objectForKey:@"photos"] : NULL;
         self.likeNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"praises"]] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"praises"]] : NULL;
         self.commentNumber = [NSString stringWithFormat:@"%@",[dict objectForKey:@"comments"]] ? [NSString stringWithFormat:@"%@",[dict objectForKey:@"comments"]] : NULL;
        self.tail_id = [dict objectForKey:@"talkid"];
    }
    return self;
}


@end
