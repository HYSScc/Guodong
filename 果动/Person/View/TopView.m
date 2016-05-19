//
//  TopView.m
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//
 
#import "TopView.h"


@implementation TopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ORANGECOLOR;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UIImageView *baseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               viewWidth,
                                                                               Adaptive(155))];
    baseImageView.image = [UIImage imageNamed:@"person_topImage"];
    baseImageView.userInteractionEnabled = YES;
    [self addSubview:baseImageView];
    
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setButton.frame     = CGRectMake(viewWidth - Adaptive(13) - Adaptive(17),
                                     Adaptive(25),
                                     Adaptive(20),
                                     Adaptive(20));
    [setButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [setButton setBackgroundImage:[UIImage imageNamed:@"person_setImage"] forState:UIControlStateNormal];
    [self addSubview:setButton];
    
    // 背景图不居中  手动设置高度
    _headImageView = [[UIImageView alloc] init];
    _headImageView.frame = CGRectMake(Adaptive(156),
                                       Adaptive(41),
                                       Adaptive(65),
                                       Adaptive(65));
   
    _headImageView.layer.cornerRadius  = _headImageView.bounds.size.width / 2;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.image               = [UIImage imageNamed:@"person_nohead"];
    [self addSubview:_headImageView];
    
    
    _nameLabel       = [UILabel new];
    _nameLabel.frame = CGRectMake(0,
                                  self.bounds.size.height - Adaptive(20) - Adaptive(13),
                                  viewWidth,
                                  Adaptive(20));
    _nameLabel.textAlignment = 1;
    _nameLabel.font          = [UIFont fontWithName:FONT size:Adaptive(12)];
    _nameLabel.text          = @"Midsummer";
    [self addSubview:_nameLabel];
    
    /*********************************************/
    
      
}

#pragma mark - 设置按钮点击事件
- (void)setButtonClick:(UIButton *)button {
    NSLog(@"点击了设置按钮");
}

@end
