//
//  NewsDetailsReplyCell.m
//  果动
//
//  Created by mac on 16/6/8.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "DetailsCommentView.h"
#import "NewsDetailsReplyCell.h"
#import "NewsDetailsReply.h"
@implementation NewsDetailsReplyCell
{
    UIImageView *headImageView;
    UILabel     *nickNameLabel;
    UILabel     *contentLabel;
    UILabel     *timeLabel;
    UILabel     *targetLabel;
    UILabel     *line;
    
    NSString    *user_id;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor = [UIColor colorWithRed:55/255.0
                                               green:55/255.0
                                                blue:55/255.0
                                               alpha:1];
        
        headImageView       = [UIImageView new];
        headImageView.frame = CGRectMake(Adaptive(13),
                                         Adaptive(5),
                                         Adaptive(37),
                                         Adaptive(37));
        headImageView.layer.cornerRadius  = headImageView.bounds.size.width / 2;
        headImageView.layer.masksToBounds = YES;
        headImageView.userInteractionEnabled = YES;
        [self addSubview:headImageView];
        
        
        UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserPublick:)];
        [headImageView addGestureRecognizer:tapLeftDouble];
        
        nickNameLabel       = [UILabel new];
        nickNameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(5),
                                         CGRectGetMinY(headImageView.frame) + Adaptive(5),
                                         Adaptive(100),
                                         Adaptive(16));
        nickNameLabel.textColor = [UIColor whiteColor];
        nickNameLabel.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:nickNameLabel];
        
        timeLabel       = [UILabel new];
        timeLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(5),
                                     CGRectGetMaxY(nickNameLabel.frame),
                                     Adaptive(100),
                                     Adaptive(16));
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.font      = [UIFont fontWithName:FONT size:Adaptive(8)];
        [self addSubview:timeLabel];
        
        targetLabel           = [UILabel new];
        targetLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        [self addSubview:targetLabel];
        
        
        contentLabel           = [UILabel new];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        
        line                 = [UILabel new];
        line.backgroundColor = BASECOLOR;
        [self addSubview:line];
        
    }
    return self;
}

- (void)pushUserPublick:(UIGestureRecognizer *)gesture {
    
    NSLog(@"发送推送");
   
    NSNotification *notification = [[NSNotification alloc] initWithName:@"pushUserPublick" object:nil userInfo:@{@"user_id":user_id}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
       
}

- (void)setNewsReply:(NewsDetailsReply *)newsReply {
    
    user_id = newsReply.user_id;
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:newsReply.sourceHeadImg]];
    nickNameLabel.text = newsReply.sourceName;
    timeLabel.text     = newsReply.timeString;
   
    NSString *target = [NSString stringWithFormat:@"回复%@:",newsReply.targetName];
    
    CGSize targetSize = [target sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(13)]}];
    targetLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(5),
                                   CGRectGetMaxY(headImageView.frame) + Adaptive(5),
                                   targetSize.width,
                                   Adaptive(13));
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:target];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:33/255.0 green:155/255.0 blue:131/255.0 alpha:1] range:NSMakeRange(2,newsReply.targetName.length)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(2+newsReply.targetName.length,1)];
    targetLabel.attributedText = str;
    
    
    CGSize contentSize = [newsReply.content boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(13) - CGRectGetMaxX(targetLabel.frame), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(13)]} context:nil].size;
    
    contentLabel.frame = CGRectMake(CGRectGetMaxX(targetLabel.frame),
                                    CGRectGetMaxY(headImageView.frame) + Adaptive(5),
                                    contentSize.width,
                                    contentSize.height);
    contentLabel.text  = newsReply.content;
    
    line.frame = CGRectMake(0,
                            CGRectGetMaxY(contentLabel.frame) + Adaptive(5),
                            viewWidth,
                            .5);
    
    CGRect CellFrame       = self.frame;
    CellFrame.size.height  = CGRectGetMaxY(line.frame);
    self.frame             = CellFrame;
   
}

@end
