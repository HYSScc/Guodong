//
//  CommentModel.h
//  果动
//
//  Created by mac on 16/5/24.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *headImgString;
@property (nonatomic,retain) NSString *nickName;
@property (nonatomic,retain) NSString *dateString;
@property (nonatomic,retain) NSString *contentString;
@property (nonatomic,retain) NSString *comment_id;
@property (nonatomic,retain) NSMutableArray *replyArray;

@property (nonatomic,retain) NSString *user_id;
@end
