//
//  TCMessage.m
//  果动
//
//  Created by mac on 15/8/4.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "TCMessage.h"

@implementation TCMessage
@synthesize message = _message;
@synthesize fromMe = _fromMe;

- (id)initWithMessage:(NSString *)message fromMe:(BOOL)fromMe;
{
    self = [super init];
    if (self) {
        _fromMe = fromMe;
        _message = message;
    }
    
    return self;
}

@end
