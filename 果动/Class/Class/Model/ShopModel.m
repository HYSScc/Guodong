//
//  ShopModel.m
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ShopModel.h"

@implementation ShopModel
- (instancetype)initWithDictionary:(NSDictionary*)dictionary
{
    if (self = [super init]) {
        self.place = [dictionary objectForKey:@"place"];
        self.number = [dictionary objectForKey:@"number"];
        self.name = [dictionary objectForKey:@"name"];
        self.image = [[dictionary objectForKey:@"img"] objectForKey:@"imgurl"];
    }
    return self;
}
@end
