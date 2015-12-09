//
//  ExerciseDetailComment.h
//  果动
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExerciseDetailComment : NSObject
@property (nonatomic,retain)NSString *time;
@property (nonatomic,retain)NSString *coach;
@property (nonatomic,retain)NSString *waistline;
@property (nonatomic,retain)NSString *hip;
@property (nonatomic,retain)NSString *rham;
@property (nonatomic,retain)NSString *lham;
@property (nonatomic,retain)NSString *rcrus;
@property (nonatomic,retain)NSString *lcrus;
@property (nonatomic,retain)NSString *rtar;
@property (nonatomic,retain)NSString *rtaqj;
@property (nonatomic,retain)NSString *ltar;
@property (nonatomic,retain)NSString *ltaqj;
@property (nonatomic,retain)NSString *bust_relax;
@property (nonatomic,retain)NSString *bust_exp;
@property (nonatomic,retain)NSString *gstj;
@property (nonatomic,retain)NSString *kjsy;
@property (nonatomic,retain)NSString *jjxy;
@property (nonatomic,retain)NSString *abdomen;
@property (nonatomic,retain)NSString *fat_ham;
@property (nonatomic,retain)NSString *total;
@property (nonatomic,retain)NSString *fat;
@property (nonatomic,retain)NSString *ytbl;
@property (nonatomic,retain)NSString *bmi;
@property (nonatomic,retain)NSString *static_heart_rate;
@property (nonatomic,retain)NSString *blood_pressure;
@property (nonatomic,retain)NSString *target_heart_rate;



-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
