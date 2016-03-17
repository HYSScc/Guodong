//
//  Mingxi_shareJuan.m
//  果动
//
//  Created by mac on 16/3/9.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "Mingxi_shareJuan.h"

@implementation Mingxi_shareJuan
- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.code = [dictionary objectForKey:@"code"];
        self.name = [dictionary objectForKey:@"name"];
        self.status = [dictionary objectForKey:@"status"];
    }
    return self;
}

@end
