//
//  historyTableViewCell.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "historyTableViewCell.h"
#import "Commonality.h"

@implementation historyTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        UIImageView * lineImage1=[[UIImageView alloc] initWithFrame:CGRectMake(0, 120, viewWidth, 1)];
        lineImage1.image=[UIImage imageNamed:@"activity_line"];
        [self addSubview:lineImage1];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 100, 25)];
        label1.text = @"活动主题：";
        label1.font=[UIFont fontWithName:FONT size:19];
        label1.textColor = [UIColor whiteColor];
        [self addSubview:label1];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 60, 100, 25)];
        self.dateLabel.text = @"2015/8/19";
        self.dateLabel.font=[UIFont systemFontOfSize:19];
        self.dateLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.dateLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 15, 100, 25)];
        self.titleLabel.text = @"爬山";
        self.titleLabel.font=[UIFont fontWithName:FONT size:25];
        self.titleLabel.textColor = [UIColor redColor];
        [self addSubview:self.titleLabel];
        
        self.logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth-120, 5, 100, 100)];
        self.logoImageView.layer.cornerRadius = 25;
        
        self.logoImageView.layer.masksToBounds = YES;
      self.logoImageView.backgroundColor = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:.2];
       // self.logoImageView.backgroundColor = [UIColor redColor];
        [self addSubview:self.logoImageView];
    }
    return self;
}





- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
