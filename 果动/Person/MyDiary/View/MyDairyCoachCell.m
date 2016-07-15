//
//  MyDairyCoachCell.m
//  果动
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "MyDairyModel.h"
#import "MyDairyCoachCell.h"

#import "AppDelegate.h"
#import "ShareView.h"

@implementation MyDairyCoachCell
{
    UILabel  *dateLabel;
    UILabel  *titleLabel;
    UILabel  *coach_content;
    UILabel  *titleLine;
    UILabel  *verticalLine;
    UIButton *shareButton;
    NSString *data_id;
    UIView   *alphaView;
    ShareView*share;
    UIImageView *shareImageView;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor = BASECOLOR;
        
        
        verticalLine = [UILabel new];
        verticalLine.backgroundColor = ORANGECOLOR;
        [self addSubview:verticalLine];
        
        
        UIImageView *ringImageView = [UIImageView new];
        ringImageView.frame        = CGRectMake(Adaptive(13),
                                                Adaptive(23),
                                                Adaptive(13),
                                                Adaptive(13));
        ringImageView.image = [UIImage imageNamed:@"person_data_ring"];
        [self addSubview:ringImageView];
        
        dateLabel       = [UILabel new];
        dateLabel.frame = CGRectMake(CGRectGetMaxX(ringImageView.frame) + Adaptive(5),
                                     CGRectGetMinY(ringImageView.frame) - Adaptive(1),
                                     viewWidth / 2,
                                     Adaptive(15));
        dateLabel.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        dateLabel.textColor = ORANGECOLOR;
        [self addSubview:dateLabel];
        
        UILabel *dateLine = [UILabel new];
        dateLine.backgroundColor = BASEGRYCOLOR;
        dateLine.frame = CGRectMake(CGRectGetMinX(dateLabel.frame),
                                    CGRectGetMaxY(dateLabel.frame) + Adaptive(3),
                                    viewWidth - Adaptive(65.5),
                                    Adaptive(3));
        [self addSubview:dateLine];
        
        titleLabel       = [UILabel new];
        titleLabel.frame = CGRectMake(Adaptive(31),
                                      CGRectGetMaxY(dateLine.frame) + Adaptive(8),
                                      viewWidth - Adaptive(65.5),
                                      Adaptive(15));
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        [self addSubview:titleLabel];
        
        titleLine = [UILabel new];
        titleLine.frame   = CGRectMake(Adaptive(31),
                                       CGRectGetMaxY(titleLabel.frame) + Adaptive(8),
                                       viewWidth - Adaptive(65.5),
                                       .5);
        titleLine.backgroundColor = BASEGRYCOLOR;
        [self addSubview:titleLine];
        
        
        coach_content       = [UILabel new];
        coach_content.textColor = [UIColor whiteColor];
        coach_content.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        coach_content.numberOfLines = 0;
        
        [self addSubview:coach_content];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShare) name:@"removeShare" object:nil];
        
        shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shareButton.frame = CGRectMake(viewWidth - Adaptive(27.5),
                                       CGRectGetMaxY(dateLine.frame) - Adaptive(17.5),
                                       Adaptive(14.5),
                                       Adaptive(17.5));
        [shareButton setBackgroundImage:[UIImage imageNamed:@"find_share"] forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shareButton];
        
    }
    return self;
}
- (void)shareButtonClick:(UIButton *)button {
    
    NSString *url = [NSString stringWithFormat:@"%@usershare/?types=gdb&id=%@",BASEURL,data_id];
    
   
    
     NSString *title = [NSString stringWithFormat:@"%@的健身日记 - 果动",_nickName];
    
    share = [[ShareView alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, Adaptive(256)) title:title imageName:shareImageView.image url:url viewController:nil];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    alphaView = [UIView new];
    alphaView.frame           = CGRectMake(0, 0, viewWidth, viewHeight);
    alphaView.backgroundColor = BASECOLOR;
    alphaView.alpha           = .3;
    
    UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    [alphaView addGestureRecognizer:tapLeftDouble];
    
    [UIView animateWithDuration:.2 animations:^{
        [app.window addSubview:alphaView];
        CGRect Frame   = share.frame;
        Frame.origin.y = viewHeight - Adaptive(256);
        share.frame    = Frame;
        [app.window addSubview:share];
        
    }];
}
- (void)removeShare {
    [alphaView removeFromSuperview];
    
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect Frame   = share.frame;
        Frame.origin.y = viewHeight;
        share.frame    = Frame;
    } completion:^(BOOL finished) {
        [share removeFromSuperview];
    }];
}

