//
//  addCoachCollectCell.m
//  果动
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 Unique. All rights reserved.
//
#define colletionCellNumber 4
#import "addCoachCollectCell.h"

@implementation addCoachCollectCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _coachChooseView       = [UIImageView new];
        _coachChooseView.frame = CGRectMake((viewWidth / colletionCellNumber - Adaptive(80)) / 2,
                                            0,
                                            Adaptive(80),
                                            Adaptive(80));
        _coachChooseView.backgroundColor = BASECOLOR;
        _coachChooseView.layer.cornerRadius  = _coachChooseView.bounds.size.width / 2;
        _coachChooseView.layer.masksToBounds = YES;
        [self addSubview:_coachChooseView];
       
        
        _coachImageView       = [UIImageView new];
        _coachImageView.bounds = CGRectMake(0,0,Adaptive(69),Adaptive(69));
        _coachImageView.center = _coachChooseView.center;
        _coachImageView.backgroundColor     = ORANGECOLOR;
        _coachImageView.layer.cornerRadius  = _coachImageView.bounds.size.width / 2;
        _coachImageView.layer.masksToBounds = YES;
        [self addSubview:_coachImageView];
        
        _gryView        = [UIView new];
        _gryView.frame  = CGRectMake((viewWidth / colletionCellNumber - Adaptive(80)) / 2,
                                     0,
                                     Adaptive(80),
                                     Adaptive(80));
        _gryView.layer.cornerRadius  = _gryView.bounds.size.width / 2;
        _gryView.layer.masksToBounds = YES;
        _gryView.backgroundColor = BASECOLOR;
        _gryView.alpha = 0.5;
        
        
        
        
        _coachNameLabel       = [UILabel new];
        _coachNameLabel.frame = CGRectMake(0,
                                           CGRectGetMaxY(_coachImageView.frame) + Adaptive(18),
                                           viewWidth / colletionCellNumber,
                                           Adaptive(16));
        _coachNameLabel.text = @"教练";
        _coachNameLabel.textColor = [UIColor whiteColor];
        _coachNameLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
        _coachNameLabel.textAlignment = 1;
        [self addSubview:_coachNameLabel];
        
        
        _coachButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _coachButton.frame = CGRectMake(0, 0, viewWidth / colletionCellNumber, Adaptive(133));
        [self addSubview:_coachButton];
        
    }
    return self;
}

@end
