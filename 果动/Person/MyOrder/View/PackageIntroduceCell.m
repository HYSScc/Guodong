//
//  PackageIntroduceCell.m
//  果动
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "OrderDataModel.h"
#import "PackageIntroduceCell.h"

@implementation PackageIntroduceCell
{
    UILabel *packageName;
    UILabel *payStatus;
    UILabel *packageContent;
    UILabel *pay_amount;
    UILabel *reward;
    UILabel *totalAmount;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor = BASEGRYCOLOR;
        packageName          = [UILabel new];
        packageName.frame    = CGRectMake(Adaptive(13),
                                          Adaptive(10),
                                          viewWidth / 2,
                                          Adaptive(15));
        packageName.textColor = ORANGECOLOR;
        packageName.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        [self addSubview:packageName];
        
        payStatus       = [UILabel new];
        payStatus.frame = CGRectMake(viewWidth - Adaptive(113),
                                     Adaptive(10),
                                     Adaptive(100),
                                     Adaptive(15));
        payStatus.textColor = ORANGECOLOR;
        payStatus.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        payStatus.textAlignment = 2;
        [self addSubview:payStatus];
        
        UILabel *lineOne = [UILabel new];
        lineOne.frame    = CGRectMake(0,
                                      CGRectGetMaxY(packageName.frame) + Adaptive(10),
                                      viewWidth,
                                      .5);
        lineOne.backgroundColor = BASECOLOR;
        [self addSubview:lineOne];
        
        packageContent       = [UILabel new];
        packageContent.frame = CGRectMake(Adaptive(13),
                                          CGRectGetMaxY(lineOne.frame) + Adaptive(10),
                                          viewWidth / 2,
                                          Adaptive(15));
        packageContent.textColor = [UIColor whiteColor];
        packageContent.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        [self addSubview:packageContent];
        
        pay_amount       = [UILabel new];
        pay_amount.frame = CGRectMake(viewWidth - Adaptive(113),
                                      CGRectGetMaxY(lineOne.frame) + Adaptive(10),
                                      Adaptive(100),
                                      Adaptive(15));
        pay_amount.textColor = [UIColor whiteColor];
        pay_amount.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        pay_amount.textAlignment = 2;
        [self addSubview:pay_amount];
        
        
//        reward       = [UILabel new];
//        reward.frame = CGRectMake(Adaptive(13),
//                                  CGRectGetMaxY(packageContent.frame) + Adaptive(10),
//                                  viewWidth / 2,
//                                  Adaptive(15));
//        reward.textColor = [UIColor whiteColor];
//        reward.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
//        [self addSubview:reward];
//        
//        UILabel *rewardAmount = [UILabel new];
//        rewardAmount.frame    = CGRectMake(viewWidth - Adaptive(113),
//                                        CGRectGetMaxY(pay_amount.frame) + Adaptive(10),
//                                        Adaptive(100),
//                                        Adaptive(15));
//        rewardAmount.textColor = [UIColor whiteColor];
//        rewardAmount.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
//        rewardAmount.textAlignment = 2;
//     //   rewardAmount.text      = @"￥0.00";
//        [self addSubview:rewardAmount];
        
        UILabel *lineTwo = [UILabel new];
        lineTwo.frame    = CGRectMake(0,
                                      CGRectGetMaxY(packageContent.frame) + Adaptive(10),
                                      viewWidth,
                                      .5);
        lineTwo.backgroundColor = BASECOLOR;
        [self addSubview:lineTwo];
        
        totalAmount       = [UILabel new];
        totalAmount.frame = CGRectMake(viewWidth / 2,
                                       CGRectGetMaxY(lineTwo.frame) + Adaptive(10),
                                       viewWidth / 2 - Adaptive(13),
                                       Adaptive(15));
        totalAmount.textColor = ORANGECOLOR;
        totalAmount.textAlignment = 2;
        totalAmount.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        [self addSubview:totalAmount];
        
    }
    return self;
}

- (void)setDataModel:(OrderDataModel *)dataModel {
    
    packageName.text    = dataModel.package_name;
    payStatus.text      = dataModel.pay_status;
    packageContent.text = dataModel.package_content;
    pay_amount.text     = [NSString stringWithFormat:@"￥%@",dataModel.pay_amount];
 //   reward.text         = dataModel.reward;
    totalAmount.text    = [NSString stringWithFormat:@"合计: ￥%@",dataModel.pay_amount];
    
    CGRect Frame      = self.frame;
    Frame.size.height = CGRectGetMaxY(totalAmount.frame) + Adaptive(10);
    self.frame        = Frame;
}

@end
