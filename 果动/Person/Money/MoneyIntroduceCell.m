//
//  MoneyIntroduceCell.m
//  果动
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "MoneyIntroduceModel.h"
#import "MoneyIntroduceCell.h"

@implementation MoneyIntroduceCell
{
    UILabel *title;
    UILabel *content;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
    
        self.backgroundColor = BASEGRYCOLOR;
        
        title = [UILabel new];
        title.font = [UIFont fontWithName:FONT_BOLD size:Adaptive(16)];
        title.textColor = [UIColor whiteColor];
        title.numberOfLines = 0;
        [self addSubview:title];
        
        
        content = [UILabel new];
        content.font = [UIFont fontWithName:FONT size:Adaptive(14)];
        content.textColor = [UIColor whiteColor];
        content.numberOfLines = 0;
        [self addSubview:content];
        
        
    }
    return self;
}

- (void)setIntroduce:(MoneyIntroduceModel *)introduce {
    
    
    CGSize titleSize = [introduce.title boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_BOLD size:Adaptive(17)]} context:nil].size;
    title.frame = CGRectMake(Adaptive(13),
                             Adaptive(13),
                             viewWidth - Adaptive(26),
                             titleSize.height);
    title.text = introduce.title;
    
    CGSize contentSize = [introduce.content boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]} context:nil].size;
    content.frame = CGRectMake(Adaptive(13),
                           CGRectGetMaxY(title.frame) + Adaptive(13),
                             viewWidth - Adaptive(26),
                             contentSize.height);
    content.text = introduce.content;
    
    
    UILabel *line = [UILabel new];
    line.frame    = CGRectMake(Adaptive(13),
                               CGRectGetMaxY(content.frame) + Adaptive(13),
                               viewWidth - Adaptive(26),
                               .5);
    line.backgroundColor = BASECOLOR;
    [self addSubview:line];
    
    
    CGRect cellFrame = self.frame;
    cellFrame.size.height = CGRectGetMaxY(line.frame);
    self.frame = cellFrame;
    
}

@end
