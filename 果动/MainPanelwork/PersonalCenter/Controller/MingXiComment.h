//
//  MingXiComment.h
//  果动
//
//  Created by mac on 15/6/15.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MingXiComment : NSObject

@property (nonatomic,retain)NSString *money;
@property (nonatomic,retain)NSString *code;
@property (nonatomic,retain)NSString *types;
@property (nonatomic,retain)NSString *time;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
