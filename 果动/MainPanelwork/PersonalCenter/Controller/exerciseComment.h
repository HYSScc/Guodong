//
//  exerciseComment.h
//  果动
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface exerciseComment : NSObject
@property (nonatomic,retain)NSString *coach;
@property (nonatomic,retain)NSString *time;
@property (nonatomic,retain)NSString *ID;
@property (nonatomic,retain)NSString *isview;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
