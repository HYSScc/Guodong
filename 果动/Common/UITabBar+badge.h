//
//  UITabBar+badge.h
//  果动
//
//  Created by mac on 16/7/11.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (badge)

- (void)showBadgeOnItemIndex:(int)index;   //显示小红点

- (void)hideBadgeOnItemIndex:(int)index; //隐藏小红点

@end
