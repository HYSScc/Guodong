//
//  OrderComment.m
//  果动
//
//  Created by mac on 15/3/16.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "OrderComment.h"

@implementation OrderComment

-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        NSLog(@"dict>>>>>>>>> %@",dictionary);
        
        self.coach_info = [dictionary objectForKey:@"coach_info"];
        self.order_id   = [dictionary objectForKey:@"order_id"];
        self.pre_time   = [dictionary objectForKey:@"pre_time"];
        self.create_time = [dictionary objectForKey:@"create_time"];
        self.place = [dictionary objectForKey:@"place"];
        self.course = [dictionary objectForKey:@"course"];
        self.status = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"order_status"]];
        self.gd_status = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"gd_status"]];
        self.number = [dictionary objectForKey:@"number"];
        
        self.coachName = [[dictionary objectForKey:@"coach_info"] objectForKey:@"username"];
        self.sex = [NSString stringWithFormat:@"%@",[[dictionary objectForKey:@"coach_info"] objectForKey:@"gender"]];
        NSLog(@"SEX  %@",self.sex);
        self.coachClass = [[dictionary objectForKey:@"coach_info"] objectForKey:@"coachCourse"];
        self.headimg = [[dictionary objectForKey:@"coach_info"] objectForKey:@"headimg"];
        self.cur     = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"cur"]];
        self.total     = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"total"]];
        NSLog(@"self.headimg %@",self.headimg);
        self.name = [dictionary objectForKey:@"name"];
        /*
         @property (nonatomic,retain)NSString *course;//课程
         @property (nonatomic,retain)NSString *status;//状态
         @property (nonatomic,retain)NSString *number;//电话
         @property (nonatomic,retain)NSString *coachName;
         @property (nonatomic,retain)NSString *sex;
         @property (nonatomic,retain)NSString *headimg;
         @property (nonatomic,retain)NSString *coachClass;
         
         */
        
        
    }
    return self;
}



@end
