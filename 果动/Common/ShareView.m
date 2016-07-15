//
//  ShareView.m
//  果动
//
//  Created by mac on 16/6/27.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "ShareView.h"

@interface ShareView ()

@end

@implementation ShareView
{
    NSString *titleString;
    UIImage  *shareImage;
    NSString *urlString;
    UIViewController *viewController;
}
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageName:(UIImage *)image url:(NSString *)url viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.frame           = frame;
        titleString          = title;
        shareImage           = image;
        urlString            = url;
        viewController       = controller;
        self.backgroundColor = BASECOLOR;
        
        
        UIView *buttonView   = [UIView new];
        buttonView.backgroundColor = [UIColor colorWithRed:229/255.0 green:228/255.0 blue:227/255.0 alpha:1];
        buttonView.frame     = CGRectMake(Adaptive(10), 0, self.bounds.size.width - Adaptive(20), Adaptive(256) - Adaptive(55));
        buttonView.layer.cornerRadius = 5;
        buttonView.layer.masksToBounds = YES;
        [self addSubview:buttonView];
        
        NSArray *imageArray = @[@"share_weChatFriend",@"share_weChat",@"share_message",@"share_sina",@"share_QQ",@"share_QQZone"];
        NSArray *titleArray = @[@"微信好友",@"朋友圈",@"短信",@"新浪微博",@"QQ好友",@"QQ空间"];
        
        CGFloat OriginX      = ((self.frame.size.width - Adaptive(20)) - (Adaptive(50)*3)) / 4;
        CGFloat OriginY      = (buttonView.frame.size.height - (Adaptive(50)*2)) / 3;
        
        for (int a = 0; a < 6; a++) {
            UIImageView *imageView = [UIImageView new];
            imageView.frame        = CGRectMake(OriginX + (a%3) * (OriginX + Adaptive(50)),
                                                Adaptive(20) + (a/3) * (OriginY + Adaptive(60)),
                                                Adaptive(50),
                                                Adaptive(50));
            imageView.image        = [UIImage imageNamed:imageArray[a]];
            [buttonView addSubview:imageView];
            
            UILabel *titleLabel = [UILabel new];
            titleLabel.frame    = CGRectMake(OriginX + (a%3) * (OriginX + Adaptive(50)),
                                             CGRectGetMaxY(imageView.frame) + Adaptive(5),
                                             Adaptive(50),
                                             Adaptive(15));
            titleLabel.textColor = BASEGRYCOLOR;
            titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
            titleLabel.text      = titleArray[a];
            titleLabel.textAlignment = 1;
            [buttonView addSubview:titleLabel];
            
            UIButton  *shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            shareButton.frame      = CGRectMake(OriginX + (a%3) * (OriginX + Adaptive(50)),
                                                Adaptive(20) + (a/3) * (OriginY + Adaptive(60)),
                                                Adaptive(50),
                                                Adaptive(70));
            shareButton.tag = a+1;
            [shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [buttonView addSubview:shareButton];
            
        }
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelButton.frame     = CGRectMake(Adaptive(10),
                                            CGRectGetMaxY(buttonView.frame) + Adaptive(10),
                                            self.bounds.size.width - Adaptive(20),
                                            Adaptive(40));
        cancelButton.layer.cornerRadius = 5;
        cancelButton.layer.masksToBounds = YES;
        cancelButton.backgroundColor = [UIColor colorWithRed:229/255.0 green:228/255.0 blue:227/255.0 alpha:1];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cancelButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(14)];
        [self addSubview:cancelButton];
        
    }
    return self;
}

- (void)cancelButtonClick:(UIButton *)button {
    NSNotification *notification = [[NSNotification alloc] initWithName:@"removeShare" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)shareButtonClick:(UIButton *)button {
    
    NSNotification *notification = [[NSNotification alloc] initWithName:@"removeShare" object:nil userInfo:nil];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
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
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:
                                                urlString];
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:titleString image:shareImage location:nil urlResource:urlResource presentedController:viewController completion:^(UMSocialResponseEntity *shareResponse){
                
                
                
                if (shareResponse.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"朋友圈分享成功！%@",shareResponse);
                   
                }
            }];
            
            
        }
            break;
        case 2:
        {
            
            UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeWeb url:
                                                urlString];
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatTimeline] content:titleString image:shareImage location:nil urlResource:urlResource presentedController:viewController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"微信好友分享成功！%@",response);
                }
            }];
        }
            break;
        case 3:
        {
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSms] content:[NSString stringWithFormat:@"%@%@",titleString,urlString] image:nil location:nil urlResource:nil presentedController:viewController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"短信分享成功！%@",response);
                }
                
            }];
        }
            break;
        case 4:
        {
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToSina] content:[NSString stringWithFormat:@"%@%@",titleString,urlString] image:shareImage location:nil urlResource:nil presentedController:viewController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"微博分享成功！%@",response);
                }
            }];
            
        }
            break;
        case 5:
        {
            
            [UMSocialData defaultData].extConfig.qqData.url = urlString;
            
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:titleString image:shareImage location:nil urlResource:nil presentedController:viewController completion:^(UMSocialResponseEntity *response){
                if (response.responseCode == UMSResponseCodeSuccess) {
                    NSLog(@"QQ好友分享成功！%@",response);
                }
            }];
            
        }
            break;
        case 6:
        {
            
            [UMSocialData defaultData].extConfig.qzoneData.url = urlString;
            
            [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:titleString image:shareImage location:nil urlResource:nil presentedController:viewController completion:^(UMSocialResponseEntity *response){
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
