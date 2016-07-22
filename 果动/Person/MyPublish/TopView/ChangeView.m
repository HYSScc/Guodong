//
//  ChangeView.m
//  果动
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ChangeView.h"
#import "My_NewsView.h"
#import "My_PhotoView.h"


#import "QuestionViewController.h"
@implementation ChangeView
{
    UIImageView    *triangleImageView;
    NSMutableArray *viewArray;
    NSString       *user_id;
    UIImageView    *headImageView;
    UIImageView    *sexImageView;
    UILabel        *nameLabel;
    UILabel        *newsNumberLabel;
    UILabel        *photoNumberLabel;
    UILabel        *questionNumberLabel;
    UIViewController *viewController;
}
- (instancetype)initWithFrame:(CGRect)frame user_id:(NSString *)user viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        user_id = user;
        viewController = controller;
        [self createUI];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refushAllUI) name:@"refushAllUI" object:nil];
        
        if ([HttpTool judgeWhetherUserLogin]) {
            [self startRequest];
        }
    }
    return self;
}

- (void)refushAllUI {
    [self startRequest];
}

- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.personal_center&user_id=%@",BASEURL,user_id];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
      
            NSDictionary *dataDict = [responseObject objectForKey:@"data"];
            NSDictionary *userinfo = [dataDict objectForKey:@"userinfo"];
            [headImageView sd_setImageWithURL:[NSURL URLWithString:[userinfo objectForKey:@"headimg"]] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
            if ([[userinfo objectForKey:@"gender"] intValue] == 2) {
                sexImageView.image = [UIImage imageNamed:@"publish_women"];
            } else {
                sexImageView.image  = [UIImage imageNamed:@"publish_man"];
            }
            
            nameLabel.text           = [userinfo objectForKey:@"nickname"];
            newsNumberLabel.text     = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"talk_length"]];
            photoNumberLabel.text    = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"photo_length"]];
            questionNumberLabel.text = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"que_length"]];
        
        
       
    }];
}

