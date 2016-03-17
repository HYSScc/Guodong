//
//  MoneyNumberView.h
//  果动
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyNumberView : UIView
- (id)initWithFrame:(CGRect)frame viewController:(UIViewController *)controller;
@property (nonatomic,assign) NSInteger number;
@end
