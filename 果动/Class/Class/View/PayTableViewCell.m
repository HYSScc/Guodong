//
//  PayTableViewCell.m
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "PayTableViewCell.h"

@implementation PayTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = BASECOLOR;
        
        _ringImageView       = [UIImageView new];
        _ringImageView.frame = CGRectMake(0, Adaptive(14), Adaptive(12), Adaptive(12));
        [self addSubview:_ringImageView];
        
        _kuangImageView       = [UIImageView new];
        _kuangImageView.frame = CGRectMake(CGRectGetMaxX(_ringImageView.frame) + Adaptive(10),
                                           0,
                                           Adaptive((300 - 10)) - CGRectGetMaxX(_ringImageView.frame),
                                           Adaptive(40));
        [self addSubview:_kuangImageView];
        
        _contentLabel       = [UILabel new];
        _contentLabel.frame = CGRectMake(CGRectGetMinX(_kuangImageView.frame) + Adaptive(5),
                                         0,
                                         Adaptive(150),
                                         Adaptive(40));
        _contentLabel.font  = [UIFont fontWithName:FONT size:Adaptive(16)];
        [self addSubview:_contentLabel];
        
        _remarkLabel       = [UILabel new];
        _remarkLabel.frame = CGRectMake(Adaptive(172), 0, Adaptive(123), Adaptive(40));
        _remarkLabel.textAlignment = 2;
        _remarkLabel.textColor     = ORANGECOLOR;
        _remarkLabel.font          = [UIFont fontWithName:FONT size:Adaptive(12)];
        [self addSubview:_remarkLabel];
        
    }
    return self;
}

@end
