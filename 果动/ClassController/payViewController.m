//
//  payViewController.m
//  果动
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "payViewController.h"
#import "changeNumberView.h"
#import "payView.h"
@interface payViewController ()



@end

@implementation payViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BASECOLOR;
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"支付"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"返回" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    [self createUI];
    
}

- (void)createUI {
    
    NSLog(@"_packageArray %@",_packageArray);
    
    changeNumberView *changeNumber = [[changeNumberView alloc] initWithFrame:CGRectMake(0,
                                                                                        0,
                                                                                        viewWidth,
                                                                                        viewHeight / 2)
                                                                 classNumber:_imageStyleNumber
                                                             changeViewArray:_packageArray
                                                                   price_one:self.price_one
                                                             onePersonNumber:self.onePersonNumber
                                                           classPersonNumber:self.price_number];
    [self.view addSubview:changeNumber];
    
    
    payView *pay = [[payView alloc] initWithFrame:CGRectMake(0,
                                                             CGRectGetMaxY(changeNumber.frame),
                                                             viewWidth,
                                                             (viewHeight - NavigationBar_Height - Tabbar_Height)  / 2)
                                         payMoney:self.price_one
                                        classTime:self.course_time
                                       youhuijuan:self.youhuijuan
                                         order_id:self.order_id
                                  viewController:self];
    NSLog(@"self.order_id %@",self.order_id);
    
    [self.view addSubview:pay];
    
}


@end
