//
//  MYExerciseTableViewCell.m
//  果动
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "MYExerciseTableViewCell.h"
#import "Commonality.h"
@implementation MYExerciseTableViewCell

// 初始化方法
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.frame = CGRectMake(0, 0, viewWidth, viewHeight/9.5286 );
        self.baseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.baseImageView];
        
        
        self.coachLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308, (self.frame.size.height - (viewHeight/16.675))/2, viewHeight/5.336, viewHeight/16.675)];
        self.coachLabel.font = [UIFont fontWithName:FONT size:viewHeight/41.6875];
        self.coachLabel.textColor = [UIColor whiteColor];
      
        self.coachLabel.text = @"教练:陈菲菲";
        self.coachLabel.textAlignment = 1;
        [self addSubview:self.coachLabel];
        
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.baseImageView.bounds.size.width - viewHeight/5.336 - (viewHeight/66.7) , (self.frame.size.height - (viewHeight/16.675))/2, viewHeight/5.336, viewHeight/16.675)];
        self.timeLabel.textColor = [UIColor lightGrayColor];
        self.timeLabel.text = @"日期:2015-04-29";
        self.timeLabel.font = [UIFont fontWithName:FONT size:viewHeight/60.636];
        [self addSubview:self.timeLabel];
        
        
      
        
        
        
        
    }
    return self;
}



@end
