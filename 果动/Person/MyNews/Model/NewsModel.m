//
//  NewsModel.m
//  果动
//
//  Created by mac on 16/5/30.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.classString = [dict objectForKey:@"class"]   ? [dict objectForKey:@"class"] : NULL;
        self.title       = [dict objectForKey:@"title"]   ? [dict objectForKey:@"title"] : NULL;
        self.content     = [dict objectForKey:@"content"] ? [dict objectForKey:@"content"] : NULL;
        self.idString    = [dict objectForKey:@"id"]      ? [dict objectForKey:@"id"] : NULL;
        
        NSDictionary *other        = [dict objectForKey:@"other"];
        self.talkinfo              = [other objectForKey:@"talkinfo"] ? [other objectForKey:@"talkinfo"] : NULL;
        self.talkphotoString       = [other objectForKey:@"talkphoto"] ? [other objectForKey:@"talkphoto"] : NULL;
    }
    return self;
}

@end