- (void)createUI {
    
    headImageView       = [UIImageView new];
    headImageView.frame = CGRectMake((viewWidth - Adaptive(68)) / 2,
                                     Adaptive(10),
                                     Adaptive(68),
                                     Adaptive(68));
    headImageView.layer.cornerRadius = headImageView.bounds.size.width / 2;
    headImageView.layer.masksToBounds= YES;
    headImageView.image = [UIImage imageNamed:@"person_nohead"];
    [self addSubview:headImageView];
    
    sexImageView = [UIImageView new];
    sexImageView.frame        = CGRectMake(CGRectGetMaxX(headImageView.frame) - Adaptive(18),
                                           CGRectGetMaxY(headImageView.frame) - Adaptive(18),
                                           Adaptive(18),
                                           Adaptive(18));
    sexImageView.image  = [UIImage imageNamed:@"publish_man"];
    [self addSubview:sexImageView];
    
    
    nameLabel = [UILabel new];
    nameLabel.frame    = CGRectMake(0,
                                    CGRectGetMaxY(headImageView.frame) + Adaptive(5),
                                    viewWidth,
                                    Adaptive(20));
    nameLabel.textColor     = [UIColor whiteColor];
    nameLabel.textAlignment = 1;
    nameLabel.text          = @"果动";
    nameLabel.font          = [UIFont fontWithName:FONT size:Adaptive(15)];
    
    [self addSubview:nameLabel];
    
    
    UILabel *horizontalLine = [UILabel new];
    horizontalLine.frame    = CGRectMake(0, Adaptive(105), viewWidth, .5);
    horizontalLine.backgroundColor = BASECOLOR;
    [self addSubview:horizontalLine];
    
    for (int a = 0; a < 2; a++) {
        UILabel *label = [UILabel new];
        label.frame    = CGRectMake((viewWidth / 3) * (a + 1),
                                    CGRectGetMaxY(horizontalLine.frame) + Adaptive(5),
                                    .5,
                                    Adaptive(35));
        label.backgroundColor = BASECOLOR;
        [self addSubview:label];
    }
    
    NSArray *stringArray = @[@"动态",@"照片",@"答疑"];
    
    for (int a = 0; a < 3; a++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame     = CGRectMake((viewWidth / 3)*a,
                                      CGRectGetMaxY(horizontalLine.frame),
                                      viewWidth / 3,
                                      Adaptive(45));
        button.tag       = a + 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame    = CGRectMake((viewWidth / 3)*a,
                                         CGRectGetMaxY(horizontalLine.frame) + Adaptive(3),
                                         viewWidth / 3,
                                         Adaptive(15));
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        titleLabel.text      = stringArray[a];
        titleLabel.textAlignment = 1;
        [self addSubview:titleLabel];
        
    }
    
    newsNumberLabel = [UILabel new];
    newsNumberLabel.frame    = CGRectMake(0,
                                          CGRectGetMaxY(horizontalLine.frame) + Adaptive(20),
                                          viewWidth / 3,
                                          Adaptive(15));
    newsNumberLabel.textColor = [UIColor whiteColor];
    newsNumberLabel.font      = [UIFont fontWithName:FONT size:Adaptive(15)];
    newsNumberLabel.text      = @"0";
    newsNumberLabel.textAlignment = 1;
    [self addSubview:newsNumberLabel];
    
    photoNumberLabel = [UILabel new];
    photoNumberLabel.frame    = CGRectMake(viewWidth / 3,
                                           CGRectGetMaxY(horizontalLine.frame) + Adaptive(20),
                                           viewWidth / 3,
                                           Adaptive(20));
    photoNumberLabel.textColor = [UIColor whiteColor];
    photoNumberLabel.font      = [UIFont fontWithName:FONT size:Adaptive(15)];
    photoNumberLabel.text      = @"0";
    photoNumberLabel.textAlignment = 1;
    [self addSubview:photoNumberLabel];
    
    
    questionNumberLabel = [UILabel new];
    questionNumberLabel.frame    = CGRectMake((viewWidth / 3) * 2,
                                              CGRectGetMaxY(horizontalLine.frame) + Adaptive(20),
                                              viewWidth / 3,
                                              Adaptive(20));
    questionNumberLabel.textColor = [UIColor whiteColor];
    questionNumberLabel.font      = [UIFont fontWithName:FONT size:Adaptive(15)];
    questionNumberLabel.text      = @"0";
    questionNumberLabel.textAlignment = 1;
    [self addSubview:questionNumberLabel];
    
    
    triangleImageView       = [UIImageView new];
    triangleImageView.image = [UIImage imageNamed:@"find_movetrain"];
    triangleImageView.frame = CGRectMake(((viewWidth / 3) - Adaptive(20)) / 2,
                                         CGRectGetMaxY(newsNumberLabel.frame) + Adaptive(3),
                                         Adaptive(20),
                                         Adaptive(13));
    [self addSubview:triangleImageView];
    
}

- (void)buttonClick:(UIButton *)button {
   
    CGRect traingleFrame    = triangleImageView.frame;
    traingleFrame.origin.x  = (button.bounds.size.width - Adaptive(20)) / 2 + CGRectGetMinX(button.frame);
    triangleImageView.frame = traingleFrame;

    
    if ([HttpTool judgeWhetherUserLogin]) {
        
        /**
         *  根据button.tag值添加不同的视图
         */
        switch (button.tag) {
            case 1:
            {
                My_NewsView *news = [[My_NewsView alloc] initWithFrame:CGRectMake(0,
                                                                                  CGRectGetMaxY(self.frame),
                                                                                  viewWidth,
                                                                                  viewHeight - NavigationBar_Height - Adaptive(150)) user_id:user_id viewController:viewController];
                [self.superview addSubview:news];
            }
                break;
            case 2:
            {
                My_PhotoView *photo = [[My_PhotoView alloc] initWithFrame:CGRectMake(0,
                                                                                     CGRectGetMaxY(self.frame) ,
                                                                                     viewWidth,
                                                                                     viewHeight - NavigationBar_Height - Adaptive(150)) user_id:user_id];
                [self.superview addSubview:photo];
            }
                break;
            case 3:
            {
                QuestionViewController *question = [QuestionViewController new];
                
                question.view.frame = CGRectMake(0,
                                                 CGRectGetMaxY(self.frame) ,
                                                 viewWidth,
                                                 viewHeight - CGRectGetMaxY(self.frame));
                question.type    = @"myQuestion";
                question.user_id = user_id;
                [self.superview addSubview:question.view];
                [viewController addChildViewController:question];
                
            }
                break;
                
            default:
                break;
        }

    }
}
@end
