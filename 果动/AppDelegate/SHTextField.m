//
//  SHTextField.m
//  GuoDong
//
//  Created by mac on 16/2/2.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "SHTextField.h"
#import "Commonality.h"
@implementation SHTextField

- (instancetype)initWithFrame:(CGRect)frame placeholder:(NSString *)place
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        // 初始化属性
        self.borderStyle       = UITextBorderStyleNone;
        self.backgroundColor   = [UIColor clearColor];
        self.textColor         = [UIColor lightGrayColor];
        self.placeholder       = place;
        self.font              = [UIFont fontWithName:FONT size:Adaptive(14)];
        self.keyboardType      = UIKeyboardTypeNumberPad;
        [self setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont fontWithName:FONT size:Adaptive(14)] forKeyPath:@"_placeholderLabel.font"];
        
        
    }
    return self;
}







@end
