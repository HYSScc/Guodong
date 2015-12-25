//
//  LXActivity.h
//  LXActivityDemo
//
//  Created by lixiang on 15-3-17.
//  Copyright (c) 2014年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCheckBox.h"
@protocol LXActivityDelegate <NSObject>

- (void)didClickOnImageIndex:(int )imageIndex ;
@optional
- (void)didClickOnCancelButton;
@end

@interface LXActivity : UIView<QCheckBoxDelegate>

- (id)initWithTitle:(NSString *)title time:(NSString *)time delegate:(id<LXActivityDelegate>)delegate discont:(NSString *)discont youhuijuan:(NSString*)youhuijuan classNumber:(NSString *)classnumber isFirst:(NSString *)isFirst cancelButtonTitle:(NSString *)cancelButtonTitle ShareButtonTitles:(NSArray *)shareButtonTitlesArray withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray;
- (void)showInView:(UIView *)view;

@end
