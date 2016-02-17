//
//  image.m
//  果动
//
//  Created by mac on 15/9/23.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "image.h"

@implementation image
-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init])
    {
        self.height = [dictionary objectForKey:@"height"];
        self.width = [dictionary objectForKey:@"width"];
        self.imageURL = [dictionary objectForKey:@"imgurl"];
    }
    return self;
}
@end
