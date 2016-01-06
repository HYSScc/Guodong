//
//  TableViewCell_total.m
//  果动
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "Commonality.h"
#import "SJAvatarBrowser.h"
#import "TableViewCell_total.h"
@implementation TableViewCell_total

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //235  117  32
        self.backgroundColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1];
        self.userInteractionEnabled = YES;
        UILabel* lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Adaptive(70), viewWidth, 0.5)];
        lineLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:lineLabel];

        UIView* baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth - Adaptive(40), Adaptive(70))];
        baseView.userInteractionEnabled = NO;
        baseView.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:63 / 255.0 blue:63 / 255.0 alpha:1];
        [self addSubview:baseView];

        self.classLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(13), Adaptive(15), viewWidth * .7, Adaptive(20))];
        //   self.classLabel.backgroundColor = [UIColor orangeColor];
        [baseView addSubview:self.classLabel];

        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(13), CGRectGetMaxY(self.classLabel.frame) + Adaptive(5), Adaptive(70), Adaptive(10))];
        self.dateLabel.text = @"2015/8/19";
        self.dateLabel.textColor = [UIColor lightGrayColor];
        self.dateLabel.font = [UIFont fontWithName:FONT size:Adaptive(11)];
        [baseView addSubview:self.dateLabel];

        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(280), (baseView.bounds.size.height - Adaptive(15)) / 2, Adaptive(50), Adaptive(10))];
        self.statusLabel.textColor = [UIColor colorWithRed:235.00 / 255 green:117.00 / 255 blue:32.00 / 255 alpha:1];
        self.statusLabel.text = @"进行中...";
        self.statusLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        [baseView addSubview:self.statusLabel];

        self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(349), Adaptive(32), Adaptive(12), Adaptive(6))];
        [self.nextImageView setImage:[UIImage imageNamed:@"dingdan_cellshang"]];
        [self addSubview:self.nextImageView];

        self.jiantouButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.jiantouButton.frame = CGRectMake(CGRectGetMaxX(baseView.frame), 0, Adaptive(40), Adaptive(70));
        //    self.jiantouButton.backgroundColor = [UIColor redColor];
        [self addSubview:self.jiantouButton];

        /***********详情View*******************/
        self.ccView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(baseView.frame), viewWidth, Adaptive(120))];
        self.ccView.userInteractionEnabled = YES;
        self.ccView.backgroundColor = [UIColor colorWithRed:127 / 255.0 green:127 / 255.0 blue:127 / 255.0 alpha:1];

        UILabel* topline = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0.5)];
        topline.backgroundColor = [UIColor lightGrayColor];
        [self.ccView addSubview:topline];

        UIImageView* titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(20), Adaptive(11), Adaptive(12), Adaptive(15))];
        [titleImage setImage:[UIImage imageNamed:@"dingdan_celltitle"]];
        titleImage.alpha = 1;
        [self.ccView addSubview:titleImage];

        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame) + Adaptive(5), Adaptive(11), Adaptive(70), Adaptive(15))];
        label1.text = @"订单详情";
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self.ccView addSubview:label1];

        UILabel* nextline = [[UILabel alloc] initWithFrame:CGRectMake(0, Adaptive(38), viewWidth, 0.5)];
        nextline.backgroundColor = [UIColor lightGrayColor];
        [self.ccView addSubview:nextline];

        NSArray* tArray = @[ @"学员:", @"时间:", @"地址:"];
        for (int a = 0; a < 3; a++) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(20), CGRectGetMaxY(nextline.frame) + Adaptive(10) + a * Adaptive(20), Adaptive(40), Adaptive(20))];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:FONT size:Adaptive(13)];
            label.text = tArray[a];
            [self.ccView addSubview:label];
        }
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(60), CGRectGetMaxY(nextline.frame) + Adaptive(10), Adaptive(150), Adaptive(20))];
        self.name.textColor = [UIColor whiteColor];
        self.name.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        self.name.text = @"YOKOX";
        [self.ccView addSubview:self.name];

        self.number = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(260), CGRectGetMaxY(nextline.frame) + Adaptive(10), Adaptive(100), Adaptive(20))];
        self.number.textColor = [UIColor colorWithRed:235.00 / 255 green:117.00 / 255 blue:32.00 / 255 alpha:1];
        self.number.textAlignment = 2;
        self.number.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        self.number.text = @"18289245331";
        [self.ccView addSubview:self.number];

        //退单按钮
        self.chargeback = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.chargeback.frame = CGRectMake(viewWidth - Adaptive(20) - Adaptive(58), CGRectGetMaxY(self.number.frame) + Adaptive(10), Adaptive(58), Adaptive(25));
        [self.chargeback setBackgroundImage:[UIImage imageNamed:@"chargeback"] forState:UIControlStateNormal];
        
              //退单View
        self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.ccView.frame) - Adaptive(70), viewWidth, Adaptive(80))];
     
        self.backView.userInteractionEnabled = YES;
        
        
        UILabel *introLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(13), Adaptive(12), viewWidth - Adaptive(26), Adaptive(13))];
        introLabel.text = @"退单后，订单将会消失，是否确定取消订课？";
        introLabel.textAlignment = 1;
        introLabel.textColor = [UIColor whiteColor];
        introLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        [self.backView addSubview:introLabel];
        
        self.backCancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.backCancelButton.frame = CGRectMake(Adaptive(90), CGRectGetMaxY(introLabel.frame) + Adaptive(12), Adaptive(83), Adaptive(30));
        [self.backCancelButton setBackgroundImage:[UIImage imageNamed:@"back_cancel"] forState:UIControlStateNormal];
        
        
        self.backSureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.backSureButton.frame = CGRectMake(CGRectGetMaxX(self.backCancelButton.frame) + Adaptive(30), CGRectGetMaxY(introLabel.frame) + Adaptive(12), Adaptive(83), Adaptive(30));
        [self.backSureButton setBackgroundImage:[UIImage imageNamed:@"back_sure"] forState:UIControlStateNormal];
        
        
        
        self.datetime = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(60), CGRectGetMaxY(self.name.frame),Adaptive(150), Adaptive(20))];
        self.datetime.textColor = [UIColor whiteColor];
        // self.datetime.backgroundColor = [UIColor orangeColor];
        self.datetime.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        self.datetime.text = @"2015/8/19 14:00";
        [self.ccView addSubview:self.datetime];

        self.address = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(60), CGRectGetMaxY(self.datetime.frame), Adaptive(375), Adaptive(20))];
        self.address.textColor = [UIColor whiteColor];
        // self.address.backgroundColor = [UIColor orangeColor];
        self.address.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        self.address.text = @"北京市朝阳区和平北路胜利大街北洋都市小区";
        [self.ccView addSubview:self.address];
        
     
        UILabel* lastline = [[UILabel alloc] initWithFrame:CGRectMake(0, self.ccView.bounds.size.height - 1, viewWidth, 0.5)];
        lastline.backgroundColor = [UIColor lightGrayColor];
        [self.ccView addSubview:lastline];
    }
    return self;
}

