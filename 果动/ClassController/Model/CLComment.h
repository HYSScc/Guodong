//
//  CLComment.h
//  果动
//
//  Created by mac on 15/3/11.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLComment : NSObject

@property (nonatomic,retain)NSString *func_id;
@property (nonatomic,retain)NSString *course_img;
@property (nonatomic,retain)NSString *info;
@property (nonatomic,retain)NSString *name;
@property (nonatomic,retain)NSString *rmb;
@property (nonatomic,retain)NSArray *all_course;
@property (nonatomic,retain)NSString *all_class;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
