//
//  PictureTableViewCell.m
//  果动
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "PictureTableViewCell.h"

@implementation PictureTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = [UIColor colorWithRed:55/255.0
                                               green:55/255.0
                                                blue:55/255.0
                                               alpha:1];
        
        self.titleImageView       = [UIImageView new];
        self.titleImageView.frame = CGRectMake(Adaptive(13), Adaptive(13), viewWidth -Adaptive(26), Adaptive(150));
        [self addSubview:self.titleImageView];
        
        self.titleLabel       = [UILabel new];
        self.titleLabel.frame = CGRectMake(Adaptive(13),
                                           CGRectGetMaxY(self.titleImageView.frame) + Adaptive(15),
                                           viewWidth - Adaptive(26),
                                           Adaptive(18));
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font      = [UIFont fontWithName:FONT_BOLD size:Adaptive(17)];
        [self addSubview:self.titleLabel];
        
        self.contentLabel       = [UILabel new];
        self.contentLabel.frame = CGRectMake(Adaptive(13),
                                             CGRectGetMaxY(self.titleLabel.frame) + Adaptive(15),
                                             viewWidth - Adaptive(26),
                                             Adaptive(13));
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
        [self addSubview:self.contentLabel];
        
        UILabel *line = [UILabel new];
        line.backgroundColor = BASECOLOR;
        line.frame    = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame) + Adaptive(15),
                                   viewWidth, Adaptive(10));
        [self addSubview:line];
        
        
    }
    return self;
}


@end
