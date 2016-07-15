//
//  addMessageCourse.h
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addMessageCourse : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *func_id;
@property (nonatomic,retain) NSString *oneClassPrice;
@property (nonatomic,retain) NSString *oneClassTime;
@property (nonatomic,retain) NSString *name;

@end
