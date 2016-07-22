//
//  SetViewController.m
//  果动
//
//  Created by mac on 16/5/24.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "SetViewController.h"
#import "MyInfomationViewController.h"
#import "AboutViewController.h"
#import "LoginViewController.h"

#import "AppDelegate.h"
#import "ShareView.h"

#import "SetShareViewController.h"

@interface SetViewController ()<UIAlertViewDelegate,UMSocialUIDelegate>

@end

@implementation SetViewController
{
    UILabel  *cacheLabel;
    UIButton *loginButton;
    NSArray  * files;
  //  BOOL     isLogin;
    ShareView *share;
    UIView *alphaView;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    // 判断是否登录
//    NSHTTPCookieStorage* sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSArray* cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:BASEURL]];
//    NSEnumerator* enumerator = [cookies objectEnumerator];
//    NSHTTPCookie* cookie;
//    while (cookie = [enumerator nextObject]) {
//        isLogin = YES;
//    }
    if ([HttpTool judgeWhetherUserLogin]) {
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_imageString] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
        loginButton.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
        [loginButton setTitle:@"退出当前账号" forState:UIControlStateNormal];
    } else {
        _headImageView.image = [UIImage imageNamed:@"person_nohead"];
        loginButton.backgroundColor = ORANGECOLOR;
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"设置" viewController:self];
    [self.view addSubview:navigation];
    [self createUI];
}



- (void)createUI {
    
    NSArray *stringArray = @[@"个人资料",@"邀请好友得免费课",@"关于我们",@"清除缓存",@"去App Store评分",[NSString stringWithFormat:@"客服电话: %@",KEFU]];
    
    for (int a = 0; a < 6; a++) {
        UIView *baseView = [UIView new];
        baseView.frame   = CGRectMake(0,
                                     NavigationBar_Height + Adaptive(10) + a*Adaptive(46),
                                      viewWidth,
                                      Adaptive(45));
        
        baseView.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
        [self.view addSubview:baseView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame     = CGRectMake(0,
                                      0,
                                      baseView.bounds.size.width,
                                      baseView.bounds.size.height);
        button.tag       = a + 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:button];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame    = CGRectMake(Adaptive(13),
                                         (Adaptive(45) - Adaptive(20)) / 2,
                                         viewWidth / 2,
                                         Adaptive(20));
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(15)];
        titleLabel.text      = stringArray[a];
        [baseView addSubview:titleLabel];
        
        if (a < 3 || a == 4) {
            UIImageView *imageview = [UIImageView new];
            imageview.frame        = CGRectMake(viewWidth - Adaptive((13 + 9)),
                                                (Adaptive(43) - Adaptive(15.5)) / 2,
                                                Adaptive(9),
                                                Adaptive(15.5));
            imageview.image        = [UIImage imageNamed:@"person_rightArrow"];
            [baseView addSubview:imageview];
        }
        
        // 缓存
        if (a == 3) {
            cacheLabel       = [UILabel new];
            cacheLabel.frame = CGRectMake(viewWidth - Adaptive(150),
                                          (Adaptive(45) - Adaptive(15)) / 2,
                                          Adaptive(137),
                                          Adaptive(15));
            cacheLabel.textColor     = [UIColor whiteColor];
            cacheLabel.textAlignment = 2;
            cacheLabel.font          = [UIFont fontWithName:FONT size:Adaptive(15)];
            [baseView addSubview:cacheLabel];
            //获取缓存大小。。
            NSString* cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            CGFloat fileSize = [self folderSizeAtPath:cachPath];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                cacheLabel.text = [NSString stringWithFormat:@"%.2fMB", fileSize];
                
            });
        }
    }
    
    _headImageView       = [UIImageView new];
    _headImageView.frame = CGRectMake(viewWidth - Adaptive((13 + 9 + 13 + 31)),
                                      Adaptive(17) + NavigationBar_Height,
                                      Adaptive(31),
                                      Adaptive(31));
    _headImageView.layer.cornerRadius  = _headImageView.bounds.size.width / 2;
    _headImageView.layer.masksToBounds = YES;
    
    [self.view addSubview:_headImageView];
    
    
    loginButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake(0,
                                  NavigationBar_Height + Adaptive(20) + 6*46,
                                   viewWidth,
                                   Adaptive(45));
    
    loginButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    [loginButton setTintColor:[UIColor whiteColor]];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:loginButton];
    
    
}

- (void)loginButtonClick:(UIButton *)button {
    
    if ([HttpTool judgeWhetherUserLogin]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"真得要退出么？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        
        [alert show];
    } else {
        // 跳转的时候隐藏tabbar
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        // 跳转之后显示tabbar back回来时tabbar正常显示
        self.hidesBottomBarWhenPushed = NO;
    }
    
}
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        NSURL* url = [NSURL URLWithString:BASEURL];
        if (url) {
            NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:url];
            for (int i = 0; i < [cookies count]; i++) {
                NSHTTPCookie* cookie = (NSHTTPCookie*)[cookies objectAtIndex:i];
                [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
            }
        }
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        // 跳转之后显示tabbar back回来时tabbar正常显示
        self.hidesBottomBarWhenPushed = NO;
    }
}
- (void)buttonClick:(UIButton *)button {
    
    switch (button.tag) {
        case 1:
        {
             self.hidesBottomBarWhenPushed = YES;
            MyInfomationViewController *myInfomation = [MyInfomationViewController new];
            [self.navigationController pushViewController:myInfomation animated:YES];
             self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 2:
        {
            self.hidesBottomBarWhenPushed = YES;
            SetShareViewController *shareView = [SetShareViewController new];
            [self.navigationController pushViewController:shareView animated:YES];
            self.hidesBottomBarWhenPushed = NO;
            
        }
            break;
        case 3:
        {   self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[AboutViewController new] animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        }
            break;
        case 4:
        {
            dispatch_async(
                           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
                               NSString* cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                               files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                               
                               for (NSString* p in files) {
                                   NSError* error;
                                   NSString* path = [cachPath stringByAppendingPathComponent:p];
                                   
                                   if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                                       [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                                   }
                               }
                               [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
                           });
        }
            break;
        case 5:
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:XiaZaiConnent]];
        }
            break;
        case 6:
        {
            NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"tel:%@",KEFU];
            UIWebView* callWebview = [[UIWebView alloc] init];
            
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
            
            [self.view addSubview:callWebview];
        }
            break;
            
        default:
            break;
    }
    
}
//- (void)removeShare {
//    [alphaView removeFromSuperview];
//    
//    [UIView animateWithDuration:.2 animations:^{
//        CGRect Frame   = share.frame;
//        Frame.origin.y = viewHeight;
//        share.frame    = Frame;
//    } completion:^(BOOL finished) {
//        [share removeFromSuperview];
//    }];
//}
//-(void)magnifyImage:(UIGestureRecognizer *)gesture
//{
//    [self removeShare];
//}

#pragma mark - 获取缓存大小
- (CGFloat)folderSizeAtPath:(NSString*)folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator* childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName = nil;
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize / (1024.0 * 1024.0);
}
- (long long)fileSizeAtPath:(NSString*)filePath

{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]) {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (void)clearCacheSuccess

{
    NSString* cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    CGFloat fileSize = [self folderSizeAtPath:cachPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        cacheLabel.text = [NSString stringWithFormat:@"%.2fMB", fileSize];
        
    });
}
@end
