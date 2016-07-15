//
//  SetShareViewController.m
//  果动
//
//  Created by mac on 16/7/8.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "UMSocialData.h"
#import "UMSocialSnsService.h"
#import "UMSocialSnsPlatformManager.h"
#import "SetShareViewController.h"

@interface SetShareViewController ()

@end

@implementation SetShareViewController
{
    NSString *shareUrl;
    NSString *contentString;
    UIImage  *shareImage;
    NSString *titleString;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"邀请好友得免费课" viewController:self];
    [self.view addSubview:navigation];
    
    UIImageView *topImageView = [UIImageView new];
    topImageView.frame        = CGRectMake(0, NavigationBar_Height, viewWidth, Adaptive(356));
    topImageView.image        = [UIImage imageNamed:@"share_topImage"];
    [self.view addSubview:topImageView];
    
    
    NSArray *imageArray = @[@"share_weChatFriend",@"share_weChat",@"share_message",@"share_sina",@"share_QQ",@"share_QQZone"];
    NSArray *titleArray = @[@"微信好友",@"朋友圈",@"短信",@"新浪微博",@"QQ好友",@"QQ空间"];
    
    CGFloat OriginX      = (viewWidth  - (Adaptive(50)*3)) / 4;
    CGFloat OriginY      = ((viewHeight - CGRectGetMaxY(topImageView.frame) - NavigationBar_Height) - (Adaptive(50)*2)) / 3;
    
    for (int a = 0; a < 6; a++) {
        UIImageView *imageView = [UIImageView new];
        imageView.frame        = CGRectMake(OriginX + (a%3) * (OriginX + Adaptive(50)),
                                            CGRectGetMaxY(topImageView.frame) + OriginY + (a/3) * (OriginY + Adaptive(50)),
                                            Adaptive(50),
                                            Adaptive(50));
        imageView.image        = [UIImage imageNamed:imageArray[a]];
        [self.view addSubview:imageView];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.frame    = CGRectMake(OriginX + (a%3) * (OriginX + Adaptive(50)),
                                         CGRectGetMaxY(imageView.frame) + Adaptive(5),
                                         Adaptive(50),
                                         Adaptive(15));
        titleLabel.textColor = ORANGECOLOR;
        titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        titleLabel.text      = titleArray[a];
        titleLabel.textAlignment = 1;
        [self.view addSubview:titleLabel];
        
        UIButton  *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shareButton.frame      = CGRectMake(OriginX + (a%3) * (OriginX + Adaptive(50)),
                                           CGRectGetMaxY(topImageView.frame) + OriginY + (a/3) * (OriginY + Adaptive(50)),
                                            Adaptive(50),
                                            Adaptive(70));
        shareButton.tag = a+1;
        [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:shareButton];
     
    }
    
    [self startRequest];
}

- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.share_url",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        shareUrl    = [[responseObject objectForKey:@"data"] objectForKey:@"url"];
        contentString = [[responseObject objectForKey:@"data"] objectForKey:@"info"];
        titleString = [[responseObject objectForKey:@"data"] objectForKey:@"title"];
        shareImage  = [UIImage imageNamed:@"App"];
    }];
}
-(void)didFinishGetUMSocialDataResponse:(UMSocialResponseEntity *)response {
    NSLog(@"代理方法");
}
- (void)shareButtonClick:(UIButton *)button {
    
    /**
     发送微博内容到多个微博平台
     
     @param platformTypes    分享到的平台，数组的元素是`UMSocialSnsPlatformManager.h`定义的平台名的常量字符串，例如`UMShareToSina`，`UMShareToTencent`等。
     @param content          分享的文字内容
     @param image            分享的图片,可以传入UIImage类型或者NSData类型
     @param location         分享的地理位置信息
     @param urlResource      图片、音乐、视频等url资源
     @param completion       发送完成执行的block对象
     @param presentedController 如果发送的平台微博只有一个并且没有授权，传入要授权的viewController，将弹出授权页面，进行授权。可以传nil，将不进行授权。
     
     */
    
    switch (button.tag) {
        case 1:
        {
            
            [UMSocialData defaultData].extConfig.wechatSessionData.title = titleString;
            
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:
                                                shareUrl];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:contentString image:shareImage location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *shareResponse){
                /*
                 UMSResponseCodeSuccess            = 200,        //成功
                 UMSREsponseCodeTokenInvalid       = 400,        //授权用户token错误
                 UMSResponseCodeBaned              = 505,        //用户被封禁
                 UMSResponseCodeFaild              = 510,        //发送失败（由于内容不符合要求或者其他原因）
                 UMSResponseCodeArgumentsError     = 522,        //参数错误,提供的参数不符合要求
                 UMSResponseCodeEmptyContent       = 5007,       //发送内容为空
                 UMSResponseCodeShareRepeated      = 5016,       //分享内容重复
                 UMSResponseCodeGetNoUidFromOauth  = 5020,       //授权之后没有得到用户uid
                 UMSResponseCodeAccessTokenExpired = 5027,       //token过期
                 UMSResponseCodeNetworkError       = 5050,       //网络错误
                 UMSResponseCodeGetProfileFailed   = 5051,       //获取账户失败
                 UMSResponseCodeCancel             = 5052,        //用户取消授权
                 UMSResponseCodeNotLogin           = 5053,       //用户没有登录
                 UMSResponseCodeNoApiAuthority     = 100031      //QQ空间应用没有在QQ互联平台上申请上传图片到相册的权限
                 */
                
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"朋友圈分享成功！%@",shareResponse);
                }
            }];
            
            
        }
            break;
        case 2:
        {
            [UMSocialData defaultData].extConfig.wechatTimelineData.title = titleString;
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:
                                                shareUrl];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:contentString image:shareImage location:nil urlResource:urlResource presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"微信好友分享成功！%@",response);
                }
            }];
        }
            break;
        case 3:
        {
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:[NSString stringWithFormat:@"%@%@",contentString,shareUrl] image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"短信分享成功！%@",response);
                }
                
            }];
        }
            break;
        case 4:
        {
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",contentString,shareUrl] image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"微博分享成功！%@",response);
                }
            }];
            
        }
            break;
        case 5:
        {
            
            [UMSocialData defaultData].extConfig.qqData.url = shareUrl;
            [UMSocialData defaultData].extConfig.qqData.title = titleString;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:contentString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"QQ好友分享成功！%@",response);
                }
            }];
            
        }
            break;
        case 6:
        {
            
            [UMSocialData defaultData].extConfig.qzoneData.url = shareUrl;
             [UMSocialData defaultData].extConfig.qzoneData.title = titleString;
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:contentString image:shareImage location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"QQ空间分享成功！%@",response);
                }
            }];
            
        }
            break;
            
            
        default:
            break;
    }
}

@end
