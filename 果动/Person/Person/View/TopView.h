//
//  TopView.h
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "ImgScrollerView.h"
#import "TapImageView.h"
#import <UIKit/UIKit.h>

@interface TopView : UIView<TapImageViewDelegate,ImgScrollViewDelegate,UIScrollViewDelegate>

@property (nonatomic,retain) TapImageView *headImageView;
@property (nonatomic,retain) UILabel     *nameLabel;


@end
