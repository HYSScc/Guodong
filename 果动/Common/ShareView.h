//
//  ShareView.h
//  果动
//
//  Created by mac on 16/6/27.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"

#import <UIKit/UIKit.h>

@interface ShareView : UIView 

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(UIImage *)image url:(NSString *)url id:(NSString *)id_string shareType:(NSString *)share viewController:(UIViewController *)controller;

@end
