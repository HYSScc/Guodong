//
//  addMessageModel.h
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addMessageModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@property (nonatomic,retain) NSString *topImageUrl;
@property (nonatomic,assign) int       topImageHeight;
@property (nonatomic,retain) NSString *iconImageUrl;
@property (nonatomic,assign) int       iconHeight;
@property (nonatomic,assign) int       iconWidth;
@property (nonatomic,retain) NSArray  *timeArray;

@property (nonatomic,retain) NSString *user_phone;
@property (nonatomic,retain) NSString *user_name;
@property (nonatomic,retain) NSString *user_address;

@property (nonatomic,retain) NSString *rechargeUrl;
@property (nonatomic,retain) NSString *rechargeWidth;
@property (nonatomic,retain) NSString *rechargeHeight;


@property (nonatomic,retain) NSMutableArray *courseArray;
@property (nonatomic,retain) NSMutableArray *courseClassArray;
@property (nonatomic,retain) NSMutableArray *packageArray;

@property (nonatomic,retain) NSString *user_money;

@property (nonatomic,retain) NSString *package_balance;

@end
