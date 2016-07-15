//
//  RefushView.m
//  果动
//
//  Created by mac on 16/6/27.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "RefushView.h"

@implementation RefushView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame = frame;
        
        
        UIImageView *imageView = [UIImageView new];
        imageView.frame        = CGRectMake(0,
                                            Adaptive(50),
                                            Adaptive(295),
                                            Adaptive(360));
        imageView.image        = [UIImage imageNamed:@"app_refush"];
        
        [self addSubview:imageView];
        
        
        UIImageView *cancelImageView = [UIImageView new];
        cancelImageView.frame        = CGRectMake(Adaptive(275), Adaptive(15), Adaptive(20), Adaptive(20));
        cancelImageView.image        = [UIImage imageNamed:@"app_remove"];
        [self addSubview:cancelImageView];
        
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelButton.frame = CGRectMake(Adaptive(270), Adaptive(15), Adaptive(30), Adaptive(30));
        [self addSubview:_cancelButton];
        
        
        UIButton *refushButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        refushButton.frame     = CGRectMake((self.bounds.size.width - Adaptive(123)) / 2, Adaptive(320), Adaptive(123), Adaptive(32));
        [refushButton addTarget:self action:@selector(refushButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:refushButton];
        
    }
    return self;
}

- (void)refushButtonClick:(UIButton *)button {
    NSString *iTunesLink = XiaZaiConnent;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
}

@end
