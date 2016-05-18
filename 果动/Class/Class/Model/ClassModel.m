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
        
        self.class_id   = [dict objectForKey:@"class_id"] ?
        [dict objectForKey:@"class_id"] : NULL;
        
        self.class_name = [dict objectForKey:@"name"] ?
        [dict objectForKey:@"name"]: NULL;
        
        self.class_number = [dict objectForKey:@"num"] ?
        [dict objectForKey:@"num"] : NULL;
        
        self.class_imageUrl = [dict objectForKey:@"imgUrl"] ?
        [dict objectForKey:@"imgUrl"] :
        NULL;
        
        
        
    }
    return self;
}

@end
