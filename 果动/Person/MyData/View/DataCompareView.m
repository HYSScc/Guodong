//
//  DataCompareView.m
//  果动
//
//  Created by mac on 16/8/25.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "DataCompareView.h"

@implementation DataCompareView

- (instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
 
        _baseImageView = [UIImageView new];
        _baseImageView.frame        = CGRectMake(0,
                                                0,
                                                self.bounds.size.width,
                                                self.bounds.size.height);
        
       
        [self addSubview:_baseImageView];
        
        _compareLabel = [UILabel new];
        _compareLabel.frame = CGRectMake(Adaptive(3.5),
                                         0,
                                         self.bounds.size.width - Adaptive(3.5),
                                         self.bounds.size.height);
        _compareLabel.textColor = [UIColor blackColor];
        _compareLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        _compareLabel.textAlignment = 1;
        [self addSubview:_compareLabel];
        
        
    }
    return self;
}

@end
