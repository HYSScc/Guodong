//
//  MainViewController.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "AppDelegate.h"
#import "MainViewController.h"

#import "ClassViewController.h"
#import "FinderViewController.h"
#import "PersonViewController.h"




@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // 创建Window
    AppDelegate *app = [UIApplication sharedApplication].delegate;
  
    
    // 初始化一个tabBar控制器
    UITabBarController *tabbar    = [UITabBarController new];
    [[UITabBar appearance] setTintColor:ORANGECOLOR];  // 修改点击后的颜色
    [[UITabBar appearance] setBarTintColor:BASECOLOR]; // 修改背景颜色
   
    
    
    ClassViewController *classVC     = [ClassViewController sharedViewControllerManager];
    classVC.tabBarItem.title         = @"课程";
    classVC.tabBarItem.image         = [UIImage imageNamed:@"tabbarGry_1"];
    classVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarOrange_1"];
    
    
    FinderViewController *finderVC    = [FinderViewController sharedViewControllerManager];
    finderVC.tabBarItem.title         = @"发现";
    finderVC.tabBarItem.image         = [UIImage imageNamed:@"tabbarGry_2"];
    finderVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarOrange_2"];
    
    PersonViewController *personVC    = [PersonViewController sharedViewControllerManager];
    personVC.tabBarItem.title         = @"个人";
    personVC.tabBarItem.image         = [UIImage imageNamed:@"tabbarGry_3"];
    personVC.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbarOrange_3"];
    
    
    
    UINavigationController *classNav  = [[UINavigationController alloc] initWithRootViewController:classVC];
   // [classNav.navigationBar setBarTintColor:ORANGECOLOR];
    
    
    UINavigationController *finderNav  = [[UINavigationController alloc] initWithRootViewController:finderVC];
  //  [finderNav.navigationBar setBarTintColor:ORANGECOLOR];
    
    UINavigationController *personNav  = [[UINavigationController alloc] initWithRootViewController:personVC];
   
    
    tabbar.viewControllers = @[classNav,finderNav,personNav];
     app.window.rootViewController = tabbar;
    [app.window makeKeyAndVisible];
    
    
    
    
}



@end
