//
//  ContentDetails.h
//  果动
//
//  Created by mac on 16/6/8.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentDetails : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *headImgString;
@property (nonatomic,retain) NSString *nickName;
@property (nonatomic,retain) NSString *timeString;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSMutableArray *photoArray;
@property (nonatomic,retain) NSString *likeNumber;
@property (nonatomic,retain) NSString *commentNumber;
@property (nonatomic,retain) NSMutableArray *likeHeadImgArray;
@property (nonatomic,retain) NSMutableArray *commentsArray;
@property (nonatomic,retain) NSString *isPraise;
@property (nonatomic,retain) NSString *talk_id;
@property (nonatomic,retain) NSString *user_id;


@end
