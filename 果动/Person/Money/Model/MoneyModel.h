//
//  MoneyModel.h
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *code;
@property (nonatomic,retain) NSString *types;
@property (nonatomic,retain) NSString *money;
@property (nonatomic,retain) NSString *inc;
@property (nonatomic,retain) NSString *expires;

@property (nonatomic,retain) NSString *topTitle;

@end
