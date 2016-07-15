//
//  DetailsLikeView.h
//  果动
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContentDetails;

@interface DetailsLikeView : UIView

- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController*)controller;

@property (nonatomic,retain) ContentDetails *details;

@end
