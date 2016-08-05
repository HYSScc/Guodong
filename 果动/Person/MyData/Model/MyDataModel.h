//
//  MyDataModel.h
//  果动
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDataModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *time;
@property (nonatomic,retain) NSString *data_id;
@property (nonatomic,retain) NSString *leftImageUrl;
@property (nonatomic,retain) NSString *rightImageUrl;

@property (nonatomic,retain) NSString *height;     // 身高
@property (nonatomic,retain) NSString *weight;     // 体重
@property (nonatomic,retain) NSString *waistline;  // 腰围
@property (nonatomic,retain) NSString *hip;        // 臀围
@property (nonatomic,retain) NSString *rham;       // 右大腿
@property (nonatomic,retain) NSString *lham;       // 左大腿
@property (nonatomic,retain) NSString *rcrus;      // 右小腿
@property (nonatomic,retain) NSString *lcrus;      // 左小腿
@property (nonatomic,retain) NSString *rtar;       // 右上臂-放松
@property (nonatomic,retain) NSString *rtaqj;      // 右上臂-屈曲
@property (nonatomic,retain) NSString *ltar;       // 左上臂-放松
@property (nonatomic,retain) NSString *ltaqj;      // 左上臂-屈曲
@property (nonatomic,retain) NSString *bust_relax; // 胸围-放松
@property (nonatomic,retain) NSString *bust_exp;   // 胸围-扩张
@property (nonatomic,retain) NSString *gstj;       // 肱三头肌
@property (nonatomic,retain) NSString *kjsy;       // 髋嵴上缘
@property (nonatomic,retain) NSString *jjxy;       // 肩胛下缘
@property (nonatomic,retain) NSString *abdomen;    // 腹部
@property (nonatomic,retain) NSString *fat_ham;    // 大腿
@property (nonatomic,retain) NSString *total;      // 总计
@property (nonatomic,retain) NSString *fat;        // 脂肪百分比
@property (nonatomic,retain) NSString *ytbl;       // 腰臀比例
@property (nonatomic,retain) NSString *bmi;        // BMI
@property (nonatomic,retain) NSString *static_heart_rate; // 静态心率
@property (nonatomic,retain) NSString *blood_pressure;    // 血压
@property (nonatomic,retain) NSString *target_heart_rate; // 目标心率

@end
