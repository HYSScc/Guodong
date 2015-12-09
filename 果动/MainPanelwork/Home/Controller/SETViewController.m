//
//  SETViewController.m
//  果动
//
//  Created by mac on 15/4/9.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "SETViewController.h"
#import "Commonality.h"
#import "UserFeedbackController.h"
#import "AboutViewController.h"

#import "LoginViewController.h"
@interface SETViewController ()<UIAlertViewDelegate>
{
    UILabel *number;
    NSArray *files;
    UILabel *kbLabel;
    UIImageView *imageView;
    UILabel *about;
    BOOL islogin;
    UIButton *loginbutton;
    UILabel *cleanLabel;
}
@end

@implementation SETViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    NSHTTPCookieStorage *sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:BASEURL]];
    NSEnumerator *enumerator = [cookies objectEnumerator];
    NSHTTPCookie *cookie;
    while (cookie = [enumerator nextObject]) {
        NSLog(@"COOKIE{name: %@, value: %@}", [cookie name], [cookie value]);
        islogin = YES;
    }
    if (islogin) {
        [loginbutton setBackgroundImage:[UIImage imageNamed:@"set_TClogin"] forState:UIControlStateNormal];
    }
    else
    {
       [loginbutton setBackgroundImage:[UIImage imageNamed:@"set_login"] forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
     self.navigationItem.titleView = [HeadComment titleLabeltext:@"设置"];
    BackView *backView = [[BackView alloc] initWithbacktitle:@"个人" viewController:self];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
   self.title = @"设置";
      
    //上面的线
    UIImageView * lineImage1=[UIImageView new];
    lineImage1.image=[UIImage imageNamed:@"home__line1"];
    lineImage1.frame=CGRectMake(0, 0, viewWidth, 0.5);
    [self.view addSubview:lineImage1];
       
    
   
    
    [self create];
}

-(void)create
{
    for (int a = 0; a < 4; a++) {
       imageView = [UIImageView new];
     //   imageView.backgroundColor = [UIColor redColor];
        imageView.userInteractionEnabled = YES;
        
        imageView.frame = CGRectMake(0,a*(viewHeight/11.1167),viewWidth,viewHeight/11.1167);
        
    
        switch (a) {
            case 0:
            {
                
                imageView.image = [UIImage imageNamed:@"person_tiao"];
                UILabel *kefu = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308, viewHeight/66.7, viewHeight/6.67, imageView.frame.size.height-(viewHeight/33.35))];
                kefu.text = @"反馈";
                kefu.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
                kefu.textColor = [UIColor whiteColor];
                [imageView addSubview:kefu];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                //    button.backgroundColor = [UIColor redColor];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 3;
                button.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
                [imageView addSubview:button];
                
            }
                break;
            
            case 1:
            {
                imageView.image = [UIImage imageNamed:@"person_notiao"];
                UILabel *kefu = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308, viewHeight/66.7, viewHeight/6.67, imageView.frame.size.height-(viewHeight/33.35))];
                kefu.text = @"客服";
                kefu.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
                kefu.textColor = [UIColor whiteColor];
                [imageView addSubview:kefu];
                
                number = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width-viewHeight/5.955 - viewHeight/51.308,viewHeight/66.7 , viewHeight/5.559, imageView.frame.size.height - viewHeight/33.35)];
                number.text = KEFU;
                number.textColor = [UIColor whiteColor];
                number.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
                [imageView addSubview:number];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                //   button.backgroundColor = [UIColor redColor];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 1;
                button.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
                [imageView addSubview:button];

            }
                break;
            case 2:
            {
                 imageView.image = [UIImage imageNamed:@"person_notiao"];
                UILabel *kefu = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308, viewHeight/66.7, viewHeight/6.67, imageView.frame.size.height-(viewHeight/33.35))];
                kefu.text = @"清除缓存";
                kefu.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
                kefu.textColor = [UIColor whiteColor];
                [imageView addSubview:kefu];
            
               
                //获取缓存大小。。
                NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                
                CGFloat fileSize = [self folderSizeAtPath:cachPath];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    kbLabel.text = [NSString stringWithFormat:@"%.2fMB",fileSize];
                    
                });
                
                kbLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width-viewHeight/5.131 - viewHeight/51.308,viewHeight/66.7 , viewHeight/5.558, imageView.frame.size.height-(viewHeight/33.35))];
               
                kbLabel.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
                kbLabel.textAlignment = 2;
                kbLabel.textColor = [UIColor whiteColor];
                [imageView addSubview:kbLabel];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 4;
                button.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
                [imageView addSubview:button];
            }
                break;
            
            case 3:
            {
                imageView.image = [UIImage imageNamed:@"person_tiao"];
                about = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/51.308, viewHeight/66.7, viewHeight/6.67, imageView.frame.size.height-(viewHeight/33.35))];
                about.text = @"关于我们";
                about.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
                about.textColor = [UIColor whiteColor];
                [imageView addSubview:about];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 6;
                button.frame = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);
                [imageView addSubview:button];
                
            }
                break;

                
            default:
                break;
        }
        
        [self.view addSubview:imageView];
    }
    
    loginbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [loginbutton addTarget:self action:@selector(loginAndRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    
    
    loginbutton.frame = CGRectMake(0, CGRectGetMaxY(imageView.frame) + (viewHeight/44.467), viewWidth,viewHeight/11.117);
    
   
    [self.view addSubview:loginbutton];
    
     cleanLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/3, CGRectGetMaxY(loginbutton.frame) + viewHeight/6.67, viewWidth/3, viewHeight/16.675)];
    cleanLabel.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
    cleanLabel.text = @"清理成功";
    cleanLabel.textAlignment = 1;
    cleanLabel.textColor = [UIColor lightGrayColor];
    cleanLabel.font = [UIFont fontWithName:FONT size:viewHeight/47.6429];
    

}
#pragma mark 登陆注册按钮
-(void)loginAndRegisterVC
{
    NSLog(@"登陆/注册");
   
    if (islogin == YES) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"真得要退出吗?" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"再想想", nil];
        
        [alert show];

        
        
    }
    else
    {
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }


}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    NSLog(@"buttonIndex  %ld",(long)buttonIndex);
    if (buttonIndex == 0) {
        NSURL *url = [NSURL URLWithString:BASEURL];
        if (url) {
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
            for (int i = 0; i < [cookies count]; i++) {
                NSHTTPCookie *cookie = (NSHTTPCookie *)[cookies objectAtIndex:i];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
                
            }
        }
        islogin = NO;
        LoginViewController *login = [LoginViewController new];
        [self.navigationController pushViewController:login animated:YES];
    }
   
}

