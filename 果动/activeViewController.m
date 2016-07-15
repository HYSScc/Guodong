//
//  activeViewController.m
//  果动
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "activeViewController.h"
@interface activeViewController ()
{
    UIImageView *imageView;
}
@end

@implementation activeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"活动" viewController:self];
    [self.view addSubview:navigation];
    
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight - NavigationBar_Height)];
    imageView.image = [UIImage imageNamed:@"active_dk"];
    [self.view addSubview:imageView];
    
    UIImageView *sjImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(83)) / 2,
                                                                             Adaptive(500) + NavigationBar_Height,
                                                                             Adaptive(83),
                                                                             Adaptive(73))];
    sjImageView.image = [UIImage imageNamed:@"active_sj"];
    sjImageView.userInteractionEnabled = YES;
    [self.view addSubview:sjImageView];
    UIImageView *dkImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(23)) / 2, Adaptive(540) + NavigationBar_Height, Adaptive(23), Adaptive(11))];
    dkImageView.image = [UIImage imageNamed:@"active_dkTitle"];
    [self.view addSubview:dkImageView];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame     = CGRectMake(0,
                                  0,
                                  sjImageView.bounds.size.width,
                                  sjImageView.bounds.size.height);
    [button addTarget:self action:@selector(classBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [sjImageView addSubview:button];
    
}


- (void)classBtnClick {
    NSLog(@"点击订课");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
