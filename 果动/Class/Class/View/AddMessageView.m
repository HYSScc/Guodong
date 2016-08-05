//
//  AddMessageView.m
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "AddMessageView.h"

@implementation AddMessageView

- (instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dict
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = BASEGRYCOLOR;
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame    = CGRectMake(Adaptive(13),
                                         (self.frame.size.height - Adaptive(20)) / 2,
                                         Adaptive(50),
                                         Adaptive(20));
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.text      = [dict objectForKey:@"title"];
        titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        [self addSubview:titleLabel];
        
        
        if ([[dict objectForKey:@"type"] isEqualToString:@"tian"]) {
            _textField       = [UITextField new];
            _textField.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame),
                                          0,
                                          self.bounds.size.width - CGRectGetMaxX(titleLabel.frame) - Adaptive(23),
                                          self.bounds.size.height);
            _textField.backgroundColor = BASEGRYCOLOR;
            _textField.textColor       = [UIColor whiteColor];
            _textField.font            = [UIFont fontWithName:FONT size:Adaptive(14)];
            _textField.textAlignment   = 2;
            [self addSubview:_textField];
        } else {
            _messageButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _messageButton.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame),
                                              0,
                                              self.bounds.size.width - CGRectGetMaxX(titleLabel.frame),
                                              self.bounds.size.height);
            [self addSubview:_messageButton];
        }
        
        _messageLabel       = [UILabel new];
        _messageLabel.frame = CGRectMake(CGRectGetMaxX(titleLabel.frame),
                                         0,
                                         self.bounds.size.width - CGRectGetMaxX(titleLabel.frame) - Adaptive(23),
                                         self.bounds.size.height);
        _messageLabel.textAlignment = 2;
        _messageLabel.numberOfLines = 0;
        _messageLabel.font          = [UIFont fontWithName:FONT size:Adaptive(14)];
        _messageLabel.textColor     = [UIColor whiteColor];
        [self addSubview:_messageLabel];
        
        UILabel *line = [UILabel new];
        line.frame    = CGRectMake(0, self.bounds.size.height - .5,viewWidth, .5);
        line.backgroundColor = BASECOLOR;
        [self addSubview:line];
    }
    return self;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField resignFirstResponder];
}
@end
