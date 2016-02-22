//
//  HttpTool.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 梁先森. All rights reserved.
//


#import "HomeController.h"

@implementation HttpTool
#pragma mark Http的GET请求
+ (void)getWithUrl:(NSString*)urlStr params:(NSDictionary*)params contentType:(NSString*)type success:(SuccessBlock)success fail:(FailBlock)fail
{
    // 1.创建Http请求操作管理器
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] init];
    // 2.设置返回类型
    if (type) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:type];
    }
    // 3.创建Http请求操作对象
    AFHTTPRequestOperation* op = [manager GET:urlStr parameters:params success:^(AFHTTPRequestOperation* operation, id responseObject) {
        if (success) { //success不为空
            success(responseObject);
        }
    }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            if (fail) { //fail不为空
                fail(error);
            }
        }];
    // 4.发送请求
    [op start];
}

+ (AFHTTPRequestOperation*)uploadImageWithUrl:(NSString*)url
                                        image:(UIImage*)image
                                   completion:(HYBRequestCompletion)completion
                                   errorBlock:(HYBErrorBlock)errorBlock
{

    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] init];
    AFHTTPRequestOperation* op = [manager POST:url parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData* imageData = UIImageJPEGRepresentation(image, 0.01);

        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString* str = [formatter stringFromDate:[NSDate date]];
        NSString* fileName = [NSString stringWithFormat:@"%@.jpg", str];

        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"myfiles" fileName:fileName mimeType:@"image/jpeg"];
    }
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            completion(responseObject);
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            errorBlock(error);
        }];

    return op;
}

#pragma mark Http的POST请求
+ (void)postWithUrl:(NSString*)urlStr params:(NSDictionary*)params contentType:(NSString*)type success:(SuccessBlock)success fail:(FailBlock)fail
{
    // 1.创建Http请求操作管理器
    AFHTTPRequestOperationManager* manager = [[AFHTTPRequestOperationManager alloc] init];
    // 2.设置返回类型
    if (type) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:type];
    }
    [manager.requestSerializer setValue:@"IOS" forHTTPHeaderField:@"PLATFORM"];
    // 3.创建Http请求操作对象
    AFHTTPRequestOperation* op = [manager POST:urlStr parameters:params success:^(AFHTTPRequestOperation* operation, id responseObject) {
        if (success) {
            NSLog(@"rc存在  %@ %@", urlStr, responseObject);
            success(responseObject);
        }
    }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            if (fail) { //fail不为空
                fail(error);
                NSLog(@"请求失败 %@", error);
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据错误，正在排查中...." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];

                [alert show];
            }
        }];
    // 4.发送请求
    [op start];
}

#pragma mark Http的multipart的POST请求
+ (void)multipartPostWithUrl:(NSString*)urlStr params:(NSDictionary*)params fileDatas:(NSArray*)datas contentType:(NSString*)type success:(SuccessBlock)success fail:(FailBlock)fail
{
    // 1.创建Http请求操作管理器
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager new];
    // 2.设置返回类型
    if (type) {
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:type];
    }
    // 3.创建Http请求操作对象

    AFHTTPRequestOperation* op = [manager POST:urlStr parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 上传多张图片
        for (NSDictionary* dict in datas) {
            NSString* name = [dict allKeys][0];
            [formData appendPartWithFileData:dict[name] name:name fileName:@"upload.png" mimeType:@"image/png"];
        }
    }
        success:^(AFHTTPRequestOperation* operation, id responseObject) {
            if (success) {

                success(responseObject);
            }
        }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            if (fail) {
                fail(error);
            }
        }];
    // 4.Http请求操作对象开始请求
    [op start];
}

+ (AFHTTPRequestOperation*)POST:(NSString*)URLString
                     parameters:(NSDictionary*)parameters
                        success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{

    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    //你的接口地址
    //发送请求
    return [manager POST:URLString parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        success(operation, responseObject);
    }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            failure(operation, error);
        }];
}
+ (AFHTTPRequestOperation*)GET:(NSString*)URLString
                    parameters:(NSDictionary*)parameters
                       success:(void (^)(AFHTTPRequestOperation* operation, id responseObject))success
                       failure:(void (^)(AFHTTPRequestOperation* operation, NSError* error))failure
{
    AFHTTPRequestOperationManager* manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是json类型
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    //如果报接受类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/css", nil];

    return [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation* operation, id responseObject) {
        success(operation, responseObject);
    }
        failure:^(AFHTTPRequestOperation* operation, NSError* error) {
            failure(operation, error);
        }];
}

+ (void)downloadImageWithUrl:(NSString*)urlStr placeholderImage:(UIImage*)image inImageView:(UIImageView*)imageView;
{
    NSURL* url = [NSURL URLWithString:urlStr];
    [imageView setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
}

@end
