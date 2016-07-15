//
//  MyDairyUserCell.m
//  果动
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "MyDairyModel.h"
#import "MyDairyUserCell.h"

@implementation MyDairyUserCell
{
    UILabel *userContent;
    UILabel  *verticalLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor = BASECOLOR;
        
        verticalLine = [UILabel new];
        verticalLine.backgroundColor = ORANGECOLOR;
        [self addSubview:verticalLine];
        
        
        
        userContent       = [UILabel new];
        userContent.textColor = [UIColor colorWithRed:25/255.0 green:155/255.0 blue:127/255.0 alpha:1];
        userContent.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        userContent.numberOfLines = 0;
        [self addSubview:userContent];
        
        
        _addUserButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        [_addUserButton setBackgroundImage:[UIImage imageNamed:@"MyDairy_add"] forState:UIControlStateNormal];
        [self addSubview:_addUserButton];
    }
    return self;
}

- (void)setDairy:(MyDairyModel *)dairy {
    
    NSString *contentString = [NSString stringWithFormat:@"我: %@",dairy.userContent];
    
    CGSize textSize = [contentString boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(65.5), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(14)]} context:nil].size;
    int numberOfLine  = (floor)((textSize.height) / (Adaptive(15)));
    
    userContent.frame = CGRectMake(Adaptive(31),
                                   Adaptive(9),
                                   viewWidth - Adaptive(65.5),
                                   textSize.height + Adaptive(10)*numberOfLine);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:contentString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:Adaptive(10)];//调整行间距
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentString.length)];
    userContent.attributedText = str;
    [userContent sizeToFit];
    
    
    
    
    for (int a = 0; a < numberOfLine; a++) {
        UILabel *line = [UILabel new];
        line.frame    = CGRectMake(Adaptive(31),
                                   (CGRectGetMinY(userContent.frame) + Adaptive(19)) + (Adaptive((10 + 15.5)) * a),
                                   viewWidth - Adaptive(65.5),
                                   .5);
        line.tag = a + 1;
        line.backgroundColor = BASEGRYCOLOR;
        [self addSubview:line];
    }
    
    UILabel *line        = (UILabel *)[self viewWithTag:numberOfLine];
    _addUserButton.frame = CGRectMake(viewWidth - Adaptive(27.5),
                                      CGRectGetMaxY(line.frame) - Adaptive(17.5),
                                      Adaptive(14.5),
                                      Adaptive(17.5));

    
    CGRect Frame = self.frame;
    
    
    verticalLine.frame = CGRectMake(Adaptive(18.5),
                                    0,
                                    1,
                                    CGRectGetMaxY(userContent.frame) + Adaptive(23));
    
    
    Frame.size.height =  CGRectGetMaxY(verticalLine.frame);
    self.frame = Frame;
    
}
@end
