//
//  ExerciseDetail.m
//  果动
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//




#import "ExerciseDetail.h"
#import "ExerciseDetailComment.h"

#import "SJAvatarBrowser.h"
@interface ExerciseDetail () {
    UIScrollView* scroll;
    UIImageView* leftImageView;
    UIImageView* rightImageView;
    UILabel* oldtime;
    UILabel* nowtime;
    UIScrollView* imgscroll;
    UILabel* orangeline;
    UIImageView* rightdian;
    UILabel* timelabel;
}
@end

@implementation ExerciseDetail

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"我的数据"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"身体数据" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;

    self.view.backgroundColor = BASECOLOR;
    UIImageView* image1line = [UIImageView new];
    image1line.image = [UIImage imageNamed:@"home__line1"];
    image1line.frame = CGRectMake(0, 0, viewWidth, 0.5);
    [self.view addSubview:image1line];

    [self initView];
    [self getdata];

    NSLog(@"IDIDIDID  %@", self.ID);
}
- (void)initView
{
    NSArray* titleArray = @[ @"身高", @"体重", @"腰围", @"臀围", @"右大腿", @"左大腿", @"右小腿", @"左小腿", @"右上臂(放松)", @"右上臂(屈曲)", @"左上臂(放松)", @"左上臂(屈曲)", @"胸围(放松)", @"胸围(扩张)", @"肱三头肌", @"髋嵴上缘", @"肩胛下缘", @"腹部", @"大腿", @"总和", @"脂肪百分比", @"腰臀比例", @"BMI", @"静态心率", @"血压", @"目标心率" ];

    timelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Adaptive(70), Adaptive(40))];
    timelabel.backgroundColor = [UIColor orangeColor];
    timelabel.text = @"时间";
    timelabel.textAlignment = 1;
    timelabel.textColor = [UIColor whiteColor];
    timelabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    [self.view addSubview:timelabel];

    oldtime = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(70) + (viewWidth - Adaptive(70)) * 0.25 - Adaptive(35), Adaptive(3), Adaptive(70), Adaptive(15))];
    oldtime.textColor = [UIColor lightGrayColor];
    oldtime.textAlignment = 1;
    oldtime.font = [UIFont fontWithName:FONT size:Adaptive(10)];
    [self.view addSubview:oldtime];

    nowtime = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(70) + (viewWidth - Adaptive(70)) * 0.75 - Adaptive(35), Adaptive(3), Adaptive(70), Adaptive(15))];
    nowtime.textColor = [UIColor whiteColor];
    nowtime.textAlignment = 1;
    nowtime.font = [UIFont fontWithName:FONT size:Adaptive(10)];

    orangeline = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(timelabel.frame), Adaptive(25), (viewWidth - Adaptive(70)) * 0.25, 1)];
    orangeline.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:orangeline];

    UILabel* timeline = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timelabel.frame), viewWidth, 0.5)];
    timeline.backgroundColor = [UIColor lightGrayColor];
    //  timeline.alpha = .8;
    [self.view addSubview:timeline];

    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Adaptive(40), viewWidth, viewHeight - NavigationBar_Height)];
    //是否允许弹性滑动
    scroll.userInteractionEnabled = YES;
    scroll.bounces = NO;
    if (IS_IPHONE4S) {
        scroll.contentSize = CGSizeMake(viewWidth, viewHeight * 3.3);
    }
    else {
        scroll.contentSize = CGSizeMake(viewWidth, viewHeight * 2);
    }
    [self.view addSubview:scroll];

    UIImageView* leftdian = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(70)) * 0.25, -Adaptive(7),Adaptive(14), Adaptive(14))];
    [leftdian setImage:[UIImage imageNamed:@"shuju_dian"]];
    [orangeline addSubview:leftdian];

    rightdian = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(70)) * 0.75, -Adaptive(7), Adaptive(14), Adaptive(14))];
    [rightdian setImage:[UIImage imageNamed:@"shuju_dian"]];

    UILabel* photolabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Adaptive(70), 2592 / (1936 / ((viewWidth - Adaptive(70)) / 2)))];
    photolabel.backgroundColor = [UIColor orangeColor];
    photolabel.text = @"照片";
    photolabel.textAlignment = 1;
    photolabel.textColor = [UIColor whiteColor];
    photolabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    [scroll addSubview:photolabel];

    imgscroll = [[UIScrollView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(photolabel.frame), 0, viewWidth - CGRectGetMaxX(photolabel.frame), 2592 / (1936 / ((viewWidth - Adaptive(70)) / 2)))];
    imgscroll.contentSize = CGSizeMake(((viewWidth - Adaptive(70)) / 2) * 2 + 2, 2592 / (1936 / ((viewWidth - Adaptive(70)) / 2)));
    imgscroll.showsHorizontalScrollIndicator = NO;
    imgscroll.pagingEnabled = YES;
    imgscroll.userInteractionEnabled = YES;
    [scroll addSubview:imgscroll];

    for (int a = 0; a < 4; a++) {
        UIImageView* imageview = [[UIImageView alloc] initWithFrame:CGRectMake(a * ((viewWidth - Adaptive(70)) / 2 + 1), 0, ((viewWidth - Adaptive(70)) / 2), 2592 / (1936 / ((viewWidth - Adaptive(70)) / 2)))];
        imageview.tag = 100 + a;

        imageview.userInteractionEnabled = YES;
        [imgscroll addSubview:imageview];
    }
    UILabel* photoline = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(photolabel.frame), viewWidth, 0.5)];
    photoline.backgroundColor = [UIColor whiteColor];
    [scroll addSubview:photoline];

    for (int a = 0; a < 26; a++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(photoline.frame) + a * (Adaptive(40) + 0.5), Adaptive(70), Adaptive(40))];
        label.backgroundColor = [UIColor orangeColor];
        label.text = titleArray[a];
        label.textAlignment = 1;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:FONT size:Adaptive(11)];
        [scroll addSubview:label];

        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(label.frame), viewWidth, 0.5)];
        line.backgroundColor = [UIColor whiteColor];
        line.alpha = .8;

        [scroll addSubview:line];

        UILabel* oldlabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(70), CGRectGetMaxY(photoline.frame) + a * (Adaptive(40) + 0.5), (viewWidth - CGRectGetMaxX(label.frame)) / 2, Adaptive(40))];
        oldlabel.font = [UIFont fontWithName:FONT size:Adaptive(14)];
        oldlabel.textAlignment = 1;
        oldlabel.tag = a + 2;
        oldlabel.textColor = [UIColor lightGrayColor];
        [scroll addSubview:oldlabel];

        UILabel* nowlabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(oldlabel.frame), CGRectGetMaxY(photoline.frame) + a * (Adaptive(40) + 0.5), (viewWidth - CGRectGetMaxX(label.frame)) / 2, Adaptive(40))];
        nowlabel.tag = a + 28;
        nowlabel.textColor = [UIColor whiteColor];
        nowlabel.textAlignment = 1;
        nowlabel.font = [UIFont fontWithName:FONT size:Adaptive(14)];
        [scroll addSubview:nowlabel];
    }
}

