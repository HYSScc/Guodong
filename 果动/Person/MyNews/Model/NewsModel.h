//
//  NewsModel.h
//  果动
//
//  Created by mac on 16/5/30.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;


@property (nonatomic,retain) NSString *classString;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *idString;
@property (nonatomic,retain) NSString *talkinfo;
@property (nonatomic,retain) NSString *talkphotoString;

@end