@end

//教练接单
@implementation TableViewCell_haveCoach

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //教练信息
        
        UILabel* nextline = [[UILabel alloc] initWithFrame:CGRectMake(0, Adaptive(38), viewWidth, 0.5)];
        nextline.backgroundColor = [UIColor lightGrayColor];
        [self.ccView addSubview:nextline];
       
        NSArray* tArray = @[@"教练:", @"性别:", @"负责课程:"];
        
        self.coachView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nextline.frame) + Adaptive(80), viewWidth, Adaptive(80))];
        self.coachView.backgroundColor = [UIColor colorWithRed:127 / 255.0 green:127 / 255.0 blue:127 / 255.0 alpha:1];
        self.coachView.userInteractionEnabled = YES;
        
        UILabel* centeiline = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(20), 0, viewWidth - Adaptive(40), 0.5)];
        centeiline.backgroundColor = [UIColor lightGrayColor];
        [self.coachView addSubview:centeiline];
        
        for (int a = 0; a < 3; a++) {
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(20), CGRectGetMaxY(centeiline.frame) + Adaptive(10) + a * Adaptive(20),Adaptive(60), Adaptive(20))];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:FONT size:Adaptive(13)];
            label.text = tArray[a];
            [self.coachView addSubview:label];
        }
        
        self.coachName = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(60), CGRectGetMaxY(centeiline.frame) + Adaptive(10), Adaptive(150),Adaptive(20))];
        self.coachName.textColor = [UIColor whiteColor];
        self.coachName.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        self.coachName.text = @"TOM";
        [self.coachView addSubview:self.coachName];
        
        self.coachSex = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(60), CGRectGetMaxY(self.coachName.frame), Adaptive(50), Adaptive(20))];
        self.coachSex.textColor = [UIColor whiteColor];
        self.coachSex.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        self.coachSex.text = @"男";
        [self.coachView addSubview:self.coachSex];
        
        self.coachClass = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(84), CGRectGetMaxY(self.coachSex.frame), Adaptive(198), Adaptive(27))];
        self.coachClass.numberOfLines = 0;
        self.coachClass.textColor = [UIColor whiteColor];
        self.coachClass.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        self.coachClass.text = @"健身私教、急速康复、疯狂甩脂";
        [self.coachView addSubview:self.coachClass];
        
        self.coachImg = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(290), (self.coachView.bounds.size.height - Adaptive(60)) / 2, Adaptive(60), Adaptive(60))];
        self.coachImg.layer.cornerRadius = 6;
        self.coachImg.layer.masksToBounds = YES;
        self.coachImg.userInteractionEnabled = YES;
        [self.coachView addSubview:self.coachImg];
        
        //添加点击手势
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
        [self.coachImg addGestureRecognizer:tap];

    }
    return self;
}
- (void)magnifyImage
{
    NSLog(@"点击手势");
    [SJAvatarBrowser showImage:self.coachImg];
}
@end

