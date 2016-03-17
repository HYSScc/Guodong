//
//  makeView.m
//  果动
//
//  Created by mac on 16/3/7.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "makeView.h"

@implementation makeView
{
    NSNotification *makeNotification;
    NSNotification *notMakeNotification;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
     makeNotification    = [NSNotification notificationWithName:@"makeJuan" object:nil userInfo:nil];
     notMakeNotification = [NSNotification notificationWithName:@"notMakeJuan" object:nil userInfo:nil];
    
    for (int a = 0; a < 2; a++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth / 4 + (a * (viewWidth / 3)), 0, Adaptive(20), Adaptive(20))];
        imageView.tag = (a + 1) * 3;
        imageView.image = [UIImage imageNamed:@"对号"];
        [self addSubview:imageView];
        
        UILabel *makeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + Adaptive(10), 0, Adaptive(70), Adaptive(20))];
        makeLabel.tag = (a + 1) * 5;
        makeLabel.textColor = [UIColor lightGrayColor];
        makeLabel.font = [UIFont fontWithName:FONT size:14];
        makeLabel.text = @"使用";
        [self addSubview:makeLabel];
        
        
        UIButton *makeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        makeBtn.tag = (a + 1) * 2;
        makeBtn.frame = CGRectMake(viewWidth / 4  + a * (viewWidth / 3), 0, Adaptive(100), Adaptive(20));
        [makeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:makeBtn];
        
        if (a == 1) {
            imageView.image = [UIImage imageNamed:@"对号红"];
            makeLabel.text = @"下次再说";
            makeLabel.textColor = [UIColor orangeColor];
        }
        
    }
    
  }

- (void)buttonClick:(UIButton *)button {
   
   
    
   

    UIImageView *imageViewLeft  = (UIImageView *)[self viewWithTag:3];
    UIImageView *imageViewRight = (UIImageView *)[self viewWithTag:6];
    UILabel *labelRight         = (UILabel *)[self viewWithTag:10];
    UILabel *labelLeft          = (UILabel *)[self viewWithTag:5];
    
    switch (button.tag) {
        case 2:
            imageViewLeft.image  = [UIImage imageNamed:@"对号红"];
            imageViewRight.image = [UIImage imageNamed:@"对号"];
            labelLeft.textColor  = [UIColor orangeColor];
            labelRight.textColor = [UIColor lightGrayColor];
            NSLog(@"点击了使用");
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:makeNotification];
            
            break;
        case 4:
            imageViewLeft.image  = [UIImage imageNamed:@"对号"];
            imageViewRight.image = [UIImage imageNamed:@"对号红"];
            labelLeft.textColor  = [UIColor lightGrayColor];
            labelRight.textColor = [UIColor orangeColor];
            NSLog(@"点击了下次再说");
            [[NSNotificationCenter defaultCenter] postNotification:notMakeNotification];
            break;
        default:
            break;
    }
    
}
@end
