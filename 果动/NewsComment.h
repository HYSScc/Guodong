//
//  NewsComment.h
//  果动
//
//  Created by mac on 15/12/10.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsComment : NSObject

@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *replay;
@property (nonatomic,retain) NSString *nickname;
@property (nonatomic,retain) NSURL *headImageStr;
@property (nonatomic,retain) NSString *dateStr;
@property (nonatomic,retain) NSURL *phototStr;
@property (nonatomic,retain) NSString *type;
@property (nonatomic,retain) NSString  *talk_id;

-(NewsComment *)initWithDictionary:(NSDictionary *)dictionary;
+(NewsComment *)statusWithDictionary:(NSDictionary *)dictionary;
@end
