//
//  MoneyIntroduceModel.h
//  果动
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyIntroduceModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *content;

@end
