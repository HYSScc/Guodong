//
//  HeadComment.m
//  果动
//
//  Created by mac on 15/6/24.
//  Copyright (c) 2015年 Unique. All rights reserved.
//
#define viewWidth [UIScreen mainScreen].bounds.size.width
#define viewHeight [UIScreen mainScreen].bounds.size.height
#import "Commonality.h"
#import "HeadComment.h"

@implementation HeadComment

//切圆角
+ (void)cornerRadius:(UIImageView*)imageView
{
    imageView.clipsToBounds = YES;
    imageView.layer.cornerRadius = imageView.frame.size.width / 2;
}
//提示框
+ (void)message:(NSString*)message delegate:(id)delegate witchCancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
    [alert show];
}
+ (UIView*)backViewWithBackTitle:(NSString*)title viewController:(UIViewController*)viewController
{
    NSLog(@"进了设置返回页面");
    UIView* backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewHeight / 6.67, viewHeight / 33.35)];
    //6.5  11
    UIImageView* backArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 6.5 * 1.5, 11 * 1.5)];
    backArrowImageView.image = [UIImage imageNamed:@"every_back"];
    [backView addSubview:backArrowImageView];

    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    backButton.frame = CGRectMake(CGRectGetMaxX(backArrowImageView.frame) + 3, 0, 70, 30);
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];

    [backView addSubview:backButton];

    return backView;
}
- (void)backButton
{
}
/**
 *  设置各个页面的标题
 *
 *  @param text 标题
 *
 *  @return 返回label
 */
+ (UILabel*)titleLabeltext:(NSString*)text
{
    UILabel* titlelabel = [UILabel new];
    titlelabel.text = text;
    titlelabel.font = [UIFont fontWithName:FONT size:viewHeight / 37.056];
    titlelabel.frame = CGRectMake(0, 0, viewHeight / 6.67, viewHeight / 22.233);
    [titlelabel setTextColor:[UIColor orangeColor]];
    titlelabel.textAlignment = NSTextAlignmentCenter;
    return titlelabel;
}
+ (CGRect)setFourSframe:(CGRect)fourSframe FiveSframe:(CGRect)fiveSframe Sixframe:(CGRect)sixframe SixPframe:(CGRect)sixPframe
{
    CGRect FRAME;
    if (viewWidth == 320 & viewHeight == 480) {
        FRAME = fourSframe;
    }
    if (viewWidth == 320 && viewHeight == 568) {
        FRAME = fiveSframe;
    }
    //6
    if (viewWidth == 375 && viewHeight == 667) {
        FRAME = sixframe;
    }
    //6p
    if (viewWidth == 414 && viewHeight == 736) {
        FRAME = sixPframe;
    }
    return FRAME;
}
+ (UIColor*)colorWithHexCodeCWL:(NSString*)hexCode
{
    NSString* cleanString = [hexCode stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                [cleanString substringWithRange:NSMakeRange(0, 1)], [cleanString substringWithRange:NSMakeRange(0, 1)],
                                [cleanString substringWithRange:NSMakeRange(1, 1)], [cleanString substringWithRange:NSMakeRange(1, 1)],
                                [cleanString substringWithRange:NSMakeRange(2, 1)], [cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    float red = ((baseValue >> 24) & 0xFF) / 255.0f;
    float green = ((baseValue >> 16) & 0xFF) / 255.0f;
    float blue = ((baseValue >> 8) & 0xFF) / 255.0f;
    float alpha = ((baseValue >> 0) & 0xFF) / 255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
