//
//  AboutViewController.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "AboutViewController.h"
#import "Commonality.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad
{

    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRed:90 / 255.0 green:90 / 255.0 blue:90 / 255.0 alpha:1];
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"关于我们"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"设置" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    [self onCreate];
}
#pragma mark 初始化背景图、按钮控件与名字
- (void)onCreate
{

    UIImageView* lineImage1 = [UIImageView new];
    lineImage1.image = [UIImage imageNamed:@"home__line1"];
    lineImage1.frame = CGRectMake(0, 0, viewWidth, 0.5);
    [self.view addSubview:lineImage1];

    UIImageView* aboutImageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_logo.jpg"]];
    aboutImageview.frame = CGRectMake((viewWidth - Adaptive(100)) / 2, Adaptive(100), Adaptive(100), Adaptive(100));
    aboutImageview.backgroundColor = [UIColor clearColor];
    [self.view addSubview:aboutImageview];

    NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));

    NSString* appVersion = [infoDic objectForKey:@"CFBundleVersion"];

    UILabel* label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.font = [UIFont fontWithName:FONT size:Adaptive(18)];
    label.frame = CGRectMake(0, CGRectGetMaxY(aboutImageview.frame) + Adaptive(20), viewWidth, Adaptive(50));
    label.text = [NSString stringWithFormat:@"最新版本   %@", appVersion];

    [self.view addSubview:label];
}
@end
