//
//  PayViewController.h
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayViewController : UIViewController

@property (nonatomic,retain) NSMutableArray *packageArray;
@property (nonatomic,retain) NSString *iconImageUrl;
@property (nonatomic,assign) int       iconHeight;
@property (nonatomic,assign) int       iconWidth;
@property (nonatomic,retain) NSString *order_id;
@property (nonatomic,retain) NSString *oneClassPrice;
@property (nonatomic,retain) NSString *oneClassTime;
@property (nonatomic,retain) NSString *userMoney;
@property (nonatomic,retain) NSString *userBalance;
@property (nonatomic,retain) NSString *rechargeUrl;
@property (nonatomic,retain) NSString *rechargeWidth;
@property (nonatomic,retain) NSString *rechargeHeight;

@property (nonatomic,retain) NSDictionary *addressMessageDict;

@end
