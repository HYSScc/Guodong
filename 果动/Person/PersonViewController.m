//
//  PersonViewController.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "PersonViewController.h"
#import "TopView.h"
#import "CustomView.h"
@interface PersonViewController ()

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = BASECOLOR;
    
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(155))];
    [self.view addSubview:topView];
    
    
    NSArray *stringArray = @[@"我的订单",@"我的数据",@"我的消息",@"我的发布",@"优惠劵",@"意见反馈"];
    NSArray *imageArray  = @[@"person_order",@"person_data",@"person_news",@"person_publish",@"person_money",@"person_feedback"];
    
    for (int a = 0; a < 6; a++) {
        CGRect  Frame = CGRectMake(0,
                                   0,
                                   viewWidth,
                                   Adaptive(43));
        
        switch (a) {
            case 0:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(10);
                break;
            case 1:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(20) + Adaptive(44) * 1;
                break;
            case 2:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(20) + Adaptive(44) * 2;
                break;
            case 3:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(20) + Adaptive(44) * 3;
                break;
            case 4:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(30) + Adaptive(44) * 4;
                break;
            case 5:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(30) + Adaptive(44) * 5;
                break;
                
            default:
                break;
        }
        
        
        UIImage *titleImage = [UIImage imageNamed:imageArray[a]];
        CustomView *custom  = [[CustomView alloc] initWithFrame:Frame titleImage:titleImage title:stringArray[a] buttontag:10 + a];
        [self.view addSubview:custom];
    }
    
    CGRect  bannerFrame = CGRectMake(0,
                                     viewHeight - Tabbar_Height - Adaptive(140),
                                     viewWidth,
                                     Adaptive(130));
    
    UIImageView *bannerImageView = [[UIImageView alloc] initWithFrame:bannerFrame];
    bannerImageView.backgroundColor = [UIColor colorWithRed:0
                                                      green:248/255.0
                                                       blue:250/255.0
                                                      alpha:1];
    [self.view addSubview:bannerImageView];
    
}



@end
