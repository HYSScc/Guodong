//
//  News_systemCell.m
//  果动
//
//  Created by mac on 16/5/30.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "News_systemCell.h"

@implementation News_systemCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor = [UIColor colorWithRed:55/255.0
                                               green:55/255.0
                                                blue:55/255.0
                                               alpha:1];
        
        self.titleLabel       = [UILabel new];
        self.titleLabel.frame = CGRectMake(Adaptive(13),
                                           Adaptive(13),
                                           viewWidth - Adaptive(26),
                                           Adaptive(20));
        self.titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        UILabel *line = [UILabel new];
        line.frame    = CGRectMake(Adaptive(13),
                                   CGRectGetMaxY(self.titleLabel.frame) + Adaptive(13),
                                   viewWidth - Adaptive(26),
                                   .5);
        line.backgroundColor = BASECOLOR;
        [self addSubview:line];
        
        self.contentLabel       = [UILabel new];
        self.contentLabel.frame = CGRectMake(Adaptive(13),
                                             CGRectGetMaxY(line.frame) + Adaptive(9),
                                             viewWidth - Adaptive(26),
                                             Adaptive(30));
        self.contentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        self.contentLabel.textColor = [UIColor grayColor];
        self.contentLabel.numberOfLines = 0;
        [self addSubview:self.contentLabel];

        self.sepatateLabel = [UILabel new];
        
        self.sepatateLabel.backgroundColor = BASECOLOR;
        [self addSubview:self.sepatateLabel];
        
    }
    return self;
}
@end
