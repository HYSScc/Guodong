//
//  HeadComment.h
//  果动
//
//  Created by mac on 15/6/24.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UITextInput.h>
#import <Foundation/Foundation.h>
@interface HeadComment : NSObject

@property (nonatomic,retain) UIViewController *backVC;
//切圆角
+(void)cornerRadius:(UIImageView *)imageView;

//提示框
+(void)message:(NSString *)message delegate:(id)delegate witchCancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

//设置各个页面的标题
+(UILabel *)titleLabeltext:(NSString *)text;

//设置各个页面的返回按钮样式
+(UIView *)backViewWithBackTitle:(NSString *)title viewController:(UIViewController *)viewController;

//设置各个尺寸frame
+(CGRect)setFourSframe:(CGRect)fourSframe FiveSframe:(CGRect)fiveSframe Sixframe:(CGRect)sixframe SixPframe:(CGRect)sixPframe;

+(UIColor *)colorWithHexCodeCWL:(NSString *)hexCode;
@end
