//
//  MyNewsModel.h
//  果动
//
//  Created by mac on 16/6/23.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyNewsModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *nickName;
@property (nonatomic,retain) NSString *headimgUrl;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *photoUrl;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *praises;
@property (nonatomic,retain) NSString *comments;
@property (nonatomic,retain) NSString *ipraises;
@property (nonatomic,assign) CGFloat  height;
@property (nonatomic,assign) CGFloat  widht;
@property (nonatomic,retain) NSString *talk_id;

@end
