//
//  leftCollectionViewCell.m
//  果动
//
//  Created by mac on 16/1/5.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "Commonality.h"
#import "leftCollectionViewCell.h"

@implementation leftCollectionViewCell

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    self.classImageView                        = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                                               0,
                                                                                               self.frame.size.width,
                                                                                               self.frame.size.height)];
    self.classImageView.userInteractionEnabled = YES;
    [self.classImageView setImage:[UIImage imageNamed:@"shouye_moren"]];
    [self addSubview:self.classImageView];
    
    self.classNameLabel               = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, Adaptive(20))];
    self.classNameLabel.center        = self.classImageView.center;
    self.classNameLabel.textColor     = [UIColor whiteColor];
    self.classNameLabel.textAlignment = 1;
    self.classNameLabel.font          = [UIFont fontWithName:FONT size:Adaptive(18)];
    [self addSubview:self.classNameLabel];
    
    self.classNumberLabel             = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(self.classNameLabel.frame),
                                                                      self.frame.size.width,
                                                                      Adaptive(10))];
    self.classNumberLabel.textColor     = [UIColor whiteColor];
    self.classNumberLabel.textAlignment = 1;
    self.classNumberLabel.font          = [UIFont fontWithName:FONT size:Adaptive(10)];
    [self addSubview:self.classNumberLabel];
    
}
@end
