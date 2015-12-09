//
//  AppraiseViewController.m
//  果动
//
//  Created by mac on 15/2/10.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "AppraiseViewController.h"
//#import "JWStar.h"
#import "Commonality.h"
#import <QuartzCore/QuartzCore.h>
#import "HttpTool.h"
#import "QuestionComment.h"
#import "questionButton.h"
#import <Foundation/NSObject.h>
#import "MainController.h"
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "UIImage+JW.h"
@interface AppraiseViewController ()<UITextViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    UITextView *_textView;
    UIButton *questionButton;
    BOOL isopen6;
    BOOL isopen7;
    BOOL isopen8;
    BOOL isopen9;
    BOOL isopen10;
    BOOL isopen11;
    BOOL isopen12;
    
    int answer1;
    int answer2;
    int answer3;
    int answer4;
    int answer5;
    int answer6;
    int answer7;
    
    UILabel *classNumberLabel;
    NSString *path;
    int starNumber;
    UIImageView *headImageView;
    UILabel *headLabel;
    UILabel *label1;
    UILabel *questionLabel;
    UITextView *amentTextiew;
    UIView *alertView;
    UIImageView *morenView;
    NSData *imageData;
}

@property (nonatomic,retain)NSMutableArray *request;

@property (strong, nonatomic) UIButton *snapButton;
@property (strong, nonatomic) UIButton *switchButton;
@property (strong, nonatomic) UIButton *flashButton;
@end

