//
//  WebViewController.m
//  果动
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "AppDelegate.h"
#import "ShareView.h"
#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController
{
    UIWebView *webView;
    ShareView *share;
    UIView *alphaView;
}
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
       
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"图文详情" viewController:self];
    [self.view addSubview:navigation];
    
    
    UIButton  *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame        = CGRectMake(viewWidth - Adaptive((13 + 17.5)),
                                         Adaptive(20) + Adaptive((44 - 19)) / 2,
                                         Adaptive(17.5),
                                         Adaptive(19));
    [shareButton setBackgroundImage:[UIImage imageNamed:@"find_questionShare"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigation addSubview:shareButton];
    
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShare) name:@"removeShare" object:nil];
    
    [self createUI];
    
}

- (void)shareButtonClick:(UIButton *)button {
    
   NSString *url = [NSString stringWithFormat:@"%@find/%@",BASEURL,self.content_id];
    NSLog(@"url %@",url);
    share = [[ShareView alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, Adaptive(256)) title:_sharetitle imageName:[UIImage new] url:url id:_content_id shareType:@"find" viewController:nil];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    alphaView = [UIView new];
    alphaView.frame           = CGRectMake(0, 0, viewWidth, viewHeight);
    alphaView.backgroundColor = BASECOLOR;
    alphaView.alpha           = .3;
    
    UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    [alphaView addGestureRecognizer:tapLeftDouble];
    
    [UIView animateWithDuration:.2 animations:^{
        [app.window addSubview:alphaView];
        CGRect Frame   = share.frame;
        Frame.origin.y = viewHeight - Adaptive(256);
        share.frame    = Frame;
        [app.window addSubview:share];
        
    }];

}
- (void)removeShare {
    [alphaView removeFromSuperview];
    
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect Frame   = share.frame;
        Frame.origin.y = viewHeight;
        share.frame    = Frame;
    } completion:^(BOOL finished) {
        [share removeFromSuperview];
    }];
}

-(void)magnifyImage:(UIGestureRecognizer *)gesture
{
    [self removeShare];
}

- (void)createUI {
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight - NavigationBar_Height)];
    
    NSString *url = [NSString stringWithFormat:@"%@find/%@",BASEURL,self.content_id];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview: webView];
    [webView loadRequest:request];
    
}
@end
