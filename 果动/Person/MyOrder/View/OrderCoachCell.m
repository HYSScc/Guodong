//
//  OrderCoachCell.m
//  果动
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "OrderDataModel.h"
#import "OrderCoachCell.h"

@implementation OrderCoachCell
{
    UILabel     *coachName;
    UILabel     *coachSex;
    UIImageView *headImageView;
    UILabel     *line;
    UILabel     *isCoachLabel;
    UILabel *title_Name;
    UILabel *title_sex;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = BASEGRYCOLOR;
        
       title_Name = [UILabel new];
        title_Name.frame    = CGRectMake(Adaptive(13),
                                         Adaptive(10),
                                         Adaptive(40),
                                         Adaptive(15));
        title_Name.text      = @"教练:";
        title_Name.textColor = [UIColor whiteColor];
        title_Name.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        
        
        coachName       = [UILabel new];
        coachName.frame = CGRectMake(CGRectGetMaxX(title_Name.frame),
                                     Adaptive(10),
                                     Adaptive(100),
                                     Adaptive(15));
        coachName.textColor = [UIColor whiteColor];
        coachName.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        
        
        title_sex = [UILabel new];
        title_sex.frame    = CGRectMake(CGRectGetMaxX(coachName.frame),
                                        Adaptive(10),
                                        Adaptive(40),
                                        Adaptive(15));
        title_sex.text      = @"性别:";
        title_sex.textColor = [UIColor whiteColor];
        title_sex.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        
        
        coachSex       = [UILabel new];
        coachSex.frame = CGRectMake(CGRectGetMaxX(title_sex.frame),
                                    Adaptive(10),
                                    Adaptive(100),
                                    Adaptive(15));
        coachSex.textColor = [UIColor whiteColor];
        coachSex.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        
        
        
        headImageView       = [UIImageView new];
        headImageView.frame = CGRectMake(viewWidth - Adaptive(13) - Adaptive(47),
                                         Adaptive(10),
                                         Adaptive(47),
                                         Adaptive(47));
        headImageView.layer.cornerRadius  = headImageView.bounds.size.width / 2;
        headImageView.layer.masksToBounds = YES;
        
        
        line = [UILabel new];
        line.backgroundColor = BASECOLOR;
        [self addSubview:line];
        
    }
    return self;
}

- (void)setDataModel:(OrderDataModel *)dataModel {
    
    
    if (dataModel.coach_info.count != 0) {
        [self addSubview:title_Name];
        [self addSubview:title_sex];
        [self addSubview:coachName];
        [self addSubview:coachSex];
        [self addSubview:headImageView];
        
        coachName.text = dataModel.coachName;
        coachSex.text  = dataModel.coachSex;
        
        
        [headImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.coachHeadImgUrl] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
        
    } else {
        [title_Name removeFromSuperview];
        [title_sex removeFromSuperview];
        [coachName removeFromSuperview];
        [coachSex removeFromSuperview];
        [headImageView removeFromSuperview];
    }
    line.frame = CGRectMake(0,
                            CGRectGetMaxY(headImageView.frame) + Adaptive(10),
                            viewWidth,
                            .5);
    
    CGRect Frame      = self.frame;
    Frame.size.height = CGRectGetMaxY(line.frame);
    self.frame        = Frame;
}
@end
