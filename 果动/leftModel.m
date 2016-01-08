//
//  leftModel.m
//  果动
//
//  Created by mac on 16/1/5.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "leftModel.h"

@implementation leftModel
- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.left_id = [dictionary objectForKey:@"class_id"];
        self.left_num = [dictionary objectForKey:@"num"];
        self.left_name = [dictionary objectForKey:@"name"];
        self.left_image = [dictionary objectForKey:@"imgUrl"];
        self.status = [[dictionary objectForKey:@"status"] intValue];
    }
    return self;
}
@end