-(void)magnifyImage:(UIGestureRecognizer *)gesture
{
    [self removeShare];
}
- (void)setDairy:(MyDairyModel *)dairy {
    
    data_id         = dairy.dairy_id;
    dateLabel.text  = dairy.date;
    titleLabel.text = dairy.title;
   
    
    
    CGSize textSize = [dairy.coachContent boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(65.5), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(14)]} context:nil].size;
    int numberOfLine = (floor)((textSize.height) / (Adaptive(15)));
    
    coach_content.frame = CGRectMake(Adaptive(31),
                                     CGRectGetMaxY(titleLine.frame) + Adaptive(9),
                                     viewWidth - Adaptive(65.5),
                                     textSize.height + Adaptive(10)*numberOfLine);
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:dairy.coachContent];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:Adaptive(10)];//调整行间距
    [str addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, dairy.coachContent.length)];
    coach_content.attributedText = str;
    [coach_content sizeToFit];
    
    
    for (int a = 0; a < numberOfLine; a++) {
        UILabel *line = [UILabel new];
        line.frame    = CGRectMake(Adaptive(31),
                                   (CGRectGetMinY(coach_content.frame) + Adaptive(19)) + (Adaptive((10 + 15.5)) * a),
                                   viewWidth - Adaptive(65.5),
                                   .5);
        line.backgroundColor = BASEGRYCOLOR;
        [self addSubview:line];
    }
    
    CGRect Frame = self.frame;
    
    shareImageView = [UIImageView new];
    
    
    if (dairy.photoArray.count == 0) {
        shareImageView.image = [UIImage imageNamed:@"App"];
        
        UILabel *moreLine = [UILabel new];
        moreLine.frame    = CGRectMake(Adaptive(31),
                                       CGRectGetMaxY(coach_content.frame) + Adaptive(2.5) + Adaptive(20)
                                       , viewWidth - Adaptive(65.5),
                                       .5);
        moreLine.backgroundColor = BASEGRYCOLOR;
        [self addSubview:moreLine];
        
        if (dairy.userContent.length == 0) {
            
            
            _addUserButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            _addUserButton.frame = CGRectMake(viewWidth - Adaptive(27.5),
                                              CGRectGetMaxY(moreLine.frame) - Adaptive(17.5),
                                              Adaptive(14.5),
                                              Adaptive(17.5));
            [_addUserButton setBackgroundImage:[UIImage imageNamed:@"MyDairy_add"] forState:UIControlStateNormal];
            [self addSubview:_addUserButton];
        }
        
        
        verticalLine.frame = CGRectMake(Adaptive(18.5),
                                        0,
                                        1,
                                        CGRectGetMaxY(coach_content.frame) + Adaptive(26));
        
    } else {
        NSDictionary *photoDict = dairy.photoArray[0];
        
        [shareImageView sd_setImageWithURL:[NSURL URLWithString:[photoDict objectForKey:@"img"]]];
        verticalLine.frame = CGRectMake(Adaptive(18.5),
                                        0,
                                        1,
                                        CGRectGetMaxY(coach_content.frame));
    }
    
    Frame.size.height =  CGRectGetMaxY(verticalLine.frame) - Adaptive(5);
    self.frame = Frame;
}

@end
