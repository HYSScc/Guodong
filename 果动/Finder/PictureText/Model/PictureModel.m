//
//  PictureModel.m
//  果动
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        _imageString = [dict objectForKey:@"img"] ? [dict objectForKey:@"img"] : @"";
        _title = [dict objectForKey:@"title"] ? [dict objectForKey:@"title"] : NULL;
        _content_id = [dict objectForKey:@"id"] ? [dict objectForKey:@"id"] : NULL;
        _content = [dict objectForKey:@"intro"] ? [dict objectForKey:@"intro"] : NULL;
        
        
        
    }
    return self;
}

@end
