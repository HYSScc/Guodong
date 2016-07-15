//
//  PublishViewController.m
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "PublishViewController.h"
#import "ChangeView.h"
#import "My_NewsView.h"
#import "LoginViewController.h"
@interface PublishViewController ()

@end

@implementation PublishViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"我的发布" viewController:self];
    [self.view addSubview:navigation];
    
    [self createTopView];
}

- (void)createTopView {
    
    ChangeView *topView = [[ChangeView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, Adaptive(150)) user_id:_user_id viewController:self];
    topView.backgroundColor = BASEGRYCOLOR;
    [self.view addSubview:topView];
    
    
    if ([HttpTool judgeWhetherUserLogin]) {
        My_NewsView *contentView = [[My_NewsView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(topView.frame) + Adaptive(10), viewWidth,viewHeight - NavigationBar_Height - Adaptive(160)) user_id:_user_id viewController:self];
        [self.view addSubview:contentView];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}

@end
