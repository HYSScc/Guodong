//
//  HomeModel.m
//  果动
//
//  Created by mac on 16/5/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "HomeModel.h"
#import "ClassModel.h"
@implementation HomeModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.bannerArray    = [dict objectForKey:@"banner"] ? [dict objectForKey:@"banner"] :
        NULL;
        self.coach_imgArray = [dict objectForKey:@"coach_img"] ? [dict objectForKey:@"coach_img"] :
        NULL;
        
        if ([dict objectForKey:@"course"]) {
            
            self.classArray = [NSMutableArray array];
            
            for (NSDictionary *diction in [dict objectForKey:@"course"]) {
                ClassModel *classModel = [[ClassModel alloc] initWithDictionary:diction];
                [self.classArray addObject:classModel];
            }
            NSLog(@"解析 %@",self.classArray);
        }
        
        
        
        
    }
    return self;
}

@end
