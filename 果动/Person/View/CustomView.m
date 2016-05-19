//
//  CustomView.m
//  果动
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "CustomView.h"

@implementation CustomView

- (instancetype)initWithFrame:(CGRect)frame titleImage:(UIImage *)image title:(NSString *)title buttontag:(NSInteger)tag
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
        [self createUIWithImage:image titleString:title buttontag:tag];
    }
    return self;
}

- (void) createUIWithImage:(UIImage *)image titleString:(NSString *)string buttontag:(NSInteger)tag {
 
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
   
    switch (tag) {
        case 10:
            imageView.frame = CGRectMake(Adaptive(25) - Adaptive(13) / 2,
                                         (Adaptive(43) - Adaptive(17.5)) / 2,
                                         Adaptive(13),
                                         Adaptive(17.5));
            break;
        case 11:
            imageView.frame = CGRectMake(Adaptive(25) - Adaptive(18.5) / 2,
                                         (Adaptive(43) - Adaptive(11.5)) / 2,
                                         Adaptive(18.5),
                                         Adaptive(11.5));
            break;
        case 12:
            imageView.frame = CGRectMake(Adaptive(25) - Adaptive(15) / 2,
                                         (Adaptive(43) - Adaptive(17.5)) / 2,
                                         Adaptive(15),
                                         Adaptive(17.5));
            break;
        case 13:
            imageView.frame = CGRectMake(Adaptive(25) - Adaptive(14.5) / 2,
                                         (Adaptive(43) - Adaptive(18)) / 2,
                                         Adaptive(14.5),
                                         Adaptive(18));
            break;
        case 14:
            imageView.frame = CGRectMake(Adaptive(25) - Adaptive(13) / 2,
                                         (Adaptive(43) - Adaptive(17.5)) / 2,
                                         Adaptive(13),
                                         Adaptive(17.5));
            break;
        case 15:
            imageView.frame = CGRectMake(Adaptive(25) - Adaptive(18.5) / 2,
                                         (Adaptive(43) - Adaptive(11.5)) / 2,
                                         Adaptive(18.5),
                                         Adaptive(11.5));
            break;
            
        default:
            break;
    }
    
    UILabel *label = [UILabel new];
    label.frame    = CGRectMake(Adaptive(39),
                                (Adaptive(43) - Adaptive(20)) / 2,
                                Adaptive(100),
                                Adaptive(20));
    label.font      = [UIFont fontWithName:FONT size:Adaptive(15)];
    label.textColor = [UIColor whiteColor];
    label.text      = string;
    [self addSubview:label];
    
    
    UIImageView *triangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_rightArrow"]];
    triangleImage.frame        = CGRectMake(viewWidth - Adaptive(13) - Adaptive(9),
                                            (Adaptive(43) - Adaptive(15.5)) / 2,
                                            Adaptive(9),
                                            Adaptive(15.5));
    [self addSubview:triangleImage];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag       = tag;
    button.frame     = CGRectMake(0, 0, viewWidth, Adaptive(43));
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}

- (void)buttonClick:(UIButton *)button {
    NSLog(@"button.tag  %ld",button.tag);
}

@end
