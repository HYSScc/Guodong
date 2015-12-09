//
//  TableViewCell_total.m
//  果动
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "TableViewCell_total.h"
#import "Commonality.h"
#import "SJAvatarBrowser.h"
@implementation TableViewCell_total

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //235  117  32
        self.backgroundColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
        self.userInteractionEnabled = YES;
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight/9.529, viewWidth, 0.5)];
        lineLabel.backgroundColor = [UIColor grayColor];
        [self addSubview:lineLabel];
        
        
        UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth-viewHeight/16.675, viewHeight/9.529)];
        baseView.userInteractionEnabled = NO;
        baseView.backgroundColor =[UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1];
        [self addSubview:baseView];
        
        
        
        
        
        self.classLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308, viewHeight/44.467, viewWidth*.7, viewHeight/33.35)];
        //   self.classLabel.backgroundColor = [UIColor orangeColor];
        [baseView addSubview:self.classLabel];
        
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308, CGRectGetMaxY(self.classLabel.frame)+viewHeight/133.4, viewHeight/9.529, viewHeight/66.7)];
        self.dateLabel.text = @"2015/8/19";
        self.dateLabel.textColor = [UIColor lightGrayColor];
        self.dateLabel.font = [UIFont fontWithName:FONT size:viewHeight/60.636];
        [baseView addSubview:self.dateLabel];
        
        
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/2.382, (baseView.bounds.size.height - viewHeight/44.467)/2 , viewHeight/13.34, viewHeight/44.467)];
        self.statusLabel.textColor = [UIColor colorWithRed:235.00/255 green:117.00/255 blue:32.00/255 alpha:1];
        self.statusLabel.text = @"进行中...";
        self.statusLabel.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
        [baseView addSubview:self.statusLabel];
        
        
        self.nextImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewHeight/1.911, viewHeight/20.844, viewHeight/55.583, viewHeight/111.167)];
        [self.nextImageView setImage:[UIImage imageNamed:@"dingdan_cellshang"]];
        [self addSubview:self.nextImageView];
        
        self.jiantouButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.jiantouButton.frame = CGRectMake(CGRectGetMaxX(baseView.frame), 0, viewHeight/16.675, viewHeight/9.529);
        //    self.jiantouButton.backgroundColor = [UIColor redColor];
        [self addSubview:self.jiantouButton];
        
        
        /***********详情View*******************/
        self.ccView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(baseView.frame), viewWidth, viewHeight/5.558)];
        self.ccView.userInteractionEnabled = YES;
        self.ccView.backgroundColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
        
        
        UILabel *topline = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 0.5)];
        topline.backgroundColor = [UIColor lightGrayColor];
        [self.ccView addSubview:topline];
        
        UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewHeight/33.35, viewHeight/60.636, viewHeight/55.583, viewHeight/44.467)];
        [titleImage setImage:[UIImage imageNamed:@"dingdan_celltitle"]];
        titleImage.alpha = 1;
        [self.ccView addSubview:titleImage];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleImage.frame)+viewHeight/133.4, viewHeight/60.636, viewHeight/9.529, viewHeight/44.467)];
        label1.text = @"订单详情";
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont fontWithName: FONT size:viewHeight/51.308];
        [self.ccView addSubview:label1];
        
        UILabel *nextline = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight/17.553, viewWidth, 0.5)];
        nextline.backgroundColor = [UIColor lightGrayColor];
        [self.ccView addSubview:nextline];
        
        NSArray *tArray = @[@"学员:",@"时间:",@"地址:",@"教练:",@"性别:",@"负责课程:"];
        for (int a = 0; a < 3; a++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/33.35, CGRectGetMaxY(nextline.frame)+(viewHeight/66.7)+a*(viewHeight/33.35), viewHeight/16.675, viewHeight/33.35)];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
            label.text = tArray[a];
            [self.ccView addSubview:label];
            
        }
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/11.117, CGRectGetMaxY(nextline.frame)+viewHeight/66.7, viewHeight/4.447, viewHeight/33.35)];
        self.name.textColor = [UIColor whiteColor];
        self.name.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
        self.name.text = @"YOKOX";
        [self.ccView addSubview:self.name];
        
        self.number = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/2.565, CGRectGetMaxY(nextline.frame)+viewHeight/66.7, viewHeight/6.67, viewHeight/33.35)];
        self.number.textColor = [UIColor colorWithRed:235.00/255 green:117.00/255 blue:32.00/255 alpha:1];
        self.number.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
        self.number.text = @"18289245331";
        [self.ccView addSubview:self.number];
        
        self.datetime = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/11.117, CGRectGetMaxY(self.name.frame), viewHeight/4.447, viewHeight/33.35)];
        self.datetime.textColor = [UIColor whiteColor];
        // self.datetime.backgroundColor = [UIColor orangeColor];
        self.datetime.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
        self.datetime.text = @"2015/8/19 14:00";
        [self.ccView addSubview:self.datetime];
        
        self.address = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/11.17, CGRectGetMaxY(self.datetime.frame), viewHeight/1.778, viewHeight/33.35)];
        self.address.textColor = [UIColor whiteColor];
        // self.address.backgroundColor = [UIColor orangeColor];
        self.address.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
        self.address.text = @"北京市朝阳区和平北路胜利大街北洋都市小区";
        [self.ccView addSubview:self.address];
        
        self.coachView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(nextline.frame) + viewHeight/8.3375, viewWidth, viewHeight/8.3375)];
        self.coachView.backgroundColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
        self.coachView.userInteractionEnabled = YES;
        //   [self.ccView addSubview:coachView];
        
        UILabel *centeiline = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/33.35, 0, viewWidth-(viewHeight/16.675), 0.5)];
        centeiline.backgroundColor = [UIColor lightGrayColor];
        [self.coachView addSubview:centeiline];
        
        for (int a = 0; a < 3; a++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/33.35, CGRectGetMaxY(centeiline.frame)  + viewHeight/66.7+a*(viewHeight/33.35), viewHeight/11.117, viewHeight/33.35)];
            label.textColor = [UIColor whiteColor];
            label.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
            label.text = tArray[a+3];
            [self.coachView addSubview:label];
            
        }
        
        self.coachName = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/11.167, CGRectGetMaxY(centeiline.frame) +viewHeight/66.7, viewHeight/4.447, viewHeight/33.35)];
        self.coachName.textColor = [UIColor whiteColor];
        self.coachName.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
        self.coachName.text = @"TOM";
        [self.coachView addSubview:self.coachName];
        
        self.coachSex = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/11.167, CGRectGetMaxY(self.coachName.frame), viewHeight/13.34, viewHeight/33.35)];
        self.coachSex.textColor = [UIColor whiteColor];
        self.coachSex.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
        self.coachSex.text = @"男";
        [self.coachView addSubview:self.coachSex];
        
        self.coachClass = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/7.947, CGRectGetMaxY(self.coachSex.frame), viewWidth/1.9 , 26)];
        self.coachClass.numberOfLines = 0;
        self.coachClass.textColor = [UIColor whiteColor];
       // self.coachClass.backgroundColor = [UIColor orangeColor];
        self.coachClass.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
        self.coachClass.text = @"健身私教、急速康复、疯狂甩脂";
        [self.coachView addSubview:self.coachClass];
        
        self.coachImg = [[UIImageView alloc] initWithFrame:CGRectMake(viewHeight/2.3, (self.coachView.bounds.size.height - viewHeight/11.167)/2, viewHeight/11.167, viewHeight/11.167)];
        //self.coachImg.backgroundColor = [UIColor lightGrayColor];
        self.coachImg.layer.cornerRadius = 6;
        self.coachImg.layer.masksToBounds = YES;
        self.coachImg.userInteractionEnabled = YES;
        [self.coachView addSubview:self.coachImg];
        
        //添加点击手势
        UITapGestureRecognizer *tap  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage)];
        [self.coachImg addGestureRecognizer:tap];
        
        UILabel *lastline = [[UILabel alloc] initWithFrame:CGRectMake(0, self.ccView.bounds.size.height - 1, viewWidth, 0.5)];
        lastline.backgroundColor = [UIColor lightGrayColor];
        [self.ccView addSubview:lastline];
        
        
        
    }
    return self;
}
-(void)magnifyImage
{
    NSLog(@"点击手势");
    [SJAvatarBrowser showImage:self.coachImg];
}

@end
