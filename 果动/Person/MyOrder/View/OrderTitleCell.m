//
//  OrderTitleCell.m
//  果动
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "OrderDataModel.h"
#import "OrderTitleCell.h"

@implementation OrderTitleCell
{
    UILabel *className;
    UILabel *classNumber;
    UILabel *classStatus;
    UILabel *line;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = BASEGRYCOLOR;
        
        className       = [UILabel new];
        
        className.textColor = ORANGECOLOR;
        className.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        [self addSubview:className];
        
        
//        classNumber       = [UILabel new];
//        
//        classNumber.font  = [UIFont fontWithName:FONT size:Adaptive(13)];
//        [self addSubview:classNumber];
        
        classStatus       = [UILabel new];
        
        classStatus.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        classStatus.textColor = ORANGECOLOR;
        classStatus.textAlignment = 2;
        [self addSubview:classStatus];
        
        line       = [UILabel new];
        
        line.backgroundColor = BASECOLOR;
        [self addSubview:line];
    }
    return self;
}
- (void)setDataModel:(OrderDataModel *)dataModel {
    
    className.text   = dataModel.courseName;
    
    CGSize classNameSize = [dataModel.courseName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]}];
    
    className.frame = CGRectMake(Adaptive(13),
                                 (Adaptive(44) - classNameSize.height) / 2,
                                 classNameSize.width,
                                 classNameSize.height);
    
//    classNumber.frame = CGRectMake(CGRectGetMaxX(className.frame) + Adaptive(5),
//                                   (Adaptive(44) - classNameSize.height) / 2,
//                                   viewWidth / 3,
//                                   classNameSize.height);
    
    classStatus.frame = CGRectMake(viewWidth - Adaptive(13) - (viewWidth / 3),
                                   (Adaptive(44) - classNameSize.height) / 2,
                                   viewWidth / 3,
                                  classNameSize.height);
    
    
    classStatus.text = dataModel.statusName;
    line.frame       = CGRectMake(0,
                                  Adaptive(43.5),
                                  viewWidth,
                                  .5);
    CGRect Frame      = self.frame;
    Frame.size.height = Adaptive(44);
    self.frame        = Frame;
    
    
}
@end
