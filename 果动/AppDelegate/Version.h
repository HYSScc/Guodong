//
//  Version.h
//  果动
//
//  Created by mac on 15/9/8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Version : UIViewController
+ (void)registerLocalNotification:(NSInteger)alertTime;
+ (void)cancelLocalNotification;
+(void)onCheckVersion;
@end
