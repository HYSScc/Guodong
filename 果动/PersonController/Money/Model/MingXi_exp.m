//
//  MingXi_exp.m
//  果动
//
//  Created by mac on 16/3/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MingXi_exp.h"

@implementation MingXi_exp
- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.exp_code = [dictionary objectForKey:@"exp_ode"];
        self.name = [dictionary objectForKey:@"name"];
        self.status = [dictionary objectForKey:@"status"];
    }
    return self;
}
@end
