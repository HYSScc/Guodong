//
//  HttpTool.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "HttpTool.h"

@implementation HttpTool

#pragma mark Http的POST请求
+ (void)postWithUrl:(NSString*)urlStr params:(NSDictionary*)params success:(SuccessBlock)success
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
//            if (ResponseObject_RC == 0) {
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//                
//                success(dic);
//                
//                NSLog(@"rc存在  %@ %@", urlStr, dic);
//            } else {
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//                
//                [alert show];
//            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        // 请求失败
        NSLog(@"%@", [error localizedDescription]);
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据错误，正在排查中...." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        
        [alert show];
    }];
}

@end
