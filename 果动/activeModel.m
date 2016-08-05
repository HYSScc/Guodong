//
//  activeModel.m
//  果动
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "activeModel.h"

@implementation activeModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        _img  = [dict objectForKey:@"img"];
        _url  = [dict objectForKey:@"url"];
        _name = [dict objectForKey:@"name"];
        _type = [[dict objectForKey:@"type"] intValue];
        
    }
    return self;
}


@end
