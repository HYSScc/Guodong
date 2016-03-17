//
//  LocationView.m
//  果动
//
//  Created by mac on 15/3/28.
//  Copyright © 2015年 Unique. All rights reserved.
//
#import "AppDelegate.h"

#import "LeftVBaseView.h"
#import "LocationView.h"
#import "LoginViewController.h"
#import "OrderFormController.h"
#import "RightVBaseView.h"
#import "SDCycleScrollView.h"
#import "cityVCViewController.h"
#import "classViewController.h"
#import "homeController.h"
#import "activeViewController.h"
@interface HomeController () <UIScrollViewDelegate, UIAlertViewDelegate> {
    LocationView* locationView;
    LeftVBaseView* leftBaseView;
    RightVBaseView* rightBaseView;
    NSString* ORDER_ID;
    UIView* alertview;
    BOOL ischange;
    UIImageView* changeImage;
    UILabel* classLabel;
    UILabel* frameLabel;
    BOOL succ;
}
/*
 MVVM
 Model        处理数据模型
 viewModel    viewModel处理表示逻辑(解析..转换..等)
 View         显示  触发 等更轻量级操作
 */
@end

@implementation HomeController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
   
    if (!succ) {
        CABasicAnimation* basic1 =
            [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        basic1.fromValue = [NSNumber numberWithFloat:0];
        basic1.byValue = [NSNumber numberWithFloat:M_PI * 2];
        basic1.repeatCount = 10000;
        basic1.duration = 1.5;
        [locationView.topLocationImageView.layer addAnimation:basic1
                                                       forKey:@"basic1"];
    }
    //通知左视图刷新数据
    NSNotification* notification = [NSNotification notificationWithName:@"refreshLeftView" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
     [self onCreate];
 
    [[UIApplication sharedApplication]
        setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController.navigationBar
        setBackgroundImage:[UIImage imageNamed:@"nav"]
             forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = BASECOLOR;

    UIView* titleView = [[UIView alloc]
        initWithFrame:CGRectMake(0, 0, Adaptive(51.6), Adaptive(27))];
    UIImageView* titleImage = [[UIImageView alloc]
        initWithFrame:CGRectMake(0, 0, titleView.bounds.size.width,
                          titleView.bounds.size.height)];
    titleImage.image = [UIImage imageNamed:@"shouye_titleImage"];
    [titleView addSubview:titleImage];
    self.navigationItem.titleView = titleView;

    locationView = [LocationView sharedViewManager];
    locationView.frame = CGRectMake(0, Adaptive(27), Adaptive(80), Adaptive(20));
    UIBarButtonItem* cityButtonItem =
        [[UIBarButtonItem alloc] initWithCustomView:locationView];
    self.navigationItem.leftBarButtonItem = cityButtonItem;

    __block LocationView* location = locationView;
    __block HomeController* home = self;
    //推送教练是否接单
    self.block = ^(NSString* order_id) {
        ORDER_ID = order_id;
        UIAlertView* alert =
            [[UIAlertView alloc] initWithTitle:@"提示"
                                       message:@"有教练接单啦"
                                      delegate:home
                             cancelButtonTitle:nil
                             otherButtonTitles:@"查看", nil];

        [alert show];
    };
    //推送vip次数
    self.vipblock = ^(NSString* alert) {
        UIAlertView* vipalert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                           message:alert
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"确定", nil];
        [vipalert show];
    };
    //推送无聊的消息
    self.elseblock = ^(NSString* alert) {
        UIAlertView* vipalert = [[UIAlertView alloc] initWithTitle:nil
                                                           message:alert
                                                          delegate:nil
                                                 cancelButtonTitle:nil
                                                 otherButtonTitles:@"确定", nil];
        [vipalert show];
    };
    //跳转到cityViewController
    self.pushCityVCBlock = ^(NSString* cityName) {
        cityVCViewController* cityVC = [cityVCViewController new];
        cityVC.city = cityName;
        [home.navigationController pushViewController:cityVC animated:YES];
    };
    //跳转到课程界面
    self.pushClassVCBlock = ^(NSString* titleString, int class_id) {
        classViewController* class = [classViewController new];
        class.titleString = titleString;
        class.class_id = class_id;
        class.isShop = NO;
        [home.navigationController pushViewController:class animated:YES];
    };
    //跳转到登陆界面
    self.pushLoginVCBlock = ^(void) {
        UIAlertView* loginAlert =
            [[UIAlertView alloc] initWithTitle:@"提示"
                                       message:@"您还没有登录呢！"
                                      delegate:home
                             cancelButtonTitle:@"取消"
                             otherButtonTitles:@"登录", nil];
        loginAlert.tag = 88;
        [loginAlert show];
    };
    //跳转到活动页
    self.pushActiveViewBlock = ^(NSString *number) {
        activeViewController *active = [activeViewController new];
        active.number = number;
        [home.navigationController pushViewController:active animated:YES];
    };
    
    
    //跳转到体验店界面
    self.pushShopVCBlock = ^(NSString* classNumber, NSString* titleString) {
        classViewController* class = [classViewController new];
        class.isShop = YES;
        class.shop_id = classNumber;
        class.titleString = titleString;
        NSLog(@"class.shop_id %@", class.shop_id);

        [home.navigationController pushViewController:class animated:YES];
    };
    //移除掉所有动画
    self.removeAnimationBlock = ^(BOOL isSucc) {
        if (isSucc) {
            succ = isSucc;
            [location.topLocationImageView.layer removeAllAnimations];
        }
    };
    //提示框动画
    self.alertImageBlock = ^(NSString* imageName) {
        [home alertImageWithImageName:imageName];
    };
}

- (void)alertImageWithImageName:(NSString*)imageName
{
    [_alertImageView setImage:[UIImage imageNamed:imageName]];
    [UIView animateWithDuration:.4
        animations:^{
            _alertImageView.frame = CGRectMake(0, 0, viewWidth, Adaptive(50));
        } completion:^(BOOL finished) {
            [NSThread sleepForTimeInterval:0.7f];
            [UIView animateWithDuration:.4
                animations:^{
                    _alertImageView.alpha = 0;
                } completion:^(BOOL finished){}];
        }];
}

- (void)alertView:(UIAlertView*)alertView
    didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 88) {
        if (buttonIndex == 1) {
            LoginViewController* login = [LoginViewController new];
            [self.navigationController pushViewController:login animated:YES];
        }
    } else {
        OrderFormController* order = [OrderFormController new];
        [self.navigationController pushViewController:order animated:YES];
    }
}

