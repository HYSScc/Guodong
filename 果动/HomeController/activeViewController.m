//
//  activeViewController.m
//  果动
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "activeViewController.h"
#import <ShareSDK/ShareSDK.h>
@interface activeViewController ()
{
    UIImageView *imageView;
}
@end

@implementation activeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    NSLog(@"self.number %@",self.number);
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"活动"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"返回" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - NavigationBar_Height)];
    imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"active_%d.jpg",[_number intValue] + 1]];
    [self.view addSubview:imageView];
    
    switch ([_number intValue]) {
        case 1:
        {
            UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            shareButton.frame = CGRectMake(viewWidth / 5, Adaptive(525), viewWidth * .6, Adaptive(30));
            [shareButton addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:shareButton];
        }
            break;
        case 2:
        {
            UIImageView *sjImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(83)) / 2, Adaptive(500), Adaptive(83), Adaptive(73))];
            sjImageView.image = [UIImage imageNamed:@"active_sj"];
            [self.view addSubview:sjImageView];
            
            UIImageView *dkImageView = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(23)) / 2, Adaptive(540), Adaptive(23), Adaptive(11))];
            dkImageView.image = [UIImage imageNamed:@"active_dk"];
            [self.view addSubview:dkImageView];
            
//            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
//            
//            animation.toValue=[NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI , 0, 0, 1)];
//            animation.repeatCount = 2;
//            animation.duration          = 1;
//            animation.removedOnCompletion = NO;
//            animation.fillMode = kCAFillModeForwards;
//            // 添加动画
//            [sjImageView.layer addAnimation:animation forKey:@"move-rotate-layer"];
            
            UIButton *classButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            classButton.frame = CGRectMake(viewWidth / 5, Adaptive(525), viewWidth * .6, Adaptive(30));
            [classButton addTarget:self action:@selector(classBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:classButton];
        }
            break;
            
        default:
            break;
    }
    
    
}

- (void)shareBtnClick {
   
    /*	@param 	content 	分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
     *	@param 	defaultContent 	默认分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
     *	@param 	image 	分享图片（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、facebook、twitter、邮件、打印、微信、QQ、拷贝、短信）
     *	@param 	title 	标题（QQ空间、人人、微信、QQ）
     *	@param 	url 	链接（QQ空间、人人、instapaper、微信、QQ）
     *	@param 	description 	主体内容（人人）
     *	@param 	mediaType 	分享类型（QQ、微信）
     *	@param 	locationCoordinate 	地理位置 (新浪、腾讯、Twitter)
     */
    
    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"http://itunes.apple.com/cn/app/guo-dong/id998425416?l=en&mt=8" //分享内容
                                       defaultContent:nil //默认分享内容
                                                image:[ShareSDK imageWithPath:imagePath] //分享图片
                                                title:@"果动网络" //标题
                                                  url:XiaZaiConnent //链接
                                          description:nil //主体内容
                                            mediaType:SSPublishContentMediaTypeNews]; //分享类型
    
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    /*container 	用于显示分享界面的容器，如果只显示在iPhone客户端可以传入nil。如果需要在iPad上显示需要指定容器。
     *	@param 	shareList 	平台类型列表
     *	@param 	content 	分享内容
     *  @param  statusBarTips   状态栏提示标识：YES：显示； NO：隐藏
     *  @param  authOptions 授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等），默认可传入nil
     *  @param  shareOptions    分享选项，用于定义分享视图部分属性（如：标题、一键分享列表、功能按钮等）,默认可传入nil
     *  @param  targets         自定义标识集合，设置自定义标识可以在管理后台查看相关标识的分享统计数据
     *  @param  result  分享返回事件处理*/
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateBegan) {
                                    
                                    NSString* url = [NSString stringWithFormat:@"%@api/?method=user.share", BASEURL];
                                    NSDate* date = [NSDate date];
                                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                                    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];
                                    
                                    NSString* string = [formatter stringFromDate:date];
                                    NSDate* date1 = [formatter dateFromString:string];
                                    NSString* timeSp = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
                                    
                                    NSDictionary* dict = @{ @"platform" : @"wx",
                                                            @"date" : timeSp };
                                    [HttpTool postWithUrl:url params:dict contentType:CONTENTTYPE success:^(id responseObject) {
                                        if (ResponseObject_RC == 0) {
                                            NSDictionary* data = [responseObject objectForKey:@"data"];
                                            if (data) {
                                                NSString* info = [data objectForKey:@"info"];
                                                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
                                                
                                                [alert show];
                                            }
                                        }
                                        else {
                                            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        }
                                    }
                                                     fail:^(NSError* error){
                                                     }];
                                }
                                else if (state == SSResponseStateFail) {
                                    NSLog(@"发布失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];

}
- (void)classBtnClick {
    NSLog(@"点击订课");
    [self.navigationController popViewControllerAnimated:YES];
}
@end
