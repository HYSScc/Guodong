//
//  PushView.m
//  果动
//
//  Created by mac on 16/7/4.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "PushView.h"
#import "AppDelegate.h"
@implementation PushView
{
    UIView      *alphaView;
    UIImageView *showImageView;
    UILabel     *showLabel;
}
- (instancetype)initWithFrame:(CGRect)frame  image:(NSString *)imageString imageWidth:(CGFloat)width height:(CGFloat)height title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        
        alphaView = [UIView new];
        alphaView.frame = CGRectMake(0,
                                     0,
                                     viewWidth,
                                     viewHeight);
        alphaView.backgroundColor = [UIColor blackColor];
        alphaView.alpha = .6;
        [app.window addSubview:alphaView];
        
        
        
        showImageView       = [UIImageView new];
        showImageView.frame = CGRectMake((viewWidth - width) / 2,
                                         (viewHeight*0.75 - height) / 2,
                                         width,
                                         height);
        [showImageView sd_setImageWithURL:[NSURL URLWithString:imageString]];
        [self addSubview:showImageView];
    
        
        showLabel       = [UILabel new];
        showLabel.textAlignment = 1;
        showLabel.font          = [UIFont fontWithName:FONT size:Adaptive(14)];
        showLabel.textColor     = [UIColor whiteColor];
        showLabel.numberOfLines = 0;
        
         CGSize textSize = [title boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]} context:nil].size;
        
        showLabel.frame = CGRectMake(Adaptive(13), CGRectGetMaxY(showImageView.frame) + Adaptive(20),
                                     viewWidth - Adaptive(26),
                                    textSize.height);
        showLabel.text = title;
        [self addSubview:showLabel];
        
        
        [NSTimer scheduledTimerWithTimeInterval:3.0f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:self
                                        repeats:YES];
        
    }
    return self;
}
// 自动消失
- (void)timerFireMethod:(NSTimer*)theTimer
{
    [alphaView removeFromSuperview];
    [self removeFromSuperview];
}
@end
