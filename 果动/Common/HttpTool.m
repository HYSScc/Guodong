//
//  HttpTool.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "PersonViewController.h"
#import "HttpTool.h"
#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> // MD5 加密

@interface HttpTool ()<UIAlertViewDelegate>

@end
@implementation HttpTool
{
    NSProgress *initProgress;
    NSString   *user_id;
}
#pragma mark Http的POST请求
+ (void)postWithUrl:(NSString*)urlStr params:(NSDictionary*)params body:(NSArray *)body progress:(ProgressBlock)progress success:(SuccessBlock)success
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.设置返回类型
    manager.responseSerializer    = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    // 设置请求类型
    [manager.requestSerializer setValue:@"application/json;version=V3" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"PLATFORM"];

    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
        if (body) {
            for (NSDictionary *dict in body) {
                
                NSString *name = [dict allKeys][0];
                [formData appendPartWithFileData:dict[name] name:name fileName:@"upload.png" mimeType:@"png"];
                
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功，解析数据
        if (success) {
            
          
            
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            
            if ([[dic objectForKey:@"rc"] intValue] == 0) {
                if ([[dic allKeys] containsObject:@"common"] ) {
                    
                    PersonViewController *personVC    = [PersonViewController sharedViewControllerManager];
                    if ([[[dic objectForKey:@"common"] objectForKey:@"has_message"] intValue] != 0)
                    {
                        [personVC.tabBarController.tabBar showBadgeOnItemIndex:2];
                        
                        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                                settingsForTypes:UIUserNotificationTypeBadge categories:nil];
                        
                        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                        
                    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[dic objectForKey:@"common"] objectForKey:@"has_message"] intValue];
                        
                    } else {
                        [personVC.tabBarController.tabBar hideBadgeOnItemIndex:2];
                        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                                settingsForTypes:UIUserNotificationTypeBadge categories:nil];
                        
                        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
                        
                        [UIApplication sharedApplication].applicationIconBadgeNumber = [[[dic objectForKey:@"common"] objectForKey:@"has_message"] intValue];
                    }
                    personVC.haveNews = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"common"] objectForKey:@"has_message"]];
                    
                   
                }
            }
            
            NSLog(@"rc存在  %@ %@", urlStr, dic);
            
            if ([[dic allKeys] containsObject:@"rc"]) {
                
                if ([[dic objectForKey:@"rc"] intValue] == 0 || [[dic objectForKey:@"rc"] intValue] == 24) {
                    
                    success(dic);
                }  else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[dic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
            } else {
                success(dic);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        NSLog(@"error%@", [error localizedDescription]);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器开小差了...." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
    }];
}



+ (void)postNotZreoReturnWithUrl:(NSString*)urlStr params:(NSDictionary*)params success:(SuccessBlock)success
{
    // 初始化Manager
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer    = [AFHTTPResponseSerializer serializer];
    // 2.设置返回类型
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    
    [manager.requestSerializer setValue:@"application/json;version=V3" forHTTPHeaderField:@"Accept"];
    
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"PLATFORM"];
    [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 请求成功，解析数据
        
        
        if (success) {
            
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
            
            success(dic);
            NSLog(@"rc存在  %@ %@", urlStr, dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        NSLog(@"请求失败%@", [error localizedDescription]);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器开小差了...." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
    }];
}

+ (BOOL)judgeWhetherUserLogin {
    
    NSHTTPCookieStorage* sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:BASEURL]];
   
   
    
    BOOL yesOrNo = NO;
    
    NSLog(@"cookies %@",cookies);
    for (NSHTTPCookie *cookie in cookies) {
        
    //    NSLog(@"cookie %@",cookie.properties);
        
        if (![cookie.value isEqualToString:@"0"] && [cookie.name isEqualToString:@"uid"]) {
            yesOrNo = YES;
        }
       
    }
    
    
    
    NSLog(@"yesOrNO %d",yesOrNo);
    return yesOrNo;
    
}

+ (NSString *)getUser_id {
    NSHTTPCookieStorage* sharedHTTPCookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray* cookies = [sharedHTTPCookieStorage cookiesForURL:[NSURL URLWithString:BASEURL]];
   
    
    NSString *value = @"";
    
    for (NSHTTPCookie *cookie in cookies) {
        
        if (![cookie.value isEqualToString:@"0"] && [cookie.name isEqualToString:@"uid"])  {
            value = cookie.value;
        }
    }
   
    return value;
}

// 设置行间距
+ (NSMutableAttributedString *)setLinespacingWith:(NSString *)content space:(int)space {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    
   return  attributedString;

}

@end