- (void)getdata
{
    NSString* url = [NSString stringWithFormat:@"%@api/?method=user.training&id=%@", BASEURL, self.ID];

    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {

        if (ResponseObject_RC == 0) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSDictionary* test = [data objectForKey:@"test"];

            if ([[data allKeys] containsObject:@"last_test"]) {
                [orangeline addSubview:rightdian];
                [self.view addSubview:nowtime];
                orangeline.frame = CGRectMake(CGRectGetMaxX(timelabel.frame), Adaptive(25), (viewWidth - Adaptive(70)) * 0.75, 1);
                imgscroll.contentSize = CGSizeMake(((viewWidth - Adaptive(70)) / 2) * 4 + 4, 2592 / (1936 / ((viewWidth - Adaptive(70)) / 2)));

                NSDictionary* last_test = [data objectForKey:@"last_test"];
                /*********************最新的数据***************************************/
                if (![[last_test allKeys] containsObject:@"before"]) {

                    [(UIImageView*)[self.view viewWithTag:102] setImage:[UIImage imageNamed:@"shuju_placeholder"]];
                }
                else {
                    [(UIImageView*)[self.view viewWithTag:102] setImageWithURL:[NSURL URLWithString:[last_test objectForKey:@"before"]]];
                    //添加点击手势
                    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
                    [(UIImageView*)[self.view viewWithTag:102] addGestureRecognizer:tap];
                }

                if (![[last_test allKeys] containsObject:@"after"]) {
                    [(UIImageView*)[self.view viewWithTag:103] setImage:[UIImage imageNamed:@"shuju_placeholder"]];
                }
                else {
                    [(UIImageView*)[self.view viewWithTag:103] setImageWithURL:[NSURL URLWithString:[last_test objectForKey:@"after"]]];
                    //添加点击手势
                    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
                    [(UIImageView*)[self.view viewWithTag:103] addGestureRecognizer:tap];
                }

                [(UILabel*)[self.view viewWithTag:28] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"height"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"height"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"height"]]];
                [(UILabel*)[self.view viewWithTag:29] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"weight"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"weight"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"weight"]]];
                [(UILabel*)[self.view viewWithTag:30] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"waistline"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"waistline"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"waistline"]]];
                [(UILabel*)[self.view viewWithTag:31] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"hip"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"hip"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"hip"]]];

                [(UILabel*)[self.view viewWithTag:32] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"rham"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"rham"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"rham"]]];
                [(UILabel*)[self.view viewWithTag:33] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"lham"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"lham"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"lham"]]];
                [(UILabel*)[self.view viewWithTag:34] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"rcrus"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"rcrus"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"rcrus"]]];
                [(UILabel*)[self.view viewWithTag:35] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"lcrus"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"lcrus"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"lcrus"]]];
                [(UILabel*)[self.view viewWithTag:36] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"rtar"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"rtar"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"rtar"]]];
                [(UILabel*)[self.view viewWithTag:37] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"rtaqj"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"rtaqj"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"rtaqj"]]];
                [(UILabel*)[self.view viewWithTag:38] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"ltar"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"ltar"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"ltar"]]];
                [(UILabel*)[self.view viewWithTag:39] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"ltaqj"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"ltaqj"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"ltaqj"]]];
                [(UILabel*)[self.view viewWithTag:40] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"bust_relax"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"bust_relax"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"bust_relax"]]];
                [(UILabel*)[self.view viewWithTag:41] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"bust_exp"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"bust_exp"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"bust_exp"]]];
                [(UILabel*)[self.view viewWithTag:42] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"gstj"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"gstj"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"gstj"]]];
                [(UILabel*)[self.view viewWithTag:43] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"kjsy"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"kjsy"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"kjsy"]]];
                [(UILabel*)[self.view viewWithTag:44] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"jjxy"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"jjxy"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"jjxy"]]];
                [(UILabel*)[self.view viewWithTag:45] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"abdomen"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"abdomen"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"abdomen"]]];
                [(UILabel*)[self.view viewWithTag:46] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"fat_ham"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"fat_ham"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"fat_ham"]]];
                [(UILabel*)[self.view viewWithTag:47] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"total"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"total"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"total"]]];
                [(UILabel*)[self.view viewWithTag:48] setText:[NSString stringWithFormat:@"%@", [last_test objectForKey:@"fat"]]];
                [(UILabel*)[self.view viewWithTag:49] setText:[NSString stringWithFormat:@"%@", [last_test objectForKey:@"ytbl"]]];
                [(UILabel*)[self.view viewWithTag:50] setText:[NSString stringWithFormat:@"%@", [last_test objectForKey:@"bmi"]]];
                [(UILabel*)[self.view viewWithTag:51] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"static_heart_rate"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"static_heart_rate"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"static_heart_rate"]]];
                [(UILabel*)[self.view viewWithTag:52] setText:[[NSString stringWithFormat:@"%@", [last_test objectForKey:@"blood_pressure"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [last_test objectForKey:@"blood_pressure"]] : [NSString stringWithFormat:@"%@", [last_test objectForKey:@"blood_pressure"]]];
                [(UILabel*)[self.view viewWithTag:53] setText:[NSString stringWithFormat:@"%@", [last_test objectForKey:@"target_heart_rate"]]];

                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateStyle:NSDateFormatterMediumStyle];
                [formatter setTimeStyle:NSDateFormatterShortStyle];
                [formatter setDateFormat:@"YYYY/MM/dd"];
                NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:[[last_test objectForKey:@"time"] intValue]];

                NSString* confromTimespStr = [formatter stringFromDate:confromTimesp];
                nowtime.text = confromTimespStr;
            }

            /*********************之前的数据***************************************/

            UILabel* label2 = (UILabel*)[self.view viewWithTag:1]; //名字
            UILabel* label27 = (UILabel*)[self.view viewWithTag:2]; //身高
            UILabel* label28 = (UILabel*)[self.view viewWithTag:3]; //体重

            UILabel* label3 = (UILabel*)[self.view viewWithTag:4];
            UILabel* label4 = (UILabel*)[self.view viewWithTag:5];
            UILabel* label5 = (UILabel*)[self.view viewWithTag:6];
            UILabel* label6 = (UILabel*)[self.view viewWithTag:7];
            UILabel* label7 = (UILabel*)[self.view viewWithTag:8];
            UILabel* label8 = (UILabel*)[self.view viewWithTag:9];
            UILabel* label9 = (UILabel*)[self.view viewWithTag:10];
            UILabel* label10 = (UILabel*)[self.view viewWithTag:11];
            UILabel* label11 = (UILabel*)[self.view viewWithTag:12];
            UILabel* label12 = (UILabel*)[self.view viewWithTag:13];
            UILabel* label13 = (UILabel*)[self.view viewWithTag:14];
            UILabel* label14 = (UILabel*)[self.view viewWithTag:15];

            UILabel* label15 = (UILabel*)[self.view viewWithTag:16];
            UILabel* label16 = (UILabel*)[self.view viewWithTag:17];
            UILabel* label17 = (UILabel*)[self.view viewWithTag:18];
            UILabel* label18 = (UILabel*)[self.view viewWithTag:19];
            UILabel* label19 = (UILabel*)[self.view viewWithTag:20];
            UILabel* label20 = (UILabel*)[self.view viewWithTag:21];
            UILabel* label21 = (UILabel*)[self.view viewWithTag:22];
            UILabel* label22 = (UILabel*)[self.view viewWithTag:23];
            UILabel* label23 = (UILabel*)[self.view viewWithTag:24];
            UILabel* label24 = (UILabel*)[self.view viewWithTag:25];
            UILabel* label25 = (UILabel*)[self.view viewWithTag:26];
            UILabel* label26 = (UILabel*)[self.view viewWithTag:27];

            if (![[test allKeys] containsObject:@"before"]) {

                [(UIImageView*)[self.view viewWithTag:100] setImage:[UIImage imageNamed:@"shuju_placeholder"]];
            }
            else {
                [(UIImageView*)[self.view viewWithTag:100] setImageWithURL:[NSURL URLWithString:[test objectForKey:@"before"]]];
                //添加点击手势
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
                [(UIImageView*)[self.view viewWithTag:100] addGestureRecognizer:tap];
            }

            if (![[test allKeys] containsObject:@"after"]) {
                [(UIImageView*)[self.view viewWithTag:101] setImage:[UIImage imageNamed:@"shuju_placeholder"]];
            }
            else {
                [(UIImageView*)[self.view viewWithTag:101] setImageWithURL:[NSURL URLWithString:[test objectForKey:@"after"]]];
                //添加点击手势
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
                [(UIImageView*)[self.view viewWithTag:101] addGestureRecognizer:tap];
            }

            label2.text = [NSString stringWithFormat:@"%@", [test objectForKey:@"coach"]];
            label27.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"height"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"height"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"height"]];
            label28.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"weight"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"weight"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"weight"]];

            label3.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"waistline"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"waistline"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"waistline"]];

            label4.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"hip"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"hip"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"hip"]];

            label5.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"rham"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"rham"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"rham"]];

            label6.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"lham"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"lham"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"lham"]];

            label7.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"rcrus"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"rcrus"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"rcrus"]];

            label8.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"lcrus"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"lcrus"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"lcrus"]];

            label9.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"rtar"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"rtar"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"rtar"]];

            label10.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"rtaqj"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"rtaqj"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"rtaqj"]];

            label11.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"ltar"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"ltar"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"ltar"]];

            label12.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"ltaqj"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"ltaqj"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"ltaqj"]];

            label13.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"bust_relax"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"bust_relax"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"bust_relax"]];

            label14.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"bust_exp"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"bust_exp"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"bust_exp"]];

            label15.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"gstj"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"gstj"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"gstj"]];

            label16.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"kjsy"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"kjsy"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"kjsy"]];

            label17.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"jjxy"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"jjxy"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"jjxy"]];

            label18.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"abdomen"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"abdomen"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"abdomen"]];

            label19.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"fat_ham"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"fat_ham"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"fat_ham"]];

            label20.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"total"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"total"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"total"]];

            label21.text = [NSString stringWithFormat:@"%@", [test objectForKey:@"fat"]];
            label22.text = [NSString stringWithFormat:@"%@", [test objectForKey:@"ytbl"]];
            label23.text = [NSString stringWithFormat:@"%@", [test objectForKey:@"bmi"]];

            label24.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"static_heart_rate"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"static_heart_rate"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"static_heart_rate"]];

            label25.text = [[NSString stringWithFormat:@"%@", [test objectForKey:@"blood_pressure"]] isEqualToString:@""] ? [NSString stringWithFormat:@"%@", [test objectForKey:@"blood_pressure"]] : [NSString stringWithFormat:@"%@", [test objectForKey:@"blood_pressure"]];
            label26.text = [NSString stringWithFormat:@"%@", [test objectForKey:@"target_heart_rate"]];

            NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
            [formatter1 setDateStyle:NSDateFormatterMediumStyle];
            [formatter1 setTimeStyle:NSDateFormatterShortStyle];
            [formatter1 setDateFormat:@"YYYY/MM/dd"];
            NSDate* confromTimesp1 = [NSDate dateWithTimeIntervalSince1970:[[test objectForKey:@"time"] intValue]];

            NSString* confromTimespStr1 = [formatter1 stringFromDate:confromTimesp1];
            oldtime.text = confromTimespStr1;
        }
        else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
        fail:^(NSError* error){
        }];
}
- (void)magnifyImage:(UIGestureRecognizer*)gest
{
    NSLog(@"点击了手势 %ld", (long)gest.view.tag);
    switch (gest.view.tag) {
    case 100:
        [SJAvatarBrowser showImage:(UIImageView*)[imgscroll viewWithTag:100]];
        break;
    case 101:
        [SJAvatarBrowser showImage:(UIImageView*)[imgscroll viewWithTag:101]];
        break;
    case 102:
        [SJAvatarBrowser showImage:(UIImageView*)[imgscroll viewWithTag:102]];
        break;
    case 103:
        [SJAvatarBrowser showImage:(UIImageView*)[imgscroll viewWithTag:103]];
        break;

    default:
        break;
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
