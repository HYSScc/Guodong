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
#import "Pingpp.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>

#import "PushView.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialSinaSSOHandler.h"
#import "UMSocialQQHandler.h"
static BOOL isProduction = FALSE;

@interface AppDelegate ()<CLLocationManagerDelegate> {
    
    CLLocationManager* _locationManager; // 位置管理器
    UIView            *alphaView;
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
    
    
    /********************** Jpush 推送 ****************************/
    
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    //Required
    [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                      UIUserNotificationTypeSound |
                                                      UIUserNotificationTypeAlert)
                                          categories:nil];
    
    [JPUSHService setupWithOption:launchOptions appKey:JpushAppKey
                          channel:@"Publish channel"
                 apsForProduction:isProduction
            advertisingIdentifier:advertisingId];
    
    /********************** Umeng分享 ****************************/
    
    [UMSocialData setAppKey:@"577093fb67e58ecad30005f7"];
    [UMSocialWechatHandler setWXAppId:@"wx08ccee47de273546" appSecret:@"e4ef82d0d1fa5d16e33ca4b48c138ab5" url:@"http://www.baidu.com"];
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"1965248745" secret:@"ae17ab80d250a7e9fe68ee34eace94a8" RedirectURL:@"http://www.baidu.com"];
    [UMSocialQQHandler setQQWithAppId:@"1105528146" appKey:@"43P0R3RyDEloUyFh" url:@"http://www.baidu.com"];
    
    
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

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary *)options {
    
    
    NSLog(@"app %@ url %@ options %@",app,url,options);
    
    BOOL result = [UMSocialSnsService handleOpenURL:url];
    if (result == FALSE) {
        //调用其他SDK，例如支付宝SDK等
        
        BOOL canHandleURL = [Pingpp handleOpenURL:url withCompletion:nil];
        return canHandleURL;
    } else {
        return result;
    }
    
    
}


- (void)application:(UIApplication*)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    
    // NSLog(@"regusterId %@",[JPUSHService registrationID]);
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    // NSLog(@"ERROR   %@",error);
}
- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo
{
    // JPush
    [JPUSHService handleRemoteNotification:userInfo];
}

- (void)application:(UIApplication*)application didReceiveRemoteNotification:(NSDictionary*)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    /*
     aps =     {
     alert = "\U8fd0\U52a8\U5185\U5bb9\U53ca\U5f3a\U5ea6\U5efa\U8bae";
     badge = 1;
     sound = default;
     };
     img = "http://192.168.1.90:8080/img/pic_folder/notice/panda1_WJ5CDjg.png";
     type = hold;[userInfo objectForKey:@"img"]
     */
    
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"complet.userInfo %@",userInfo);
    
    // NSDictionary *userInfo = [];
    
    if ([[userInfo objectForKey:@"type"] isEqualToString:@"hold"]) {
        
        
        
        CGFloat width  = [[userInfo objectForKey:@"width"] floatValue];
        CGFloat height = [[userInfo objectForKey:@"height"] floatValue];
        
        NSString *title = [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        
        PushView *push = [[PushView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight) image:[userInfo objectForKey:@"img"] imageWidth:width height:height title:title];
        [self .window addSubview:push];
    } else if ([[userInfo objectForKey:@"type"] isEqualToString:@"else"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        [alert show];
    } else {
        
    }
    
}

@end
