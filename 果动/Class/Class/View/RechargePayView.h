//
//  RechargePayView.h
//  果动
//
//  Created by mac on 16/7/6.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RechargePayView : UIView

- (instancetype)initWithFrame:(CGRect)frame balance:(NSString *)ban viewController:(UIViewController *)controller;
@property (nonatomic,retain) UILabel *youhuiMoneyLabel;
@property (nonatomic,retain) NSString *ishave;
@end
