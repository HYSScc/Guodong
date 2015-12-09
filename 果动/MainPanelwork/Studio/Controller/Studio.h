//
//  Studio.h
//  果动
//
//  Created by mac on 15/4/27.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Studio : NSObject
@property (nonatomic,retain)NSString *place,*ID;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
