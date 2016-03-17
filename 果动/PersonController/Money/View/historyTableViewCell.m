//
//  historyTableViewCell.m
//  果动
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "historyTableViewCell.h"

@implementation historyTableViewCell

// 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = BASECOLOR;
        
        self.historyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.historyBtn.frame = CGRectMake((viewWidth - (viewWidth / 3)) / 2, Adaptive(40) / 2, viewWidth/3, Adaptive(20));
        [self.historyBtn setTintColor:[UIColor lightGrayColor]];
        [self.historyBtn setTitle:@"查看使用记录" forState:UIControlStateNormal];
        [self addSubview:self.historyBtn];
        
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth - (viewWidth / 3)) / 2, CGRectGetMaxY(self.historyBtn.frame), viewWidth/3, .5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
}
    return self;
}

@end
