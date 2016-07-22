//
//  MoneyTableViewCell.m
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MoneyTableViewCell.h"

#import "MoneyModel.h"

@implementation MoneyTableViewCell
{
    UILabel *statusLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.baseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(13),
                                                                           0,
                                                                           viewWidth - Adaptive(26),
                                                                           Adaptive(100))];
        [self addSubview:self.baseImageView];
        
        self.moneyLabel           = [UILabel new];
        self.moneyLabel.textColor = [UIColor blackColor];
        [self addSubview:self.moneyLabel];
        
        
        _leftLine  = [UILabel new];
        [self addSubview:_leftLine];
        
        _rightLine  = [UILabel new];
        [self addSubview:_rightLine];
        
        
        self.nameLabel           = [UILabel new];
        self.nameLabel.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:self.nameLabel];
        
        
        
        self.dateLabel           = [UILabel new];
        self.dateLabel.textColor = [UIColor blackColor];
        self.dateLabel.font      = [UIFont fontWithName:FONT size:Adaptive(10)];
        self.dateLabel.textAlignment = 1;
        [self addSubview:self.dateLabel];
        
        self.contentLabel       = [UILabel new];
        self.contentLabel.font  = [UIFont fontWithName:FONT size:Adaptive(10)];
        self.contentLabel.textColor       = [UIColor blackColor];
        self.contentLabel.numberOfLines   = 0;
        self.contentLabel.textAlignment   = 1;
        [self addSubview:self.contentLabel];
        
        
        statusLabel       = [UILabel new];
        statusLabel.font  = [UIFont fontWithName:FONT size:Adaptive(10)];
        statusLabel.textColor = [UIColor lightGrayColor];
        // statusLabel.backgroundColor = [UIColor orangeColor];
        statusLabel.textAlignment = 1;
        [self addSubview:statusLabel];
        
    }
    return self;
}


- (void)setMoneyModel:(MoneyModel *)moneyModel {
    
    _moneyLabel.frame = CGRectMake(Adaptive(40),
                                   Adaptive(38),
                                   Adaptive(60),
                                   Adaptive(27));
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:moneyModel.money];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(16)] range:NSMakeRange(0,1)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT_BOLD size:Adaptive(26)] range:NSMakeRange(1,moneyModel.money.length - 1)];
    _moneyLabel.textAlignment   = 1;
    _moneyLabel.attributedText  = str;
    
    
    statusLabel.frame = CGRectMake(Adaptive(45),
                                   CGRectGetMaxY(_moneyLabel.frame) + Adaptive(5),
                                   Adaptive(60),
                                   Adaptive(15));
    
    
    _dateLabel.text    = moneyModel.expires;
    _contentLabel.text = moneyModel.inc;
    
    
    CGSize nameLabelSize = [moneyModel.types sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(14)]}];
    
    //    CGFloat nameOriginX  = baseWidth / 3 + ((baseWidth / 3) * 2 - nameLabelSize.width) / 2;
    //    self.nameLabel.frame = CGRectMake(nameOriginX, Adaptive(10), nameLabelSize.width, Adaptive(15));
    
    
    
    _nameLabel.frame = CGRectMake(Adaptive(140),
                                  Adaptive(10),
                                  viewWidth - Adaptive(153),
                                  Adaptive(15));
    _nameLabel.textAlignment = 1;
    _nameLabel.text          = moneyModel.types;
    
    
    _leftLine.frame  = CGRectMake(Adaptive(144),
                                  Adaptive(17),
                                  (viewWidth - Adaptive(153)  - Adaptive(16) - nameLabelSize.width) / 2,
                                  .5);
    _rightLine.frame = CGRectMake(CGRectGetMaxX(_leftLine.frame) + Adaptive(8) + nameLabelSize.width,
                                  Adaptive(17),
                                  (viewWidth - Adaptive(153)  - Adaptive(16) - nameLabelSize.width) / 2,
                                  .5);
    
    _dateLabel.frame    = CGRectMake(Adaptive(155),
                                     CGRectGetMaxY(self.nameLabel.frame) + Adaptive(10),
                                     viewWidth - Adaptive(183),
                                     Adaptive(15));
    _contentLabel.frame = CGRectMake(Adaptive(155),
                                     CGRectGetMaxY(self.dateLabel.frame) + Adaptive(15),
                                     viewWidth - Adaptive(183),
                                     Adaptive(30));
    
    
    //  状态  0 - 正常 1-消费 2-已过期
    
    if ([moneyModel.code intValue] != 0) {
        _baseImageView.image       = [UIImage imageNamed:@"Money_overdue"];
        _leftLine.backgroundColor  = BASECOLOR;
        _rightLine.backgroundColor = BASECOLOR;
        _moneyLabel.textColor      = [UIColor whiteColor];
        
        if ([moneyModel.code intValue] == 2) {
            statusLabel.text = @"已过期";
        }
        if ([moneyModel.code intValue] == 1) {
            statusLabel.text = @"已消费";
        }
        
    } else {
        _baseImageView.image       = [UIImage imageNamed:@"Money_normal"];
        _leftLine.backgroundColor  = ORANGECOLOR;
        _rightLine.backgroundColor = ORANGECOLOR;
        _moneyLabel.textColor      = BASECOLOR;
        
        statusLabel.text = @"";
        
    }
    
}

@end
