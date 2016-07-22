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
    
    self.backgroundColor = BASECOLOR;
    
    UILabel *gryLabel = [UILabel new];
    gryLabel.frame    = CGRectMake(0, 0, self.bounds.size.width, Adaptive(10));
    gryLabel.backgroundColor = BASECOLOR;
    [self addSubview:gryLabel];
    
    
    _headerImage       = [UIImageView new];
    _headerImage.image = [UIImage imageNamed:@"person_nohead"];
    _headerImage.frame = CGRectMake(Adaptive(3),CGRectGetMaxY(gryLabel.frame) + Adaptive(3), Adaptive(30), Adaptive(30));
    _headerImage.layer.cornerRadius  = _headerImage.bounds.size.width / 2;
    _headerImage.layer.masksToBounds = YES;
   
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
    
    _contentImage.contentMode = UIViewContentModeScaleAspectFit;
    _contentImage.frame = CGRectMake(0,
                                     CGRectGetMaxY(_headerImage.frame) + Adaptive(5),
                                     self.bounds.size.width,
                                     Adaptive(167));
    [self addSubview:_contentImage];
    
    _contentLabel       = [UILabel new];
    _contentLabel.frame = CGRectMake(Adaptive(5),
                                     CGRectGetMaxY(_contentImage.frame) + Adaptive(5),
                                     self.bounds.size.width,
                                     Adaptive(20));
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    _contentLabel.text      = @"TRX训练中，教练非常专业";
    [self addSubview:_contentLabel];
    
    
    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _likeButton.frame     = CGRectMake(Adaptive(5),
                                      CGRectGetMaxY(_contentLabel.frame) + Adaptive(5),
                                      Adaptive(17),
                                      Adaptive(17));
    
    [_likeButton setImage:[UIImage imageNamed:@"find_nolike"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"find_like"] forState:UIControlStateSelected];
    [self addSubview:_likeButton];
    
    _likeLabel           = [UILabel new];
    _likeLabel.textColor = [UIColor lightGrayColor];
    _likeLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    _likeLabel.frame     = CGRectMake(CGRectGetMaxX(_likeButton.frame) + Adaptive(5),
                                      CGRectGetMinY(_likeButton.frame) + Adaptive(1),
                                      Adaptive(30),
                                      Adaptive(17));
    [self addSubview:_likeLabel];
    
    UIImageView *commentImageView = [UIImageView new];
    commentImageView.image        = [UIImage imageNamed:@"find_comment"];
    commentImageView.frame        = CGRectMake(CGRectGetMaxX(_likeLabel.frame) + Adaptive(3),
                                               CGRectGetMinY(_likeButton.frame) + Adaptive(1),
                                               Adaptive(17),
                                               Adaptive(17));
    [self addSubview:commentImageView];
    
    
    _commentLabel           = [UILabel new];
    _commentLabel.textColor = [UIColor lightGrayColor];
    _commentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    _commentLabel.frame     = CGRectMake(CGRectGetMaxX(commentImageView.frame) + Adaptive(5),
                                      CGRectGetMinY(_likeButton.frame) + Adaptive(1),
                                      Adaptive(30),
                                      Adaptive(17));
    [self addSubview:_commentLabel];
    
}

@end
