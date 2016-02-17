//
//  QuestionComment.h
//  果动
//
//  Created by mac on 15/5/21.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionComment : NSObject
@property (nonatomic,retain)NSString *question;
@property (nonatomic,retain)NSString *ID;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
