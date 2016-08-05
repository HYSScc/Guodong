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
    UILabel *classDate;
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
                                        Adaptive(10),
                                        Adaptive(40),
                                        Adaptive(15));
        title_User.text      = @"会员:";
        title_User.textColor = [UIColor whiteColor];
        title_User.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:title_User];
        
        useName       = [UILabel new];
        useName.frame = CGRectMake(CGRectGetMaxX(title_User.frame),
                                   Adaptive(10),
                                   Adaptive(100),
                                   Adaptive(15));
        useName.textColor = [UIColor whiteColor];
        useName.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:useName];
        
        UILabel *title_photo = [UILabel new];
        title_photo.frame    = CGRectMake(CGRectGetMaxX(useName.frame),
                                          Adaptive(10),
                                          Adaptive(40),
                                          Adaptive(15));
        title_photo.text      = @"手机:";
        title_photo.textColor = [UIColor whiteColor];
        title_photo.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:title_photo];
        
        photoNumber       = [UILabel new];
        photoNumber.frame = CGRectMake(CGRectGetMaxX(title_photo.frame),
                                       Adaptive(10),
                                       viewWidth - Adaptive(13) - CGRectGetMaxX(title_photo.frame),
                                       Adaptive(15));
        photoNumber.textColor = [UIColor whiteColor];
        photoNumber.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:photoNumber];
        
        UILabel *title_date = [UILabel new];
        title_date.frame    = CGRectMake(Adaptive(13),
                                         CGRectGetMaxY(title_User.frame) + Adaptive(10),
                                         Adaptive(40),
                                         Adaptive(15));
        title_date.text      = @"日期:";
        title_date.textColor = [UIColor whiteColor];
        title_date.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:title_date];
        
        classDate       = [UILabel new];
        classDate.frame = CGRectMake(CGRectGetMaxX(title_date.frame),
                                     CGRectGetMaxY(title_User.frame) + Adaptive(10),
                                     Adaptive(100),
                                     Adaptive(15));
        classDate.textColor = [UIColor whiteColor];
        classDate.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:classDate];
        
        
        UILabel *title_time = [UILabel new];
        title_time.frame    = CGRectMake(CGRectGetMaxX(classDate.frame),
                                            CGRectGetMaxY(title_photo.frame) + Adaptive(10),
                                            Adaptive(40),
                                            Adaptive(15));
        title_time.text      = @"时间:";
        title_time.textColor = [UIColor whiteColor];
        title_time.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:title_time];
        
        
        classTime       = [UILabel new];
        classTime.frame = CGRectMake(CGRectGetMaxX(title_time.frame),
                                     CGRectGetMaxY(title_User.frame) + Adaptive(10),
                                     Adaptive(100),
                                     Adaptive(15));
        classTime.textColor = [UIColor whiteColor];
        classTime.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:classTime];
        
        
        UILabel *title_address = [UILabel new];
        title_address.frame    = CGRectMake(Adaptive(13),
                                         CGRectGetMaxY(title_date.frame) + Adaptive(10),
                                         Adaptive(40),
                                         Adaptive(15));
        title_address.text      = @"地址:";
        title_address.textColor = [UIColor whiteColor];
        title_address.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self addSubview:title_address];
        
        
        
        address       = [UILabel new];
        address.frame = CGRectMake(CGRectGetMaxX(title_address.frame),
                                   CGRectGetMaxY(title_date.frame) + Adaptive(10),
                                   viewWidth - CGRectGetMaxX(title_address.frame),
                                   Adaptive(15));
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
    
    classDate.text   = confromTimespStr;
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateStyle:NSDateFormatterMediumStyle];
    [timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSDate *timeConfromTimesp      = [NSDate dateWithTimeIntervalSince1970:[dataModel.pre_time intValue]];
    NSString *timeConfromTimespStr = [timeFormatter stringFromDate:timeConfromTimesp];
    
    classTime.text   = timeConfromTimespStr;
    
    
    
    

    address.text = dataModel.userPlace;
    
   
    
    line.frame = CGRectMake(Adaptive(13),
                            CGRectGetMaxY(address.frame) + Adaptive(10),
                            viewWidth - Adaptive(26),
                            .5);
    
    CGRect Frame      = self.frame;
    Frame.size.height = CGRectGetMaxY(line.frame);
    self.frame        = Frame;
    
}
@end