#pragma mark 初始化背景图、按钮控件与名字
- (void)onCreate
{
    /**********课程|范围*************/
    changeImage = [[UIImageView alloc]
        initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(50))];
    if (IS_IPHONE5S) {
        changeImage.frame = CGRectMake(0, 0, viewWidth, 36);
    }
    [changeImage setImage:[UIImage imageNamed:@"shouye_leftblack"]];
    changeImage.userInteractionEnabled = YES;
    [self.view addSubview:changeImage];

    _alertImageView = [[UIImageView alloc]
        initWithFrame:CGRectMake(0, -Adaptive(50), viewWidth,
                          Adaptive(50))];
    [self.view addSubview:_alertImageView];

    classLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(
                          viewWidth / 4 - Adaptive(20),
                          (changeImage.bounds.size.height - Adaptive(30)) / 2,
                          Adaptive(40), Adaptive(30))];
    classLabel.textColor = [UIColor colorWithRed:235.00 / 255
                                           green:117.00 / 255
                                            blue:32.00  / 255
                                           alpha:1];
    classLabel.text = @"课程";
    classLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [changeImage addSubview:classLabel];

    frameLabel = [[UILabel alloc]
        initWithFrame:CGRectMake(
                          (viewWidth * 3 / 4) - Adaptive(20),
                          (changeImage.bounds.size.height - Adaptive(30)) / 2,
                          Adaptive(50), Adaptive(30))];
    frameLabel.textColor = [UIColor lightGrayColor];
    frameLabel.text = @"体验店";
    frameLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [changeImage addSubview:frameLabel];

    UIButton* classButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    classButton.frame = CGRectMake(0, 0, viewWidth / 2, Adaptive(50));
    classButton.tag = 11;
    [classButton addTarget:self
                    action:@selector(changeClass:)
          forControlEvents:UIControlEventTouchUpInside];
    [changeImage addSubview:classButton];

    UIButton* frameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frameButton.frame = CGRectMake(viewWidth / 2, 0, viewWidth / 2, Adaptive(50));
    frameButton.tag = 22;
    [frameButton addTarget:self
                    action:@selector(changeClass:)
          forControlEvents:UIControlEventTouchUpInside];
    [changeImage addSubview:frameButton];
    /******************************/

    /*************左视图|课程****************/

    //左视图
    leftBaseView = [LeftVBaseView new];
    leftBaseView.frame = CGRectMake(0, CGRectGetMaxY(changeImage.frame), viewWidth,
            viewHeight - NavigationBar_Height - Adaptive(50) - changeImage.bounds.size.height);
    leftBaseView.backgroundColor = BASECOLOR;
    [self.view addSubview:leftBaseView];

    /*************右视图|地图范围****************/
    rightBaseView = [[RightVBaseView alloc]
        initWithFrame:CGRectMake(0, CGRectGetMaxY(changeImage.frame), viewWidth,
                          viewHeight - NavigationBar_Height - Adaptive(50) - changeImage.bounds.size.height)];

    rightBaseView.backgroundColor = BASECOLOR;
}

- (void)changeClass:(UIButton*)button
{
    if (button.tag == 11) {
        [changeImage setImage:[UIImage imageNamed:@"shouye_leftblack"]];
        classLabel.textColor = [UIColor colorWithRed:235.00 / 255
                                               green:117.00 / 255
                                                blue:32.00  / 255
                                               alpha:1];
        frameLabel.textColor = [UIColor lightGrayColor];
        [rightBaseView removeFromSuperview];
        [self.view addSubview:leftBaseView];
    } else {
        [changeImage setImage:[UIImage imageNamed:@"shouye_leftgry"]];
        frameLabel.textColor = [UIColor colorWithRed:235.00 / 255
                                               green:117.00 / 255
                                                blue:32.00  / 255
                                               alpha:1];
        classLabel.textColor = [UIColor lightGrayColor];
        [leftBaseView removeFromSuperview];
        [self.view addSubview:rightBaseView];
    }
}

#pragma mark 触摸屏幕回收弹出view
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [alertview removeFromSuperview];
}
+ (instancetype)sharedViewControllerManager
{
    static dispatch_once_t onceToken;
    static HomeController* viewController;

    dispatch_once(&onceToken, ^{
        viewController = [[HomeController alloc] init];
    });

    return viewController;
}

@end
