//
//  HttpTool.h
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailBlock)(NSError* error);

@interface HttpTool : NSObject


/**
 * Http的POST请求
 */
+ (void)postWithUrl:(NSString*)urlStr params:(NSDictionary*)params success:(SuccessBlock)success;

@end
