//
//  IntroduceCommentCell.m
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "IntroduceCommentCell.h"
#import "IntroduceComment.h"

@implementation IntroduceCommentCell
{
    UIImageView *headImageView;
    UILabel     *nickNameLabel;
    UILabel     *contentLabel;
    UILabel     *line;
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
        headImageView.frame = CGRectMake(Adaptive(13), Adaptive(5), Adaptive(37), Adaptive(37));
        headImageView.layer.cornerRadius = headImageView.bounds.size.width / 2;
        headImageView.layer.masksToBounds = YES;
        [self addSubview:headImageView];
        
        nickNameLabel       = [UILabel new];
        nickNameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(5),
                                         CGRectGetMinY(headImageView.frame) + Adaptive(5),
                                         Adaptive(100),
                                         Adaptive(16));
        nickNameLabel.textColor = [UIColor whiteColor];
        nickNameLabel.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:nickNameLabel];
        
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

- (void)setComment:(IntroduceComment *)comment {
    [headImageView sd_setImageWithURL:[NSURL URLWithString:comment.headimg] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    nickNameLabel.text = comment.nickName;
    
    CGSize contentSize = [comment.content boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(13)]} context:nil].size;
    contentLabel.frame = CGRectMake(Adaptive(13),
                                    CGRectGetMaxY(headImageView.frame) + Adaptive(5),
                                    contentSize.width,
                                    contentSize.height);
    contentLabel.text  = comment.content;
    
    line.frame = CGRectMake(0,
                            CGRectGetMaxY(contentLabel.frame) + Adaptive(5),
                            viewWidth,
                            .5);
    
    CGRect CellFrame       = self.frame;
    CellFrame.size.height  = CGRectGetMaxY(line.frame);
    self.frame             = CellFrame;
}

@end
