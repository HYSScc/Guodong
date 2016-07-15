//
//  NavigationView.m
//  果动
//
//  Created by mac on 16/7/11.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "NavigationView.h"

@implementation NavigationView
{
    UIViewController *viewController;
}

- (instancetype)initWithtitle:(NSString *)title viewController:(UIViewController *)controller
{
    
    self = [super init];
    if (self) {
        self.frame              = CGRectMake(0, 0, viewWidth, Adaptive(64));
        self.backgroundColor    = ORANGECOLOR;
        CGFloat navigationHight = self.frame.size.height - Adaptive(20);
        
        viewController = controller;
        
        UIImageView* backArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(13), Adaptive(20)+(navigationHight - Adaptive(16.5)) / 2, Adaptive(9.75), Adaptive(16.5))];
        backArrowImageView.image = [UIImage imageNamed:@"every_back"];
        [self addSubview:backArrowImageView];
        
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.backgroundColor = [UIColor clearColor];
        backButton.frame = CGRectMake(-Adaptive(5), Adaptive(20), viewHeight / 9.5286, Adaptive(44));
        [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backButton];
        
        UILabel * titleLabel = [UILabel new];
        titleLabel.frame     = CGRectMake(Adaptive(100),
                                          Adaptive(20)+(navigationHight - Adaptive(20)) / 2,
                                          viewWidth - Adaptive(200),
                                          Adaptive(20));
        titleLabel.textColor = BASECOLOR;
        titleLabel.text      = title;
        titleLabel.textAlignment = 1;
        titleLabel.font      = [UIFont fontWithName:FONT_BOLD size:Adaptive(18)];
        [self addSubview:titleLabel];
        
        
    }
    return self;
}
- (void)backButton
{
    [viewController.navigationController popViewControllerAnimated:YES];
}
@end
