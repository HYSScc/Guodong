//
//  ExerciseDetailComment.m
//  果动
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "ExerciseDetailComment.h"

@implementation ExerciseDetailComment
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        
        self.time = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"time"]];
        self.coach = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"coach"]];
        self.waistline = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"waistline"]];
        self.hip = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"hip"]];
        self.rham = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"rham"]];
        self.lham = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"lham"]];
        self.rcrus = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"rcrus"]];
        self.lcrus = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"lcrus"]];
        self.rtar = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"rtar"]];
        self.rtaqj = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"rtaqj"]];
        self.ltar = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ltar"]];
        self.ltaqj = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ltaqj"]];
        self.bust_relax = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"bust_relax"]];
        self.bust_exp = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"bust_exp"]];
        self.gstj = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"gstj"]];
        self.kjsy = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"kjsy"]];
        self.jjxy = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"jjxy"]];
        self.abdomen = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"abdomen"]];
        self.fat_ham = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"fat_ham"]];
        self.total = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"total"]];
        self.fat = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"fat"]];
        self.ytbl = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ytbl"]];
        self.bmi = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"bmi"]];
        self.static_heart_rate = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"static_heart_rate"]];
        self.blood_pressure = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"blood_pressure"]];
        self.target_heart_rate = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"target_heart_rate"]];
        
    }
    return self;
}

@end
