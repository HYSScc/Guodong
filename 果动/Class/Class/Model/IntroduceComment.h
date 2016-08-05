//
//  IntroduceComment.h
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IntroduceComment : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@property (nonatomic,retain) NSString *headimg;
@property (nonatomic,retain) NSString *content;
@property (nonatomic,retain) NSString *nickName;
@end
