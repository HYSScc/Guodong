//
//  GDComment.h
//  果动
//
//  Created by z on 15/2/11.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@interface GDComment : NSObject


@property (nonatomic,retain)NSString *nickname;
@property (nonatomic,retain) NSString *  praises;
@property (nonatomic,retain)NSString *  comments;
@property (nonatomic,retain)UILabel *time;
@property (nonatomic,retain)UILabel *usename;
@property (nonatomic,retain)NSString *content;
@property (nonatomic,retain)NSString *headimg;
@property (nonatomic,retain)NSArray *photos;
@property (nonatomic,retain)NSString *hour;
@property (nonatomic,retain)NSArray *video;
@property (nonatomic,retain)NSString *type;
@property (nonatomic,retain)NSString *talkid;
@property (nonatomic,retain)NSArray *course;
@property (nonatomic,retain)NSString *rmb;
@property (nonatomic,retain)NSString *info;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *func_id;
@property (nonatomic,retain)NSString *ipraises;
@property (nonatomic,retain)NSMutableArray  * comments_list;
//评论详情
@property (nonatomic,retain)NSString *info_content;
@property (nonatomic,retain)NSString *info_time;
@property (nonatomic,retain)NSString *info_headimg;
@property (nonatomic,retain)NSString *info_nickname;
@property (nonatomic,retain)NSMutableArray *infoArray,*timeArray,*heaimgArray,*nicknameArray;
@property (nonatomic,retain)NSMutableArray *praise_listArray;
@property (nonatomic,retain)NSMutableArray *replay_listArray;
@property (nonatomic,retain)NSMutableArray *info_idArray;

-(GDComment *)initWithDictionary:(NSDictionary *)dictionary;
+(GDComment *)statusWithDictionary:(NSDictionary *)dictionary;

@end
