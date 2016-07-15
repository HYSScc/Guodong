//
//  My_NewsTableViewCell.m
//  果动
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "My_NewsTableViewCell.h"
#import "NewsFunctionView.h"
#import "MyNewsModel.h"
@implementation My_NewsTableViewCell
{
    UIImageView *headImageView;
    UILabel     *nickNameLabel;
    UILabel     *dateLabel;
    UILabel     *contentLabel;
    UIImageView *contentImageView;
    NewsFunctionView *functionView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = BASEGRYCOLOR;
        
        
        headImageView = [UIImageView new];
        headImageView.frame        = CGRectMake(Adaptive(13),
                                                Adaptive(10),
                                                Adaptive(30),
                                                Adaptive(30));
        headImageView.layer.cornerRadius  = headImageView.bounds.size.width / 2;
        headImageView.layer.masksToBounds = YES;
        [self addSubview:headImageView];
        
        
        nickNameLabel = [UILabel new];
        nickNameLabel.frame    = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(10),
                                            Adaptive(15),
                                            Adaptive(120),
                                            Adaptive(20));
        nickNameLabel.textColor = [UIColor whiteColor];
        nickNameLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        [self addSubview:nickNameLabel];
        
        
        dateLabel = [UILabel new];
        dateLabel.frame    = CGRectMake(viewWidth -Adaptive((13 + 100)),
                                        Adaptive(18),
                                        Adaptive(100),
                                        Adaptive(15));
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font      = [UIFont fontWithName:FONT size:Adaptive(11)];
        dateLabel.textAlignment = 2;
        [self addSubview:dateLabel];
        
        
        contentLabel = [UILabel new];
        contentLabel.frame    = CGRectMake(Adaptive(13),
                                           CGRectGetMaxY(headImageView.frame) + Adaptive(5),
                                           viewWidth - Adaptive(26),
                                           Adaptive(35));
        contentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.numberOfLines = 2;
       // contentLabel.text      = @"分地方反复了骄傲的浪费就阿里打开附件里卡减肥了咖啡龙卡及反馈的爱了就打开房间爱离开的房间";
        [self addSubview:contentLabel];
        
        contentImageView       = [UIImageView new];
        contentImageView.frame        = CGRectMake(Adaptive(13),
                                                   CGRectGetMaxY(contentLabel.frame) + Adaptive(5),
                                                   viewWidth - Adaptive(26),
                                                   viewWidth - Adaptive(26));
        contentImageView.image        = [UIImage imageNamed:@"news_result"];
        [self addSubview:contentImageView];
        
        
        functionView = [[NewsFunctionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(contentImageView.frame) + Adaptive(5),viewWidth,Adaptive(40))];
        
        [self addSubview:functionView];
               
        
        
        UILabel *lineLabel = [UILabel new];
        lineLabel.frame    = CGRectMake(0, CGRectGetMaxY(functionView.frame), viewWidth, Adaptive(10));
        lineLabel.backgroundColor = BASECOLOR;
        [self addSubview:lineLabel];
        
    }
    return self;
}

- (void)setNewsModel:(MyNewsModel *)newsModel {
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.headimgUrl] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    nickNameLabel.text = newsModel.nickName;
    dateLabel.text     = newsModel.date;
    contentLabel.text  = newsModel.content;
    [contentImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.photoUrl]];
    
    
    functionView.newsModel = newsModel;
    
    
    CGRect Frame       = self.frame;
    Frame.size.height  = CGRectGetMaxY(contentImageView.frame) + Adaptive(55);
    self.frame         = Frame;
    
}
@end
