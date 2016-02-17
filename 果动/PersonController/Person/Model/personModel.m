//
//  personModel.m
//  果动
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "personModel.h"

@implementation personModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.backimg  = [dictionary objectForKey:@"backimg" ];
        self.headimg  = [dictionary objectForKey:@"headimg" ];
        self.nickname = [dictionary objectForKey:@"nickname"];
        self.gender   = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"gender"]];
        self.is_vip   = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"is_vip"]];
        self.isView   = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"isview"]];
       

    }
    return self;
}
/*
 data =     {
 backimg = "http://www.guodongwl.com:8065/img/pic_folder/user/100000102/backimg/5e51902659b7.jpg";
 gender = 1;
 headimg = "http://www.guodongwl.com:8065/img/pic_folder/user/100000102/headimg/1ae7bab34cf8.jpg";
 "is_vip" = 1;
 isview = 2;
 nickname = "\U9ece\U4ed5\U52c7";
 };
 */
@end