@implementation AppraiseViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self onCreate];
}
-(void)onCreate
{
    UIImageView *navImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nav"]];
    navImageView.frame = CGRectMake(0, 0, viewWidth, viewHeight/10.106);
    navImageView.userInteractionEnabled = YES;
    [self.view addSubview:navImageView];
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewHeight/51.308, (navImageView.bounds.size.height - 18.5)/2, 10, 18.5)];
    backImage.image = [UIImage imageNamed:@"appraise_back"];
    backImage.userInteractionEnabled = YES;
    [navImageView addSubview:backImage];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    backButton.frame = CGRectMake(CGRectGetMaxX(backImage.bounds) + viewHeight/83.375, (navImageView.bounds.size.height - viewHeight/39.2353)/2, viewHeight/13.34, viewHeight/39.2353);
    [backButton setTintColor:[UIColor whiteColor]];
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [backButton setTitle:@"首页" forState:UIControlStateNormal];
    backButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/39.2353];
    [navImageView addSubview:backButton];
    
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth - viewHeight/8.3375)/2, (navImageView.bounds.size.height - viewHeight/16.675)/2, viewHeight/8.3375, viewHeight/16.675)];
    titleLabel.textColor = [UIColor colorWithRed:255/255.0 green:125/255.0 blue:40/255.0 alpha:1];
    titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/33.35];
    titleLabel.text = @"评价";
    titleLabel.textAlignment = 1;
    [navImageView addSubview:titleLabel];
    
    // 当内容太多 显示不完的时候,用scrollView
    UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewHeight/10.421875, viewWidth, viewHeight)];
    scrollView.delegate = self;//1,设置代理
    // 设置内容大小
  //  scrollView.contentSize = CGSizeMake(viewWidth, viewHeight*1.5);
    // 隐藏滚动条
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    

    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/8.8933)];
    topImageView.backgroundColor = [UIColor colorWithRed:63/255.0 green:63/255.0 blue:63/255.0 alpha:1];
    [scrollView addSubview:topImageView];
    
    headLabel = [[UILabel alloc] initWithFrame:CGRectMake((topImageView.bounds.size.width - viewHeight/6.67)/2,(topImageView.bounds.size.height - viewHeight/22.233)/2.5,viewHeight/6.67,viewHeight/37.056)];
    headLabel.text = @"梁教练";
    headLabel.textAlignment = 1;
    headLabel.textColor = [UIColor whiteColor];
    headLabel.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
    [topImageView addSubview:headLabel];
    
    UIImageView *fiveStarImg = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - viewHeight/9.737)/2, CGRectGetMaxY(headLabel.frame) + viewHeight/95.286, viewHeight/9.737, viewHeight/70.211)];
    fiveStarImg.image = [UIImage imageNamed:@"appraise_fiveStar"];
    [topImageView addSubview:fiveStarImg];
    
    
    headImageView = [[UIImageView alloc] init];
    headImageView.frame = CGRectMake(viewHeight/51.308, CGRectGetMaxY(topImageView.frame) - viewHeight/8.89333/2, viewHeight/8.89333, viewHeight/8.89333);
    headImageView.layer.cornerRadius = headImageView.bounds.size.width/2;
    headImageView.layer.masksToBounds = YES;
    headImageView.backgroundColor = [UIColor grayColor];
    [scrollView addSubview:headImageView];
    
    classNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(headImageView.frame) - viewHeight/26.68, CGRectGetMaxY(topImageView.frame) + viewHeight/29, viewHeight/15.512, viewHeight/44.467)];
    classNumberLabel.layer.cornerRadius = classNumberLabel.bounds.size.width/5.73;
    classNumberLabel.layer.masksToBounds = YES;
    classNumberLabel.text = @"300单";
    classNumberLabel.textColor = [UIColor whiteColor];
    classNumberLabel.textAlignment  = 1;
    classNumberLabel.font = [UIFont fontWithName:FONT size:viewHeight/66.7];
    classNumberLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:125/255.0 blue:40/255.0 alpha:1];
    [scrollView addSubview:classNumberLabel];
    
    
    UIButton *telephone = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    telephone.frame = CGRectMake(viewWidth - viewHeight/13.35 - viewHeight/51.308,CGRectGetMaxY(topImageView.frame) - viewHeight/13.35/2,viewHeight/13.35,viewHeight/13.35);
    [telephone setBackgroundImage:[UIImage imageNamed:@"telephone"] forState:UIControlStateNormal];
    [telephone addTarget:self action:@selector(telephone) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:telephone];
    
    UILabel *talkLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308, CGRectGetMaxY(headImageView.frame) + viewHeight/22.233, viewWidth, viewHeight/39.2353)];
    talkLabel.text = @"请您对此次课程做一个评价:";
    talkLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    talkLabel.font = [UIFont fontWithName:FONT size:viewHeight/39.2353];
    [scrollView addSubview:talkLabel];
    
    for (int a = 0; a < 5; a++) {
        UIButton *starButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        starButton.tag = 1+a;
        starButton.frame = CGRectMake(viewHeight/51.308 + a*viewHeight/16.886, CGRectGetMaxY(talkLabel.frame) + viewHeight/44.467, viewHeight/22.61, viewHeight/23.8214);
        [starButton addTarget:self action:@selector(starButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [starButton setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
        [scrollView addSubview:starButton];
    }
    
    amentTextiew = [[UITextView alloc] initWithFrame:CGRectMake(viewHeight/51.308, CGRectGetMaxY(talkLabel.frame) + viewHeight/11.5, viewWidth - viewHeight/51.308*2, viewHeight/5.558)];
    amentTextiew.delegate = self;
    amentTextiew.layer.cornerRadius = 3;
    amentTextiew.layer.masksToBounds = YES;
    amentTextiew.backgroundColor = [UIColor colorWithRed:213/255.0 green:213/255.0 blue:213/255.0 alpha:.2];
    amentTextiew.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    amentTextiew.font = [UIFont fontWithName:FONT size:15];
    amentTextiew.layer.borderColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1].CGColor;
    amentTextiew.text = @"输入其它建议...(选填)";
    amentTextiew.layer.borderWidth =0.5;
    [scrollView addSubview:amentTextiew];
    
    UILabel *talkquestionLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308, CGRectGetMaxY(amentTextiew.frame) + viewHeight/33.35, viewWidth, viewHeight/39.2353)];
    talkquestionLabel.text = @"请监督教练是否有如下问题:";
    talkquestionLabel.textColor = [UIColor grayColor];
    talkquestionLabel.font = [UIFont fontWithName:FONT size:viewHeight/39.2353];
    [scrollView addSubview:talkquestionLabel];
    
   // self.coach_id = @"10110000008";
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.feedques&coach_id=%@",BASEURL,self.coach_id];
    NSLog(@"url  %@",url);
        [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
            NSLog(@"res  %@",responseObject);
            NSDictionary *data = [responseObject objectForKey:@"data"];
            NSDictionary *coach_info = [data objectForKey:@"coach_info"];
            //名字
            headLabel.text = [coach_info objectForKey:@"username"];
            //头像
            NSString *headimg = [coach_info objectForKey:@"headimg"];
            [headImageView setImageWithURL:[NSURL URLWithString:headimg]];
            
            if ([[coach_info objectForKey:@"class_times"] intValue] == 0) {
                classNumberLabel.text = @"";
            }
            else
            {
                NSLog(@"多少单 %@",[NSString stringWithFormat:@"%@ 单",[coach_info objectForKey:@"class_times"]]);
                classNumberLabel.text = [NSString stringWithFormat:@"%@ 单",[coach_info objectForKey:@"class_times"]];
            }
    
            NSArray *feed_ques = [data objectForKey:@"feed_ques"];
            self.request = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dict in feed_ques) {
                QuestionComment *question = [[QuestionComment alloc] initWithDictionary:dict];
                [self.request addObject:question];
            }
            for (int a = 0; a < 4; a++)
            {
                questionButton *button = [questionButton buttonWithType:UIButtonTypeRoundedRect];
                
                button.frame = CGRectMake(viewHeight/51.308, CGRectGetMaxY(talkquestionLabel.frame)+viewHeight/33.35 + a*viewHeight/16.0723, viewHeight/33.35, viewHeight/33.35);
                [button setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(questionButton:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 6+a;
                [scrollView addSubview:button];
                
                QuestionComment *quest = [self.request objectAtIndex:a];
                button.button_id = quest.ID;
                
                questionLabel = [[UILabel alloc] init];
                questionLabel.frame = CGRectMake(CGRectGetMaxX(button.frame)+viewHeight/133.4, CGRectGetMaxY(talkquestionLabel.frame) + viewHeight/30.3182 + a*viewHeight/16.0723, viewHeight/4.764, viewHeight/44.467);
                questionLabel.text = quest.question;
                questionLabel.textAlignment = 0;
                questionLabel.textColor = [UIColor grayColor];
                questionLabel.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
                [scrollView addSubview:questionLabel];
                //
                
            }
            for (int a = 0; a < 3; a++)
            {
                questionButton*button = [questionButton buttonWithType:UIButtonTypeRoundedRect];
                button.frame = CGRectMake(viewWidth - viewHeight/51.308 - viewHeight/4.764 - viewHeight/133.4 - viewHeight/33.35, CGRectGetMaxY(talkquestionLabel.frame)+viewHeight/33.35 + a*viewHeight/16.0723, viewHeight/33.35, viewHeight/33.35);
                [button setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
                [button addTarget:self action:@selector(questionButton:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 10+a;
                [scrollView addSubview:button];
                
                QuestionComment *quest = [self.request objectAtIndex:a+4];
                button.button_id = quest.ID;
                NSLog(@"button_id  %@",button.button_id);
                
                
                questionLabel = [[UILabel alloc] init];
                questionLabel.frame = CGRectMake(viewWidth - viewHeight/51.308 - viewHeight/4.764, CGRectGetMaxY(talkquestionLabel.frame) + viewHeight/30.3182 + a*viewHeight/16.0723, viewHeight/4.764, viewHeight/44.467);
                questionLabel.text = quest.question;
                questionLabel.textAlignment = 0;
                questionLabel.textColor = [UIColor grayColor];
                questionLabel.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
                [scrollView addSubview:questionLabel];
                
            }

    
    
        } fail:^(NSError *error) {
            NSLog(@"error  %@",error);
        }];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake(0, viewHeight - viewHeight/11.702, viewWidth, viewHeight/11.702);
    sureButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:125/255.0 blue:40/255.0 alpha:1];
    [sureButton setTintColor:[UIColor whiteColor]];
    [sureButton setTitle:@"提交评价" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/41.6875];
    sureButton.titleLabel.textAlignment = 1;
    [sureButton addTarget:self action:@selector(sureButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    //
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [scrollView addGestureRecognizer:swipeGesture];
    
}

-(void)starButtonClick:(UIButton *)button
{
    
    starNumber = (int)button.tag;
    NSLog(@"starNumber  %d",starNumber);
    UIButton *button1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *button3 = (UIButton *)[self.view viewWithTag:3];
    UIButton *button4 = (UIButton *)[self.view viewWithTag:4];
    UIButton *button5 = (UIButton *)[self.view viewWithTag:5];
    UIButton *button6 = (UIButton *)[self.view viewWithTag:6];
    UIButton *button7 = (UIButton *)[self.view viewWithTag:7];
    UIButton *button8 = (UIButton *)[self.view viewWithTag:8];
    UIButton *button9 = (UIButton *)[self.view viewWithTag:9];
    UIButton *button10 = (UIButton *)[self.view viewWithTag:10];
    UIButton *button11 = (UIButton *)[self.view viewWithTag:11];
    UIButton *button12 = (UIButton *)[self.view viewWithTag:12];
    [button6 setEnabled:YES];
    [button7 setEnabled:YES];
    [button8 setEnabled:YES];
    [button9 setEnabled:YES];
    [button10 setEnabled:YES];
    [button11 setEnabled:YES];
    [button12 setEnabled:YES];
    switch (button.tag) {
        case 1:
        {
            [button1 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button2 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
            [button3 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
            [button4 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
            [button5 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
        }
            break;
        case 2:
        {
            
            [button1 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button2 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button3 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
            [button4 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
            [button5 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
        }
            break;
        case 3:
        {
            [button1 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button2 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button3 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button4 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
            [button5 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
            
        }
            break;
        case 4:
        {
            [button1 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button2 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button3 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button4 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button5 setBackgroundImage:[UIImage imageNamed:@"star_gry"] forState:UIControlStateNormal];
        }
            break;
        case 5:
        {
            [button1 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button2 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button3 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button4 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button5 setBackgroundImage:[UIImage imageNamed:@"star_orange"] forState:UIControlStateNormal];
            [button6 setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
            [button7 setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
            [button8 setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
            [button9 setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
            [button10 setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
            [button11 setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
            [button12 setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
            [button6 setEnabled:NO];
            [button7 setEnabled:NO];
            [button8 setEnabled:NO];
            [button9 setEnabled:NO];
            [button10 setEnabled:NO];
            [button11 setEnabled:NO];
            [button12 setEnabled:NO];
            isopen6 = NO;
            isopen7 = NO;
            isopen8 = NO;
            isopen9 = NO;
            isopen10 = NO;
            isopen11 = NO;
            isopen12 = NO;
            answer1 = 0;
            answer2 = 0;
            answer3 = 0;
            answer4 = 0;
            answer5 = 0;
            answer6 = 0;
            answer7 = 0;
            
        }
            break;
            
        default:
            break;
    }
    
}
-(void)questionButton:(questionButton *)button
{
    NSLog(@"对号  %ld",(long)button.tag);
    
   // NSLog(@"button_id  %@",button.button_id);
    
    switch (button.tag) {
        case 6:
        {
            if (isopen6 == NO) {
                [button setBackgroundImage:[UIImage imageNamed:@"对号红"] forState:UIControlStateNormal];
                answer1 = 1;
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
                answer1 = 0;
            }
            isopen6 =!isopen6;
        }
            break;
        case 7:
        {
            if (isopen7 == NO) {
                [button setBackgroundImage:[UIImage imageNamed:@"对号红"] forState:UIControlStateNormal];
                answer2 = 1;
                
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
                answer2 = 0;
            }
            isopen7 =!isopen7;
        }
            break;
        case 8:
        {
            if (isopen8 == NO) {
                [button setBackgroundImage:[UIImage imageNamed:@"对号红"] forState:UIControlStateNormal];
                answer3 = 1;
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
                answer3 = 0;
            }
            isopen8 =!isopen8;
        }
            break;
        case 9:
        {
            if (isopen9 == NO) {
                [button setBackgroundImage:[UIImage imageNamed:@"对号红"] forState:UIControlStateNormal];
                answer4 = 1;
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
                answer4 = 0;
            }
            isopen9 =!isopen9;
        }
            break;
        case 10:
        {
            if (isopen10 == NO) {
                [button setBackgroundImage:[UIImage imageNamed:@"对号红"] forState:UIControlStateNormal];
                answer5 = 1;
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
                answer5 = 0;
            }
            isopen10 =!isopen10;
        }
            break;
        case 11:
        {
            if (isopen11 == NO) {
                [button setBackgroundImage:[UIImage imageNamed:@"对号红"] forState:UIControlStateNormal];
                answer6 = 1;
                
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
                answer6 = 0;
            }
            isopen11 =!isopen11;
        }
            break;
        case 12:
        {
            if (isopen12 == NO) {
                [button setBackgroundImage:[UIImage imageNamed:@"对号红"] forState:UIControlStateNormal];
                answer7 = 1;
                
            }
            else
            {
                [button setBackgroundImage:[UIImage imageNamed:@"对号"] forState:UIControlStateNormal];
                answer7 = 0;
            }
            isopen12 =!isopen12;
        }
            break;
            
        default:
            break;
    }
}
-(void)telephone
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:010-65460058"];
    
    UIWebView * callWebview = [[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)sureButton:(UIButton *)button
{
    
    NSMutableArray *ques_array = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableDictionary *ques_dict1 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [ques_dict1 setObject:@"1" forKey:@"ques_id"];
    [ques_dict1 setObject:[NSString stringWithFormat:@"%d",answer1] forKey:@"answer"];
    
    NSMutableDictionary *ques_dict2 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [ques_dict2 setObject:@"2" forKey:@"ques_id"];
    [ques_dict2 setObject:[NSString stringWithFormat:@"%d",answer2] forKey:@"answer"];
    
    NSMutableDictionary *ques_dict3 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [ques_dict3 setObject:@"3" forKey:@"ques_id"];
    [ques_dict3 setObject:[NSString stringWithFormat:@"%d",answer3] forKey:@"answer"];
    
    NSMutableDictionary *ques_dict4 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [ques_dict4 setObject:@"4" forKey:@"ques_id"];
    [ques_dict4 setObject:[NSString stringWithFormat:@"%d",answer4] forKey:@"answer"];
    
    NSMutableDictionary *ques_dict5 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [ques_dict5 setObject:@"5" forKey:@"ques_id"];
    [ques_dict5 setObject:[NSString stringWithFormat:@"%d",answer5] forKey:@"answer"];
    
    NSMutableDictionary *ques_dict6 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [ques_dict6 setObject:@"6" forKey:@"ques_id"];
    [ques_dict6 setObject:[NSString stringWithFormat:@"%d",answer6] forKey:@"answer"];
    
    NSMutableDictionary *ques_dict7 = [[NSMutableDictionary alloc] initWithCapacity:0];
    [ques_dict7 setObject:@"7" forKey:@"ques_id"];
    [ques_dict7 setObject:[NSString stringWithFormat:@"%d",answer7] forKey:@"answer"];
    
    [ques_array addObject:ques_dict1];
    [ques_array addObject:ques_dict2];
    [ques_array addObject:ques_dict3];
    [ques_array addObject:ques_dict4];
    [ques_array addObject:ques_dict5];
    [ques_array addObject:ques_dict6];
    [ques_array addObject:ques_dict7];
    
    NSLog(@"ques_arrAY  %@",ques_array);
    NSLog(@"starNumber %d",starNumber);
    NSLog(@"amentTextView %@",amentTextiew.text);
    //    //你的接口地址
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.feedback",BASEURL];
    //传入的参数
    NSDictionary *dict = @{@"order_id":self.order_id,@"ques_info":ques_array,@"star":[NSString stringWithFormat:@"%d",starNumber],@"feed":amentTextiew.text};
    
    NSLog(@"dict   %@",dict);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:CONTENTTYPE];
    //发送请求
    [manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        if ([[responseObject objectForKey:@"rc"] intValue] == 0) {
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[[responseObject objectForKey:@"data"] objectForKey:@"info"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alert show];
            
                   }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
}
-(void)backButton
{
    MainController *home = [MainController new];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = home;
}
-(void)swipeGesture
{
    [amentTextiew resignFirstResponder];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    //  CGRect frame = textView.frame;
    textView.text = @"";
    int offset = 352-textView.frame.origin.y-textView.frame.size.height;//键盘高度216
    NSLog(@"self.view.height  %f",self.view.frame.size.height);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    //100, 500, 820,150
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset < 0)
        self.view.frame = CGRectMake(0.0f, offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
    path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/d.plist"];
    // 写到文件中的是什么格式  读出来也要是什么格式
    //    NSArray *array = [[NSArray alloc] initWithContentsOfFile:path];
    //   根据文件的内容来初始话字典
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    textView.text = [dict objectForKey:@"content"];
    NSLog(@"path   %@",path);
    
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    self.view.frame =CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [dict setObject:textView.text forKey:@"content"];
    // [dict setObject:@"170" forKey:@"height"];
    // NSHomeDirectory() 沙盒根目录的路径
    path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/d.plist"];
    [dict writeToFile:path atomically:YES];
    
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:path error:NULL];
        
        MainController *home = [MainController new];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        app.window.rootViewController = home;

}


@end
