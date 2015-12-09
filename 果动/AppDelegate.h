//
//  AppDelegate.h
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import <ShareSDK/ShareSDK.h>
//#import "WeiboSDK.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (copy  , nonatomic)void(^arrayblock)(void);
@property (copy  , nonatomic)void(^arrayblock1)(void);
@property (nonatomic,assign) BOOL isVersion;
@property (nonatomic,assign) BOOL isZanbu;
@property (strong, nonatomic) UINavigationController *viewController;

@property (strong, nonatomic)NSMutableArray *scrimgArray;
@property (copy  , nonatomic)void(^block)(NSString *string);
@end

