//
//  MingXiTableViewCell.m
//  果动
//
//  Created by mac on 15/6/12.
//  Copyright (c) 2015年 Unique. All rights reserved.
//


#import "MingXiTableViewCell.h"
@implementation MingXiTableViewCell

// 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // 把自定义的控件 变成了单元格的属性

        self.backgroundColor = [UIColor clearColor];

        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - Adaptive(130), Adaptive(10) + 8, Adaptive(130), Adaptive(14))];
        self.titleLabel.text = @"上课次数累计三次";
        self.titleLabel.textAlignment = 1;
        self.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(14)];
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];

        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - Adaptive(125), CGRectGetMaxY(self.titleLabel.frame), Adaptive(130), Adaptive(30))];
        self.timeLabel.text = @"2015-05-06 12:40";
        self.timeLabel.textAlignment = 1;
        self.timeLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
        self.timeLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.timeLabel];

        self.numberImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mingxi_tureimage"]];
        self.numberImage.frame = CGRectMake(Adaptive(20), Adaptive(15), Adaptive(68), Adaptive(40));
        [self addSubview:self.numberImage];

        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.numberImage.frame) + 14.5, viewWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1];
        [self addSubview:line];
        //249  160 68
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(25), Adaptive(5), Adaptive(40), Adaptive(30))];
        self.numberLabel.text = @"80";
        self.numberLabel.textAlignment = 1;
        self.numberLabel.font = [UIFont fontWithName:FONT size:Adaptive(20)];
        self.numberLabel.textColor = [UIColor colorWithRed:226.00 / 255 green:160.00 / 255 blue:48.00 / 255 alpha:1];
        [self.numberImage addSubview:self.numberLabel];

        self.biaozhi = [[UIImageView alloc] init];
        self.biaozhi.frame = CGRectMake(viewWidth - Adaptive(100), Adaptive(10), Adaptive(60), Adaptive(45));
        // self.biaozhi.image = [UIImage imageNamed:@"MingXi_xiaofei"];
        [self addSubview:self.biaozhi];
    }
    return self;
}

@end
