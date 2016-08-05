//
//  AboutViewController.m
//  果动
//
//  Created by mac on 16/5/26.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import <MessageUI/MessageUI.h>
#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"关于果动" viewController:self];
    [self.view addSubview:navigation];
    
    [self createUI];
    
}

- (void)createUI {
    
    UIImageView *logoImageView = [UIImageView new];
    logoImageView.frame        = CGRectMake((viewWidth - Adaptive(70)) / 2,
                                            NavigationBar_Height + Adaptive(80),
                                            Adaptive(70),
                                            Adaptive(70));
    logoImageView.image        = [UIImage imageNamed:@"about_logo"];
    [self.view addSubview:logoImageView];
    
    
    UIImageView *introduceImageView = [UIImageView new];
    introduceImageView.frame        = CGRectMake((viewWidth - Adaptive(130.9)) / 2,
                                                 CGRectGetMaxY(logoImageView.frame) + Adaptive(25),
                                                 Adaptive(130.9),
                                                 Adaptive(17.05));
    introduceImageView.image = [UIImage imageNamed:@"about_introduce"];
    
    [self.view addSubview:introduceImageView];
    
    
    UIImageView *versionImageView = [UIImageView new];
    versionImageView.frame        = CGRectMake((viewWidth - Adaptive(36)) / 2,
                                               CGRectGetMaxY(introduceImageView.frame) + Adaptive(50),
                                               Adaptive(36),
                                               Adaptive(14));
    versionImageView.image        = [UIImage imageNamed:@"about_version"];
    [self.view addSubview:versionImageView];
    
    NSDictionary* infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString* appVersion       = [infoDic objectForKey:@"CFBundleVersion"];
    NSString *appVersionString = [NSString stringWithFormat:@"v%@",appVersion];
    
    CGSize versionSize = [appVersionString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(12)]}];
    
    UILabel *versionLabel = [UILabel new];
    versionLabel.frame    = CGRectMake(Adaptive(2),
                                       0,
                                       versionSize.width,
                                       versionImageView.bounds.size.height);
    versionLabel.font      = [UIFont fontWithName:FONT size:Adaptive(10)];
    versionLabel.textColor = [UIColor grayColor];
    versionLabel.text      = appVersionString;
    versionLabel.textAlignment = 1;
    [versionImageView addSubview:versionLabel];
    
    
    CGRect imageFrame      = versionImageView.frame;
    imageFrame.size.width  = versionSize.width + Adaptive(4);
    versionImageView.frame = imageFrame;
    
    
   
    
    
    NSArray *stringArray = @[@"商业合作",@"媒体合作"];
    for (int a = 0; a < 2; a++) {
        UILabel *label = [UILabel new];
        label.frame    = CGRectMake((viewWidth - Adaptive(100)) / 2,
                                    LastHeight - Adaptive(160) + a*Adaptive(70),
                                    Adaptive(100),
                                    Adaptive(20));
        label.text      = stringArray[a];
        label.textColor = [UIColor whiteColor];
        label.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        label.textAlignment = 1;
        [self.view addSubview:label];
    }
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoButton.frame     = CGRectMake((viewWidth - Adaptive(150)) / 2,
                                       LastHeight - Adaptive((160 - 20)) + Adaptive(5),
                                       Adaptive(150),
                                       Adaptive(20));
    [photoButton setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
    [photoButton setTitle:SHANGYEHEZUO forState:UIControlStateNormal];
    photoButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(14)];
    [photoButton addTarget:self action:@selector(photoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    
    
    UIButton *emailButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    emailButton.frame     = CGRectMake((viewWidth - Adaptive(180)) / 2,
                                       LastHeight - Adaptive((160 - 20 - 70)) + Adaptive(5),
                                       Adaptive(180),
                                       Adaptive(20));
    [emailButton setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
    [emailButton setTitle:MEITIHEZUO forState:UIControlStateNormal];
    emailButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(14)];
    [emailButton addTarget:self action:@selector(emailButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:emailButton];
    
    
    
    UILabel *emailLabel = [UILabel new];
    emailLabel.frame    = CGRectMake((viewWidth - Adaptive(160)) / 2,
                                     CGRectGetMaxY(emailButton.frame) + Adaptive(2),
                                     Adaptive(160),
                                     .5);
    emailLabel.backgroundColor = ORANGECOLOR;
    [self.view addSubview:emailLabel];
    
}

- (void)photoButtonClick:(UIButton *)button {
    NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"tel:%@",SHANGYEHEZUO];
    UIWebView* callWebview = [[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
}

- (void)emailButtonClick:(UIButton *)button {
    
    
    NSMutableString *mailUrl = [[NSMutableString alloc] init];
    NSArray *toRecipients = @[MEITIHEZUO];
    [mailUrl appendFormat:@"mailto:%@", toRecipients[0]];
    
    [mailUrl appendString:@"&subject=my email"];
    
    NSString *emailPath = [mailUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailPath]];
    
}

@end
