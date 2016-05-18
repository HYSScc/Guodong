//
//  BackView.h
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackView : UIView

- (instancetype)initWithbacktitle:(NSString*)backtitle viewController:(UIViewController*)viewController;


//设置各个页面的标题
+ (UILabel*)titleLabeltext:(NSString*)text;


@end