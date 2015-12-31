//
//  HomeController.h
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface HomeController : UIViewController

+ (instancetype)sharedViewControllerManager;

@property (nonatomic, copy) void (^block)(NSString* order_id); //推送教练是否接单
@property (nonatomic, copy) void (^vipblock)(NSString* alert); //推送vip次数
@property (nonatomic, copy) void (^elseblock)(NSString* alert); //推送无聊的消息
@property (nonatomic, copy) void (^pushCityVCBlock)(NSString* cityName); //跳转到cityVC
@property (nonatomic, copy) void (^pushClassVCBlock)(NSString* titleString, int class_id);
//跳转到课程界面
@property (nonatomic, copy) void (^pushShopVCBlock)(NSString* classNumber, NSString* titleString); //跳转到体验店界面
@property (nonatomic, copy) void (^alertImageBlock)(NSString* imageName); //提示框动画
@property (nonatomic, copy) void (^removeAnimationBlock)(BOOL isSucc); //移除所有动画
@property (nonatomic, copy) void (^pushLoginVCBlock)(void); //跳转到登陆界面

@property (nonatomic, retain) UIImageView* alertImageView;
@property (nonatomic, assign) CGFloat longitude, latitude;
@end
