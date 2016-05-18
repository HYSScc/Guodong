//
//  AppDelegate.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//


#import "AppDelegate.h"
#import "MainViewController.h"     // 设置tabbar
#import "RegisterViewController.h" // 注册

#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>


@interface AppDelegate ()<CLLocationManagerDelegate> {
    
    CLLocationManager* _locationManager; // 位置管理器
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{
    
    
    
    /**
     *  判断是否第一次登录
     */
    NSString* key         = (NSString*)kCFBundleVersionKey;
    NSString* version     = [NSBundle mainBundle].infoDictionary[key];
    NSString* saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if ([version isEqualToString:saveVersion]) {
        
        MainViewController* main = [MainViewController new];
        self.window.rootViewController = main;
        
    } else {
        
        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.window.rootViewController = [RegisterViewController new];
    }

    /*****************请求用户授权定位************************/
    
    //定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication*)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    //#warning 更新
    //    //影响启动速度
    //    [Version onCheckVersion];
    //    NSLog(@"程序要退出了11 %d",self.isVersion);
    //    if (self.isVersion == YES && self.isZanbu != YES) {
    //        [Version registerLocalNotification:3];
    //    }
}
- (void)application:(UIApplication*)application didReceiveLocalNotification:(UILocalNotification*)notification
{

    //    NSLog(@"noti:%@",notification);
    //
    //    // 这里真实需要处理交互的地方
    //    // 获取通知所带的数据
    //    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"果动有新版本发布了..."
    //                                                    message:notMess
    //                                                   delegate:self
    //                                          cancelButtonTitle:@"暂不了"
    //                                          otherButtonTitles:@"现在就去", nil];
    //    [alert show];
    //
    //    // 更新显示的徽章个数
    //    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    //    badge--;
    //    badge = badge >= 0 ? badge : 0;
    //    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
}
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //    self.isZanbu = YES;
    //    if (buttonIndex == 1) {
    //        // 在不需要再推送时，可以取消推送
    //        [Version cancelLocalNotification];
    //        NSURL *url = [NSURL URLWithString:XiaZaiConnent];
    //        [[UIApplication sharedApplication] openURL:url];
    //    }
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    //  NSLog(@"程序要退出了112");

    // [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication*)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    //  NSLog(@"程序要退出了");
}


- (void)application:(UIApplication*)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{

    // Required
    NSLog(@"deviceToken  %@", deviceToken);

    
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // NSLog(@"ERROR   %@",error);
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{

}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{

}

@end
