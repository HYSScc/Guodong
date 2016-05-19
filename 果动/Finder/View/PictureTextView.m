//
//  PictureTextView.m
//  果动
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "PictureTextView.h"

@implementation PictureTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASECOLOR;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 20)];
    label.textColor = [UIColor whiteColor];
    label.text = @"图文";
    [self addSubview:label];
    
}
@end
