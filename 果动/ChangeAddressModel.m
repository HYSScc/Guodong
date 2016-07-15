//
//  ChangeAddressModel.m
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ChangeAddressModel.h"

@implementation ChangeAddressModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
     
        _address = [dict objectForKey:@"address"];
    }
    return self;
}


@end
