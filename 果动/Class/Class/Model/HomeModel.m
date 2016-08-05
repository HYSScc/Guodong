//
//  HomeModel.m
//  果动
//
//  Created by mac on 16/5/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "HomeModel.h"
#import "activeModel.h"
#import "ClassModel.h"
@implementation HomeModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        self.bannerArray = [NSMutableArray array];
        self.activeArray = [NSMutableArray array];
        
        if ([[dict allKeys] containsObject:@"carousel"]) {
            NSMutableArray *carouselArray = [dict objectForKey:@"carousel"];
            
            for (NSDictionary *dict in carouselArray) {
                
                
                activeModel  *active = [[activeModel alloc] initWithDictionary:dict];
                [self.activeArray addObject:active];
                
                
                [self.bannerArray addObject:[dict objectForKey:@"img"]];
               // [self.activeArray addObject:[dict objectForKey:@"url"]];
            }
        }
        
       
      //  self.bannerArray = [dict objectForKey:@"banner"];
        
        
        
       
        self.coach_imgArray = [dict objectForKey:@"coach_img"] ? [dict objectForKey:@"coach_img"] :
        NULL;
        
        
        _rechargeImg = [[dict objectForKey:@"charge_info"] objectForKey:@"img"];
        
        if ([dict objectForKey:@"course"]) {
            
            self.classArray = [NSMutableArray array];
            
            for (NSDictionary *diction in [dict objectForKey:@"course"]) {
                ClassModel *classModel = [[ClassModel alloc] initWithDictionary:diction];
                [self.classArray addObject:classModel];
            }
        }
        
        
        
        
    }
    return self;
}

@end
