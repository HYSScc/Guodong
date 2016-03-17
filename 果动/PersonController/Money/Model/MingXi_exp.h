//
//  MingXi_exp.h
//  果动
//
//  Created by mac on 16/3/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MingXi_exp : NSObject
@property (nonatomic,retain) NSString *exp_code;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,assign) BOOL status;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
