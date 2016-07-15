//
//  InformationAddress.m
//  果动
//
//  Created by mac on 16/6/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "InformationAddress.h"

@implementation InformationAddress
- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        _address    = [dict objectForKey:@"address"];
        _isDefault  = [[dict objectForKey:@"default"] intValue];
        _address_id = [[dict objectForKey:@"id"] intValue];
    }
    return self;
}

@end
