//
//  TextFieldView.m
//  果动
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "TextFieldView.h"

@implementation TextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = BASECOLOR;
        
        _textField = [UITextField new];
        _textField.frame = CGRectMake(Adaptive(13),
                                      (self.frame.size.height - Adaptive(32)) / 2,
                                      viewWidth - Adaptive(99),
                                      Adaptive(32));
        _textField.backgroundColor = [UIColor colorWithRed:55/255.0
                                                     green:55/255.0
                                                      blue:55/255.0
                                                     alpha:1];
        _textField.placeholder     = @"说点什么吧";
        _textField.textColor       = [UIColor grayColor];
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Adaptive(25), Adaptive(13))];
        _textField.leftView        = leftView;
        _textField.leftViewMode    = UITextFieldViewModeAlways;
        _textField.font            = [UIFont fontWithName:FONT size:Adaptive(14)];
        [_textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [self addSubview:_textField];
        
        
        UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(5),
                                                                                   (_textField.bounds.size.height - Adaptive(13)) / 2,
                                                                                   Adaptive(13),
                                                                                   Adaptive(13))];
        leftImageView.image        = [UIImage imageNamed:@"textFieldImage"];
        [_textField addSubview:leftImageView];

        
        _publishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _publishButton.frame     = CGRectMake(viewWidth - Adaptive((13 + 60)),
                                             (self.frame.size.height - Adaptive(30)) / 2,
                                             Adaptive(60),
                                             Adaptive(30));
        [_publishButton setTitleColor:ORANGECOLOR
                            forState:UIControlStateNormal];
        [_publishButton setTitle:@"发布" forState:UIControlStateNormal];
        [self addSubview:_publishButton];
    }
    return self;
}

@end
