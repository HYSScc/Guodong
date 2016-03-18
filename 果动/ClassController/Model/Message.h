//
//  Message.h
//  果动
//
//  Created by mac on 15/9/24.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *func_id;
@property (nonatomic,retain) NSString *rmb;
@property (nonatomic,retain) NSString *course_time;
@property (nonatomic,retain) NSMutableArray *packageArray;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
