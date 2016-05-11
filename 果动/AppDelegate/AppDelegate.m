//
//  AppDelegate.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "APService.h"
#import "AppDelegate.h"
#import "AppraiseViewController.h"

#import "HomeController.h"
#import "LoginViewController.h"
#import "MainController.h"
#import "RegisterViewController.h"
#import "OrderFormController.h"
#import "Pingpp.h"
#import "WXApi.h"
#import "WeiboSDK.h"
#import <Bugly/CrashReporter.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>
#import <ShareSDK/ShareSDK.h>

#import "NewsViewController.h"






@interface AppDelegate () <UIAlertViewDelegate, CLLocationManagerDelegate> {
    //位置管理器
    CLLocationManager* _locationManager;
}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions
{

    self.isZanbu = NO;

    //定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    //如果没有授权则请求用户授权
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [ShareSDK registerApp:@"55654a1c4ac0"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台

    [ShareSDK connectSinaWeiboWithAppKey:@"1965248745"
                               appSecret:@"ae17ab80d250a7e9fe68ee34eace94a8"
                             redirectUri:@"http://www.baidu.com"];

    [ShareSDK connectWeChatWithAppId:@"wx08ccee47de273546" //微信APPID
                           appSecret:@"e4ef82d0d1fa5d16e33ca4b48c138ab5" //微信APPSecret
                           wechatCls:[WXApi class]];

    NSString* key = (NSString*)kCFBundleVersionKey;

    NSString* version = [NSBundle mainBundle].infoDictionary[key];

    NSString* saveVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];

 
    if ([version isEqualToString:saveVersion]) {
        
        

        MainController* main = [MainController new];
        self.window.rootViewController = main;

        //  NewsViewController *news = [NewsViewController new];
        //  self.window.rootViewController = news;

        //  AppraiseViewController *app = [AppraiseViewController new];
        //  self.window.rootViewController = app;
    }
    else {

        [[NSUserDefaults standardUserDefaults] setObject:version forKey:key];

        [[NSUserDefaults standardUserDefaults] synchronize];

        self.window.rootViewController = [RegisterViewController new];
        //self.window.rootViewController = [LoginViewController new];
    }

    [self.window makeKeyAndVisible];

// Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
    
    /**
     *  崩溃日志
     */
     [[CrashReporter sharedInstance] enableLog:YES];
    
     [[CrashReporter sharedInstance] installWithAppId:@"900019609"];
    
    
    
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
    NSLog(@"进软件发请求");
    NSString* url = [NSString stringWithFormat:@"%@api/?method=user.notice", BASEURL];
    [HttpTool POST:url parameters:nil success:^(AFHTTPRequestOperation* operation, id responseObject) {

        if (ResponseObject_RC == 0) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            if ([[data objectForKey:@"status"] intValue] == 1) {
                NSString* order_id = [data objectForKey:@"order_id"];
                NSString* coach_id = [data objectForKey:@"coach_id"];
                AppraiseViewController* app = [AppraiseViewController new];
                app.order_id = order_id;
                app.coach_id = coach_id;
                NSLog(@"order_id  %@  coach_id  %@", order_id, coach_id);
                self.window.rootViewController = app;
            }
        }
    }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
        }];

    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
   
}

- (void)applicationDidBecomeActive:(UIApplication*)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication*)application
{
    //  NSLog(@"程序要退出了");
}

- (BOOL)application:(UIApplication*)application handleOpenURL:(NSURL*)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication*)application openURL:(NSURL*)url sourceApplication:(NSString*)sourceApplication annotation:(id)annotation
{

    [Pingpp handleOpenURL:url withCompletion:^(NSString* result, PingppError* error) {
        // result : success, fail, cancel, invalid
        NSLog(@"result   %@", result);
        self.window.rootViewController = [MainController new];
        //29  23  13
    }];
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}
- (void)application:(UIApplication*)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{

    // Required
    NSLog(@"deviceToken  %@", deviceToken);

    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // NSLog(@"ERROR   %@",error);
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{

    [APService handleRemoteNotification:userInfo];
    NSLog(@"userInfo1  %@", userInfo);
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{

    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"userInfo2  %@", userInfo);
    //推送评价
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"upload"]) {
        NSString* coach_id = [userInfo objectForKey:@"coach_id"];
        NSString* order_id = [userInfo objectForKey:@"order_id"];
        AppraiseViewController* app = [AppraiseViewController new];
        app.order_id = order_id;
        app.coach_id = coach_id;
        self.window.rootViewController = app;
    }
    //推送vip次数
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"vip"]) {
        MainController* main = [MainController new];
        main.vip = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        main.status = @"vip";
        self.window.rootViewController = main;
    }
    //推送教练是否接单
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"accept_order"]) {
        MainController* main = [MainController new];

        main.status = @"accept_order";
        main.order_id = [userInfo objectForKey:@"order_id"];
        NSLog(@"main.order_id %@", main.order_id);

        self.window.rootViewController = main;
    }
    //推送无聊的消息
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"else"]) {
        MainController* main = [MainController new];
        main.status = @"else";
        main.elseStr = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        self.window.rootViewController = main;
    }
    
}

@end
