
//
//  RightModel.m
//  果动
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "RightModel.h"

@implementation RightModel
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
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
