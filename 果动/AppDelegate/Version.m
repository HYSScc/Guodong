//
//  Version.m
//  果动
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "AppDelegate.h"
#import "Commonality.h"
#import "Version.h"
@interface Version () <UIAlertViewDelegate>

@end

@implementation Version

- (void)viewDidLoad
{
    [super viewDidLoad];
}
+ (void)onCheckVersion
{
    NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDic));

    NSString* appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    NSLog(@"当前版本号 %@", appVersion);

    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:CHECKURL]];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse* urlResponse = nil;
    NSError* error = nil;
    NSData* recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    NSString* results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSData* data = [results dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray* infoArray = [dict objectForKey:@"results"];
    if ([infoArray count]) {
        NSDictionary* releaseInfo = [infoArray objectAtIndex:0];
        NSString* appStoreVersion = [releaseInfo objectForKey:@"version"];
        //  NSString *appStoreVersion = @"1";
        NSLog(@"appStore的版本号 %@", appStoreVersion);
        if (![appStoreVersion isEqualToString:appVersion]) {
            AppDelegate* app = [UIApplication sharedApplication].delegate;
            app.isVersion = YES;
        }
        else {
            NSLog(@"版本一致,无更新");
        }
    }
}

// 设置本地通知
+ (void)registerLocalNotification:(NSInteger)alertTime
{
    UILocalNotification* notification = [[UILocalNotification alloc] init];
    // 设置触发通知的时间
    NSDate* fireDate = [NSDate dateWithTimeIntervalSinceNow:alertTime];
    NSLog(@"fireDate=%@", fireDate);

    notification.fireDate = fireDate;
    // 时区
    notification.timeZone = [NSTimeZone defaultTimeZone];
    // 设置重复的间隔
    notification.repeatInterval = NSCalendarUnitMinute;
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    app.isZanbu = NO;
    // 通知内容
    notification.alertBody = @"果动有新版本发布了...";
    notification.applicationIconBadgeNumber = 1;
    // 通知被触发时播放的声音
    notification.soundName = UILocalNotificationDefaultSoundName;
    // 通知参数
    NSDictionary* userDict = [NSDictionary dictionaryWithObject:@"是否前往更新..." forKey:@"key"];
    notification.userInfo = userDict;

    // ios8后，需要添加这个注册，才能得到授权
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSCalendarUnitDay;
    }
    else {
        // 通知重复提示的单位，可以是天、周、月
        notification.repeatInterval = NSDayCalendarUnit;
    }

    // 执行通知注册
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
// 取消某个本地推送通知
+ (void)cancelLocalNotification
{
    NSLog(@"取消通知");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
@end
