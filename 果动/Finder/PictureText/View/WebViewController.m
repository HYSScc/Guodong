//
//  WebViewController.m
//  果动
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController
{
    UIWebView *webView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BASECOLOR;
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"图文详情" viewController:self];
    [self.view addSubview:navigation];
    
    [self createUI];
    
   }

- (void)createUI {
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight - NavigationBar_Height)];
   
    NSString *url = [NSString stringWithFormat:@"%@find/%@",BASEURL,self.content_id];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.view addSubview: webView];
    [webView loadRequest:request];

}
@end
