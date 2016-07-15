//
//  textFrameView.m
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "textFrameView.h"

@implementation textFrameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        self.backgroundColor = [UIColor colorWithRed:70/255.0
                                                      green:70/255.0
                                                       blue:70/255.0
                                                      alpha:1];
    }
    return self;
}

- (void)createUI {
    UIView *textBlackView = [UIView new];
    textBlackView.frame   = CGRectMake(Adaptive(3),
                                       Adaptive(3),
                                       self.bounds.size.width - Adaptive(6),
                                       self.bounds.size.height - Adaptive(6));
    textBlackView.backgroundColor = BASECOLOR;
    [self addSubview:textBlackView];
    
    
    UIView *textSmallGryView = [UIView new];
    textSmallGryView.frame   = CGRectMake(Adaptive(2),
                                          Adaptive(2),
                                          textBlackView.bounds.size.width - Adaptive(4),
                                          textBlackView.bounds.size.height - Adaptive(4));
    textSmallGryView.backgroundColor = [UIColor colorWithRed:70/255.0
                                                       green:70/255.0
                                                        blue:70/255.0
                                                       alpha:1];
    [textBlackView addSubview:textSmallGryView];
    
    _textSmallBlackView = [UIView new];
    _textSmallBlackView.frame   = CGRectMake(Adaptive(1), Adaptive(1),
                                            textSmallGryView.bounds.size.width - Adaptive(2),
                                            textSmallGryView.bounds.size.height - Adaptive(2));
    _textSmallBlackView.backgroundColor = BASECOLOR;
    [textSmallGryView addSubview:_textSmallBlackView];

}
@end
