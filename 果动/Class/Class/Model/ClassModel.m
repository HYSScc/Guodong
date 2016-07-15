//
//  ClassModel.m
//  果动
//
//  Created by mac on 16/5/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ClassModel.h"

@implementation ClassModel
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.class_id   = ![[dict objectForKey:@"class_id"] isKindOfClass:[NSNull class]] ?
        [dict objectForKey:@"class_id"] : NULL;
        
        self.class_name = ![[dict objectForKey:@"name"] isKindOfClass:[NSNull class]] ?
        [dict objectForKey:@"name"]: NULL;
        
        self.class_number = ![[dict objectForKey:@"num"] isKindOfClass:[NSNull class]] ?
        [dict objectForKey:@"num"] : NULL;
        
        
       
        
        self.class_imageUrl = ![[dict objectForKey:@"imgUrl"] isKindOfClass:[NSNull class]]?
        [dict objectForKey:@"imgUrl"] : @"";
        
        
        
    }
    return self;
}

@end
