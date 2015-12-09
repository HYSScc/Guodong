//
//  BackView.m
//  果动
//
//  Created by mac on 15/11/2.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "BackView.h"
#import "Commonality.h"
@implementation BackView
{
    NSString *title;
    UIViewController *backVC;
}
-(instancetype)initWithbacktitle:(NSString *)backtitle viewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, viewHeight/6.67, viewHeight/33.35);
        viewController.navigationItem.hidesBackButton = YES;
        title  = backtitle;
        backVC = viewController;
        [self createUI];
    }
    return self;
}
-(void)createUI
{
    UIImageView *backArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, viewHeight/381.143, viewHeight/68.41, viewHeight/40.424)];
    backArrowImageView.image = [UIImage imageNamed:@"every_back"];
  //  backArrowImageView.backgroundColor = [UIColor greenColor];
    [self addSubview:backArrowImageView];
    
    UIButton  *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(-viewHeight/133.4, 0, viewHeight/9.5286, viewHeight/33.35);
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(backArrowImageView.frame)+3, 0,viewHeight/9.5286, viewHeight/33.35)];
    titleLabel.text = title;
    titleLabel.textAlignment = 0;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/39.2353];
    [self addSubview:titleLabel];
    
   
    
    [self addSubview:backButton];
}
-(void)backButton
{
    [backVC.navigationController popViewControllerAnimated:YES];
}
@end
