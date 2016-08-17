//
//  ContentModel.h
//  果动
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentModel : NSObject

@property (nonatomic,retain) NSString *headImgUrl;
@property (nonatomic,retain) NSString *nameString;
@property (nonatomic,retain) NSString *dateString;
@property (nonatomic,retain) NSString *contentString;
@property (nonatomic,retain) NSArray  *conetntImgArray;
@property (nonatomic,retain) NSString *likeNumber;
@property (nonatomic,retain) NSString *commentNumber;
@property (nonatomic,retain) NSString *isPraise;
@property (nonatomic,retain) NSString *tail_id;
@property (nonatomic,retain) NSString *time;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
