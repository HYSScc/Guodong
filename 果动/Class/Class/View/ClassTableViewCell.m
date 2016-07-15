//
//  ClassTableViewCell.m
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ClassTableViewCell.h"

@implementation ClassTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor = BASECOLOR;
        self.baseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                           0,
                                                                           viewWidth,
                                                                           Adaptive(120))];
        self.baseImageView.backgroundColor = BASEGRYCOLOR;
        [self addSubview:self.baseImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(13),
                                                                    Adaptive(13),
                                                                    viewWidth / 2,
                                                                    Adaptive(25))];
        self.titleLabel.font = [UIFont fontWithName:FONT_BOLD size:Adaptive(22.5)];
        self.titleLabel.text = @"核心康复";
        self.titleLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        
        
        self.classNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(13),
                                                                          CGRectGetMaxY(self.titleLabel.frame) +Adaptive(5),
                                                                          viewWidth / 2,
                                                                          Adaptive(15))];
        self.classNumberLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
        self.classNumberLabel.text = @"24节课被预定";
        self.classNumberLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.classNumberLabel];
        
        
        self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(60))];
        self.moreLabel.textAlignment = 1;
        self.moreLabel.textColor     = [UIColor grayColor];
        self.moreLabel.font          = [UIFont fontWithName:FONT size:Adaptive(18)];
        
        [self addSubview:self.moreLabel];
        
    }
    return self;
}

@end


@implementation LeftLastCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor = BASECOLOR;
        self.moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(20))];
        self.moreLabel.textAlignment = 1;
        self.moreLabel.textColor     = [UIColor grayColor];
        self.moreLabel.font          = [UIFont fontWithName:FONT size:Adaptive(10)];
        self.moreLabel.text          = @"更多课程研发中...";
        [self addSubview:self.moreLabel];
        
    }
    return self;
}

@end
