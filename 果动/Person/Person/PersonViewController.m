//
//  PersonViewController.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "RechargeViewController.h"
#import "PersonViewController.h"
#import "TopView.h"
#import "CustomView.h"
#import "SetViewController.h"
#import "InformationModel.h"
#import "LoginViewController.h"
@interface PersonViewController ()

@end

@implementation PersonViewController
{
    UIImageView *bannerImageView;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([HttpTool judgeWhetherUserLogin]) {
        NSString *url = [NSString stringWithFormat:@"%@api/?method=user.get_userinfo",BASEURL];
        [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
            
        } success:^(id responseObject) {
            
            
            InformationModel *information = [[InformationModel alloc] initWithDictionary:
                                             [responseObject objectForKey:@"data"]];
            
            NSDictionary *dict = @{@"headImageUrl":information.headImgUrl,
                                   @"nickName":information.nickName
                                   };
            
            
            [bannerImageView sd_setImageWithURL:[NSURL URLWithString:information.bannerImgUrl]];
            NSNotification *notification = [NSNotification notificationWithName:@"Top" object:nil userInfo:dict];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
            
            NSDictionary *custom = @{@"user":information.user_id,
                                     @"nickName":information.nickName,
                                     @"haveNews":_haveNews};
            
            NSNotification *Customnotification = [NSNotification notificationWithName:@"Custom" object:nil userInfo:custom];
            [[NSNotificationCenter defaultCenter] postNotification:Customnotification];
        }];
    }  else {
        NSDictionary *dict = @{@"headImageUrl":@"",
                               @"nickName":@"果动"
                               };
        
        [bannerImageView sd_setImageWithURL:[NSURL URLWithString:@""]];
        NSNotification *notification = [NSNotification notificationWithName:@"Top" object:nil userInfo:dict];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BASECOLOR;
   
    /********************/
    
    __block PersonViewController *person = self;
    
    self.pushSetVCBlock = ^(NSString *imageUrl){
        SetViewController *set  = [[SetViewController alloc] init];
        set.imageString = imageUrl;
        [person.navigationController pushViewController:set animated:YES];
        
    };
    
    /********************/
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(155))];
    [self.view addSubview:topView];
    
    
    NSArray *stringArray = @[@"我的订单",@"我的数据",@"我的消息",@"我的发布",@"健身日记",@"优惠劵",@"意见反馈"];
    NSArray *imageArray  = @[@"person_order",@"person_data",@"person_news",@"person_publish",@"person_dairy",@"person_money",@"person_feedback"];
    
    for (int a = 0; a < stringArray.count; a++) {
        CGRect  Frame = CGRectMake(0,
                                   0,
                                   viewWidth,
                                   Adaptive(40));
        
        switch (a) {
            case 0:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(9);
                break;
            case 1:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(18) + Adaptive(41) * 1;
                break;
            case 2:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(18) + Adaptive(41) * 2;
                break;
            case 3:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(18) + Adaptive(41) * 3;
                break;
            case 4:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(18) + Adaptive(41) * 4;
                break;
            case 5:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(27) + Adaptive(41) * 5;
                break;
            case 6:
                Frame.origin.y = CGRectGetMaxY(topView.frame) + Adaptive(27) + Adaptive(41) * 6;
                break;
                
            default:
                break;
        }
        
        
        UIImage *titleImage = [UIImage imageNamed:imageArray[a]];
        
        CustomView *custom  = [[CustomView alloc] initWithFrame:Frame titleImage:titleImage title:stringArray[a] buttontag:10 + a viewController:self];
        [self.view addSubview:custom];
    }
    
    CGRect  bannerFrame = CGRectMake(0,
                                     viewHeight - Tabbar_Height - Adaptive(140),
                                     viewWidth,
                                     Adaptive(130));
    
    bannerImageView = [[UIImageView alloc] initWithFrame:bannerFrame];
    bannerImageView.backgroundColor = BASEGRYCOLOR;
    bannerImageView.userInteractionEnabled = YES;
    [self.view addSubview:bannerImageView];
    
    UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    [bannerImageView addGestureRecognizer:tapLeftDouble];
    
}
-(void)magnifyImage:(UIGestureRecognizer *)gesture
{
    self.hidesBottomBarWhenPushed = YES;
    RechargeViewController *rechargeVC = [RechargeViewController new];
    [self.navigationController pushViewController:rechargeVC animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - 单例
+ (instancetype)sharedViewControllerManager
{
    static dispatch_once_t onceToken;
    static PersonViewController* viewController;
    
    dispatch_once(&onceToken, ^{
        viewController = [[PersonViewController alloc] init];
    });
    
    return viewController;
}

@end
