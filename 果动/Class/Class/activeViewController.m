//
//  activeViewController.m
//  果动
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "YZSDK.h"
#import "activeViewController.h"
@interface activeViewController ()<UIWebViewDelegate>
{
    UIImageView *imageView;
    UIWebView *webview;
}
@end

@implementation activeViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden           = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    UIView *navigationView = [UIView new];
    navigationView.frame   = CGRectMake(0, 0, viewWidth, NavigationBar_Height);
    navigationView.backgroundColor = ORANGECOLOR;
    [self.view addSubview:navigationView];
    
    CGFloat navigationHight = navigationView.frame.size.height - Adaptive(20);
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.frame     = CGRectMake(Adaptive(100),
                                      Adaptive(20)+(navigationHight - Adaptive(20)) / 2,
                                      viewWidth - Adaptive(200),
                                      Adaptive(20));
    titleLabel.textColor = BASECOLOR;
    titleLabel.text      = @"活动";
    titleLabel.textAlignment = 1;
    titleLabel.font      = [UIFont fontWithName:FONT_BOLD size:Adaptive(18)];
    [self.view addSubview:titleLabel];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame     = CGRectMake(Adaptive(13),
                                        Adaptive(20)+(navigationHight - Adaptive(20)) / 2,
                                        Adaptive(40),
                                        Adaptive(20));
    [cancelButton setTitle:@"返回" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTintColor:UIColorFromRGB(0x2b2b2b)];
    cancelButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    
    [navigationView addSubview:cancelButton];

    
    
    if ([_name isEqualToString:@"index2"]) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight - NavigationBar_Height)];
        imageView.image = [UIImage imageNamed:@"active_dk"];
        [self.view addSubview:imageView];
        
        UIImageView *sjImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(83)) / 2,
                                                                                 Adaptive(500) + NavigationBar_Height,
                                                                                 Adaptive(83),
                                                                                 Adaptive(73))];
        sjImageView.image = [UIImage imageNamed:@"active_sj"];
        sjImageView.userInteractionEnabled = YES;
        [self.view addSubview:sjImageView];
        UIImageView *dkImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(23)) / 2, Adaptive(540) + NavigationBar_Height, Adaptive(23), Adaptive(11))];
        dkImageView.image = [UIImage imageNamed:@"active_dkTitle"];
        [self.view addSubview:dkImageView];
        
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame     = CGRectMake(0,
                                      0,
                                      sjImageView.bounds.size.width,
                                      sjImageView.bounds.size.height);
        [button addTarget:self action:@selector(classBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [sjImageView addSubview:button];
    } else {
            webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight - NavigationBar_Height)];
        webview.delegate = self;
            NSString *url = _url;
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
            [self.view addSubview: webview];
            [webview loadRequest:request];
    }
    
   
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [webView stringByEvaluatingJavaScriptFromString:[[YZSDK sharedInstance] jsBridgeWhenWebDidLoad]];
}


- (void)cancelButtonClick:(UIButton *)button {
    if ([webview canGoBack]) {
        [webview goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)classBtnClick {
    NSLog(@"点击订课");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
