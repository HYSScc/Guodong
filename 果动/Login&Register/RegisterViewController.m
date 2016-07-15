//
//  RegisterViewController.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "MainViewController.h"
#import "RegisterViewController.h"
#import "TranformFadeView.h"
#import "RegisterTextView.h"
#import "AppDelegate.h"
typedef enum : NSUInteger {
    TYPE_ONE,
    TYPE_TWO,
    TYPE_THREE,
    TYPE_FOUR,
} EType;

@interface RegisterViewController ()

@property (nonatomic, strong) TranformFadeView *tranformFadeViewOne;
@property (nonatomic, strong) TranformFadeView *tranformFadeViewTwo;
@property (nonatomic, strong) TranformFadeView *tranformFadeViewThree;
@property (nonatomic, strong) TranformFadeView *tranformFadeViewFour;

@property (nonatomic, strong) NSTimer          *imageTimer;
@property (nonatomic, strong) NSTimer          *startTimer;
@property (nonatomic)         EType             type;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /**
     *   部分共同的属性放到TranformFadeView初始化中
     */
    
    // 图片1
    self.tranformFadeViewOne                 = [[TranformFadeView alloc] initWithFrame:self.view.bounds];
    self.tranformFadeViewOne.image           = [UIImage imageNamed:@"yindaoye_1"];
    self.tranformFadeViewOne.center          = self.view.center;
    [self.tranformFadeViewOne buildMaskView];
    [self.view addSubview:self.tranformFadeViewOne];
    
    // 图片2
    self.tranformFadeViewTwo                 = [[TranformFadeView alloc] initWithFrame:self.view.bounds];
    self.tranformFadeViewTwo.image           = [UIImage imageNamed:@"yindaoye_2"];
    self.tranformFadeViewTwo.center          = self.view.center;
    [self.tranformFadeViewTwo buildMaskView];
    [self.view addSubview:self.tranformFadeViewTwo];
    [self.tranformFadeViewTwo fadeAnimated:YES];
    
    // 图片3
    self.tranformFadeViewThree                 = [[TranformFadeView alloc] initWithFrame:self.view.bounds];
    self.tranformFadeViewThree.image           = [UIImage imageNamed:@"yindaoye_3"];
    self.tranformFadeViewThree.center          = self.view.center;
    [self.tranformFadeViewThree buildMaskView];
    [self.view addSubview:self.tranformFadeViewThree];
    [self.tranformFadeViewThree fadeAnimated:YES];
    
    // 定时器
    self.imageTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                       target:self
                                                     selector:@selector(imageTimerEvent)
                                                     userInfo:nil
                                                      repeats:YES];
    self.type  = TYPE_ONE;
    
    
    // 定时器
    self.startTimer = [NSTimer scheduledTimerWithTimeInterval:5
                                                       target:self
                                                     selector:@selector(startTimerEvent)
                                                     userInfo:nil
                                                      repeats:NO];
    
    
}
#pragma mark - 图片定时器方法

- (void)imageTimerEvent {
    
    
    
    if (self.type == TYPE_ONE) {
        self.type = TYPE_TWO;
        
        [self.view sendSubviewToBack:self.tranformFadeViewTwo];
        [self.tranformFadeViewTwo    showAnimated:NO];
        [self.tranformFadeViewOne    fadeAnimated:YES];
        
    } else if (self.type == TYPE_TWO){
        self.type = TYPE_THREE;
        
        [self.view sendSubviewToBack:self.tranformFadeViewThree];
        [self.tranformFadeViewThree  showAnimated:NO];
        [self.tranformFadeViewTwo    fadeAnimated:YES];
        
    }else {
        self.type = TYPE_ONE;
        
        [self.view sendSubviewToBack:self.tranformFadeViewOne];
        [self.tranformFadeViewOne    showAnimated:NO];
        [self.tranformFadeViewThree  fadeAnimated:YES];
        
    }
}

#pragma mark - 立即体验显示定时器方法
- (void) startTimerEvent {
    UIButton *startBtn          = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [startBtn setBackgroundImage:[UIImage imageNamed:@"startBtn"] forState:UIControlStateNormal];
    startBtn.layer.cornerRadius = 5;
    startBtn.alpha              = 0;
    [startBtn addTarget:self action:@selector(startBtnClick) forControlEvents:UIControlEventTouchUpInside];
    startBtn.frame              = CGRectMake((viewWidth - Adaptive(100)) / 2, Adaptive(600), Adaptive(100), Adaptive(30));
    [self.view addSubview:startBtn];
    
    
    [UIView animateWithDuration:2.f animations:^{
        startBtn.alpha = 1.f;
    }];
}

#pragma mark - 立即体验点击事件
- (void)startBtnClick {
    
    [self.tranformFadeViewOne removeFromSuperview];
    [self.tranformFadeViewTwo removeFromSuperview];
    [self.tranformFadeViewThree removeFromSuperview];
    
  //  RegisterTextView *registerView = [[RegisterTextView alloc] initWithFrame:self.view.bounds];
  //  [self.view addSubview:registerView];
    
    // 跳转页面
    MainViewController* main = [MainViewController new];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = main;

    
}

@end
