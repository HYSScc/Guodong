//
//  NewsCollectionViewCell.m
//  果动
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "NewsCollectionViewCell.h"

@implementation NewsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        
    }
    return self;
}

- (void)createUI {
    
    self.backgroundColor = ORANGECOLOR;
    
    _headerImage       = [UIImageView new];
    _headerImage.image = [UIImage imageNamed:@"person_nohead"];
    _headerImage.frame = CGRectMake(Adaptive(3), Adaptive(3), Adaptive(30), Adaptive(30));
    [self addSubview:_headerImage];
    
    _nameLabel       = [UILabel new];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headerImage.frame) + Adaptive(10),
                                  Adaptive(5),
                                  Adaptive(150),
                                  Adaptive(30));
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    _nameLabel.text      = @"Midsummer";
    [self addSubview:_nameLabel];
    
    _contentImage       = [UIImageView new];
    _contentImage.image = [UIImage imageNamed:@"news_result"];
    _contentImage.frame = CGRectMake(0,
                                     CGRectGetMaxY(_headerImage.frame) + Adaptive(5),
                                     self.bounds.size.width,
                                     Adaptive(167));
    [self addSubview:_contentImage];
    
    _contentLabel       = [UILabel new];
    _contentLabel.frame = CGRectMake(0,
                                     CGRectGetMaxY(_contentImage.frame) + Adaptive(5),
                                     self.bounds.size.width,
                                     Adaptive(20));
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    _contentLabel.text      = @"TRX训练中，教练非常专业";
    [self addSubview:_contentLabel];
    
    
    
    
}
@end
