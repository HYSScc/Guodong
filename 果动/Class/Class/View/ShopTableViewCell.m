//
//  ShopTableViewCell.m
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ShopTableViewCell.h"

@implementation ShopTableViewCell
// 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // 把自定义的控件 变成了单元格的属性
        self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, Adaptive(10), viewWidth, Adaptive(130))];
        [self addSubview:self.backgroundImageView];
        
        self.alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.backgroundImageView.frame) - Adaptive(42), viewWidth, Adaptive(42))];
        self.alphaView.backgroundColor = [UIColor blackColor];
        self.alphaView.alpha = .8;
        [self addSubview:self.alphaView];
        
        self.titleName = [[UILabel alloc] init];
        self.titleName.textColor = [UIColor orangeColor];
        self.titleName.font = [UIFont fontWithName:FONT size:Adaptive(17)];
        [self.alphaView addSubview:self.titleName];
        
        self.branchName = [[UILabel alloc] init];
        self.branchName.textColor = [UIColor whiteColor];
        self.branchName.font = [UIFont fontWithName:FONT size:Adaptive(15)];
        [self.alphaView addSubview:self.branchName];
    }
    return self;
}

@end
