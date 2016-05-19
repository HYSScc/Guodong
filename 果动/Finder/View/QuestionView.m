//
//  QuestionView.m
//  果动
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "QuestionView.h"

@implementation QuestionView

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
    label.text = @"答疑";
    [self addSubview:label];

}
@end
