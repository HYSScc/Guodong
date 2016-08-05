//
//  QuestionCommentCell.m
//  果动
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "QuestionCommentCell.h"
#import "QuestionContent.h"
@implementation QuestionCommentCell
{
    UIImageView *headImageView;
    UILabel     *nickNameLabel;
    UILabel     *contentLabel;
    UILabel     *timeLabel;
    UILabel     *line;
    UIImageView *isCoachImageView;
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
        [self addSubview:headImageView];
        
        isCoachImageView       = [UIImageView new];
        isCoachImageView.frame = CGRectMake(Adaptive(37), Adaptive(30), Adaptive(10), Adaptive(17));
        isCoachImageView.image = [UIImage imageNamed:@"tabbarOrange_1"];
        [self addSubview:isCoachImageView];
        
        nickNameLabel       = [UILabel new];
        nickNameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(5),
                                         Adaptive(16),
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

- (void)setContentModel:(QuestionContent *)contentModel {
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.comment_headimgString]];
    nickNameLabel.text = contentModel.comment_nickName;
   
    

    
    CGSize contentSize = [contentModel.comment_content boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(13) - CGRectGetMaxX(headImageView.frame) - Adaptive(5), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(13)]} context:nil].size;
    
    contentLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(5),
                                    CGRectGetMaxY(headImageView.frame) + Adaptive(5),
                                    viewWidth-Adaptive(13) - CGRectGetMaxX(headImageView.frame) - Adaptive(5),
                                    contentSize.height);
    
    
    // 调整行间距
    contentLabel.attributedText = [HttpTool setLinespacingWith:contentModel.comment_content space:4];
    
    [contentLabel sizeToFit];
    line.frame = CGRectMake(0,
                            CGRectGetMaxY(contentLabel.frame) + Adaptive(10),
                            viewWidth,
                            .5);
    
    CGRect CellFrame       = self.frame;
    CellFrame.size.height  = CGRectGetMaxY(line.frame);
    self.frame             = CellFrame;
    
}

@end
