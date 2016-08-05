//
//  RechargeCell.m
//  果动
//
//  Created by mac on 16/7/6.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "RechargeCell.h"

@implementation RechargeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = BASECOLOR;
        
        _clickImageView       = [UIImageView new];
        _clickImageView.frame = CGRectMake(Adaptive(13),
                                           Adaptive(5),
                                           Adaptive(12),
                                           Adaptive(12));
        _clickImageView.image = [UIImage imageNamed:@"pay_ring_orange"];
        [self addSubview:_clickImageView];
        
        _titleLabel       = [UILabel new];
        _titleLabel.frame = CGRectMake(CGRectGetMaxX(_clickImageView.frame) + Adaptive(17),
                                       CGRectGetMinY(_clickImageView.frame) - Adaptive(3),
                                       viewWidth - Adaptive(74),
                                       Adaptive(18));
      //  _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = ORANGECOLOR;
        _titleLabel.font      = [UIFont fontWithName:FONT_BOLD size:Adaptive(17)];
        _titleLabel.text      = @"特享套餐";
        [self addSubview:_titleLabel];
        
        _priceLabel       = [UILabel new];
        _priceLabel.frame = CGRectMake(CGRectGetMinX(_titleLabel.frame),
                                       CGRectGetMaxY(_titleLabel.frame) + Adaptive(5),
                                       _titleLabel.bounds.size.width *0.5,
                                       Adaptive(16));
        _priceLabel.textColor = [UIColor orangeColor];
        _priceLabel.font  = [UIFont fontWithName:FONT size:Adaptive(15)];
        _priceLabel.text = @"充值 3000元";
        [self addSubview:_priceLabel];
        
        _classNumberLabel       = [UILabel new];
        _classNumberLabel.frame = CGRectMake(CGRectGetMaxX(_priceLabel.frame),
                                             CGRectGetMaxY(_titleLabel.frame) + Adaptive(5),
                                              _titleLabel.bounds.size.width *0.5,
                                             Adaptive(16));
        _classNumberLabel.font  = [UIFont fontWithName:FONT size:Adaptive(15)];
        _classNumberLabel.text  = @"含55课时";
        [self addSubview:_classNumberLabel];
        
    }
    return self;
}


@end
