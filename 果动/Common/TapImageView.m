//
//  TapImageView.m
//  图片点击放大滑动
//
//  Created by mac on 16/6/28.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "TapImageView.h"

@implementation TapImageView

- (void)dealloc
{
    _tap_delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Tappend:)];
        [self addGestureRecognizer:tap];
        
        self.clipsToBounds = YES;
        self.contentMode   = UIViewContentModeScaleAspectFill;
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)Tappend:(UIGestureRecognizer *)gesture {
    NSLog(@"点击图片");
    if ([self.tap_delegate respondsToSelector:@selector(tappendWithObject:)]) {
        [self.tap_delegate tappendWithObject:self];
    }
}


@end
