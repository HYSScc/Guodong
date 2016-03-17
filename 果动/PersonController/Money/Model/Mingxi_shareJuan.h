//
//  Mingxi_shareJuan.h
//  果动
//
//  Created by mac on 16/3/9.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Mingxi_shareJuan : NSObject
@property (nonatomic,retain) NSString *code;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,assign) BOOL status;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
