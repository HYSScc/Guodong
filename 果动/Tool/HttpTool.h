//
//  HttpTool.h
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 梁先森. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
typedef void(^SuccessBlock)(id responseObject);
typedef void(^FailBlock)(NSError *error);


typedef void(^HYBRequestCompletion)(id responseObject);
typedef void(^HYBErrorBlock)(NSError *error);


@interface HttpTool : NSObject

/**
 * Http的GET请求
 */
+ (void)getWithUrl:(NSString *)urlStr params:(NSDictionary *)params contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;


+ (AFHTTPRequestOperation *)uploadImageWithUrl:(NSString *)url
                                         image:(UIImage *)image
                                    completion:(HYBRequestCompletion)completion
                                    errorBlock:(HYBErrorBlock)errorBlock;


/**
 * Http的POST请求
 */
+ (void)postWithUrl:(NSString *)urlStr params:(NSDictionary *)params contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;

/**
 * Http的multipart的POST请求（上传文件用）
 */

+ (void)multipartPostWithUrl:(NSString *)urlStr params:(NSDictionary *)params fileDatas:(NSArray *)datas contentType:(NSString *)type success:(SuccessBlock)success fail:(FailBlock)fail;






+ (AFHTTPRequestOperation *)POST:(NSString *)URLString
                      parameters:(NSDictionary *)parameters
                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (AFHTTPRequestOperation *)GET:(NSString *)URLString
                     parameters:(NSDictionary *)parameters
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



+ (void)downloadImageWithUrl:(NSString *)urlStr placeholderImage:(UIImage *)image inImageView:(UIImageView *)imageView;




@end
