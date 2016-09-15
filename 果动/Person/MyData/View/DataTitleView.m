//
//  DataTitleView.m
//  果动
//
//  Created by mac on 16/8/23.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "DataTitleView.h"

@implementation DataTitleView

- (instancetype)initWithFrame:(CGRect)frame titleName:(NSString *)title contentName:(NSString *)content imageName:(NSString *)image
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *imageView = [UIImageView new];
        imageView.frame        = CGRectMake(Adaptive(13),
                                            (self.bounds.size.height - Adaptive(22.5)) / 2,
                                            Adaptive(22.5),
                                            Adaptive(22.5));
        imageView.image        = [UIImage imageNamed:image];
        [self addSubview:imageView];
        
        
        UILabel *titleLabel = [UILabel new];
        
        if (content == nil) {
            titleLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + Adaptive(14),
                                          (self.bounds.size.height - Adaptive(12)) / 2,
                                          Adaptive(150),
                                          Adaptive(12));
        } else {
            titleLabel.frame = CGRectMake(CGRectGetMaxX(imageView.frame) + Adaptive(14),
                                          (self.bounds.size.height - Adaptive(25)) / 2,
                                          Adaptive(150),
                                          Adaptive(12));
            
            UILabel *contentLabel  = [UILabel new];
            contentLabel.frame     = CGRectMake(CGRectGetMaxX(imageView.frame)  + Adaptive(14),
                                               CGRectGetMaxY(titleLabel.frame) + Adaptive(3) ,
                                               Adaptive(150),
                                               Adaptive(10));
            contentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(10)];
            contentLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
            contentLabel.text      = content;
            [self addSubview:contentLabel];
            
        }
        titleLabel.numberOfLines = 0;
        titleLabel.text      = title;
        titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        titleLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
        [self addSubview:titleLabel];
        
        UILabel *gryLabel = [UILabel new];
        gryLabel.frame    = CGRectMake(Adaptive(13),
                                       self.bounds.size.height - Adaptive(1),
                                       self.bounds.size.width - Adaptive(13),
                                       Adaptive(1));
        gryLabel.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
        [self addSubview:gryLabel];
    }
    return self;
}

@end
