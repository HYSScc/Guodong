//
//  BackView.m
//  果动
//
//  Created by mac on 15/11/2.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "BackView.h"

@implementation BackView {
    NSString* title;
    UIViewController* backVC;
}
- (instancetype)initWithbacktitle:(NSString*)backtitle viewController:(UIViewController*)viewController
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, Adaptive(100), Adaptive(20));
        viewController.navigationItem.hidesBackButton = YES;
        title = backtitle;
        backVC = viewController;
        [self createUI];
    }
    return self;
}
- (void)createUI
{
    UIImageView* backArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, Adaptive(1.75), Adaptive(9.75), Adaptive(16.5))];
    backArrowImageView.image = [UIImage imageNamed:@"every_back"];
    [self addSubview:backArrowImageView];

    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(-Adaptive(5), 0, viewHeight / 9.5286, Adaptive(20));
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];

    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backArrowImageView.frame) + 3, 0, viewHeight / 9.5286, Adaptive(20))];
    titleLabel.text = title;
    titleLabel.textAlignment = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:FONT size:viewHeight / 39.2353];
    [self addSubview:titleLabel];

    [self addSubview:backButton];
}
- (void)backButton
{
    [backVC.navigationController popViewControllerAnimated:YES];
}
@end
