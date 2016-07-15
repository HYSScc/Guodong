//
//  ClassView.h
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface ClassView : UIView

@property (nonatomic,retain) HomeModel *home;

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)controller;

@end
