//
//  TapImageView.h
//  图片点击放大滑动
//
//  Created by mac on 16/6/28.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TapImageViewDelegate <NSObject>

- (void)tappendWithObject:(id)sender;


@end


@interface TapImageView : UIImageView

@property (weak) id<TapImageViewDelegate> tap_delegate;

@end
