//
//  HttpTool.h
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//


typedef void (^ProgressBlock)(NSProgress *progress);
typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailBlock)(NSError* error);

@interface HttpTool : NSObject 


/**
 * Http的POST请求
 */
+ (void)postWithUrl:(NSString*)urlStr params:(NSDictionary*)params body:(NSArray *)body progress:(ProgressBlock)progress success:(SuccessBlock)success;

/*rc不等于0也返回数据*/

+ (void)postNotZreoReturnWithUrl:(NSString*)urlStr params:(NSDictionary*)params success:(SuccessBlock)success;


// 判断用户是否登录
+ (BOOL)judgeWhetherUserLogin;

+ (NSString *)getUser_id ;


@end
