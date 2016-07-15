//
//  OrderUserCell.m
//  果动
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "OrderDataModel.h"
#import "OrderUserCell.h"

@implementation OrderUserCell
{
    UILabel *useName;
    UILabel *photoNumber;
    UILabel *classTime;
    UILabel *address;
    UILabel *line;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor = BASEGRYCOLOR;
        
        UILabel *title_User = [UILabel new];
        title_User.frame    = CGRectMake(Adaptive(13),
                                        Adaptive(5),
                                        Adaptive(60),
                                        Adaptive(20));
        title_User.text      = @"会员:";
        title_User.textColor = [UIColor whiteColor];
        title_User.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:title_User];
        
        useName       = [UILabel new];
        useName.frame = CGRectMake(CGRectGetMaxX(title_User.frame),
                                   Adaptive(5),
                                   Adaptive(100),
                                   Adaptive(20));
        useName.textColor = [UIColor whiteColor];
        useName.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:useName];
        
        UILabel *title_photo = [UILabel new];
        title_photo.frame    = CGRectMake(CGRectGetMaxX(useName.frame),
                                          Adaptive(5),
                                          Adaptive(35),
                                          Adaptive(20));
        title_photo.text      = @"手机:";
        title_photo.textColor = [UIColor whiteColor];
        title_photo.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:title_photo];
        
        photoNumber       = [UILabel new];
        photoNumber.frame = CGRectMake(CGRectGetMaxX(title_photo.frame),
                                       Adaptive(5),
                                       viewWidth - Adaptive(13) - CGRectGetMaxX(title_photo.frame),
                                       Adaptive(20));
        photoNumber.textColor = [UIColor whiteColor];
        photoNumber.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:photoNumber];
        
        UILabel *title_time = [UILabel new];
        title_time.frame    = CGRectMake(Adaptive(13),
                                         CGRectGetMaxY(title_User.frame) + Adaptive(5),
                                         Adaptive(60),
                                         Adaptive(20));
        title_time.text      = @"上课时间:";
        title_time.textColor = [UIColor whiteColor];
        title_time.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:title_time];
        
        classTime       = [UILabel new];
        classTime.frame = CGRectMake(CGRectGetMaxX(title_time.frame),
                                     CGRectGetMaxY(title_User.frame) + Adaptive(5),
                                     Adaptive(100),
                                     Adaptive(20));
        classTime.textColor = [UIColor whiteColor];
        classTime.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:classTime];
        
        
        UILabel *title_address = [UILabel new];
        title_address.frame    = CGRectMake(CGRectGetMaxX(classTime.frame),
                                            CGRectGetMaxY(title_photo.frame) + Adaptive(5),
                                            Adaptive(35),
                                            Adaptive(20));
        title_address.text      = @"地址:";
        title_address.textColor = [UIColor whiteColor];
        title_address.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:title_address];
        
        address       = [UILabel new];
        address.numberOfLines = 0;
        address.textColor = [UIColor whiteColor];
        address.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:address];
        
        
        line = [UILabel new];
        line.backgroundColor = BASECOLOR;
        [self addSubview:line];
        
    }
    return self;
}

- (void)setDataModel:(OrderDataModel *)dataModel {
    
    useName.text     = dataModel.userName;
    photoNumber.text = dataModel.photoNumber;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *confromTimesp      = [NSDate dateWithTimeIntervalSince1970:[dataModel.pre_time intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    classTime.text   = confromTimespStr;
    
   CGSize addressSize = [dataModel.userPlace boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(221), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(14)]} context:nil].size;
    
    CGFloat  addressHight;
    if (addressSize.height < Adaptive(20)) {
        addressHight = Adaptive(20);
    } else {
        addressHight = addressSize.height;
    }
    
    address.frame = CGRectMake(Adaptive(213),
                               Adaptive(30),
                               viewWidth - Adaptive(221),
                              addressHight);
    address.text = dataModel.userPlace;
    
    line.frame = CGRectMake(Adaptive(13),
                            CGRectGetMaxY(address.frame) + Adaptive(5),
                            viewWidth - Adaptive(26),
                            .5);
    
    CGRect Frame      = self.frame;
    Frame.size.height = CGRectGetMaxY(line.frame);
    self.frame        = Frame;
    
}
@end