-(void)buttonClick:(UIButton *)button
{
    
    switch (button.tag) {
        case 1:
        {
            NSLog(@"111");
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",number.text];
            
            UIWebView * callWebview = [[UIWebView alloc] init];
            
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            
            [self.view addSubview:callWebview];
        }
            break;
       
        case 3:
        {
            NSLog(@"333");
            [self.navigationController pushViewController:[UserFeedbackController new] animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"444");
            dispatch_async(
                           
                           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                           
                           , ^{
                               
                               NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                               files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                               NSLog(@"files :%lu",(unsigned long)[files count]);
                               
                               for (NSString *p in files)
                               {
                                   NSError *error;
                                   NSString *path = [cachPath stringByAppendingPathComponent:p];
                                   
                                   if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                                {
                                       [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                                   }
                               }
                               
                               [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
        }
            break;
        case 6:
        {
            
            [self.navigationController pushViewController:[AboutViewController new] animated:YES];
        }
            break;
            
        default:
            break;
    }
}
-(void)clearCacheSuccess

{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    CGFloat fileSize = [self folderSizeAtPath:cachPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        kbLabel.text = [NSString stringWithFormat:@"%.2fMB",fileSize];
        
    });
   
    [self.view addSubview:cleanLabel];
    [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.5];
}
-(void)delayMethod
{
    [cleanLabel removeFromSuperview];
}
- (CGFloat)folderSizeAtPath:(NSString *)folderPath

{
       NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    {
        return 0;
    }

    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName = nil;
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
- (long long)fileSizeAtPath:(NSString *)filePath

{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
@end
