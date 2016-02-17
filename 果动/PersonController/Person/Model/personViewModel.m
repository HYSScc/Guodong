//
//  personViewModel.m
//  果动
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "personViewModel.h"

@implementation personViewModel

-(instancetype)initWithPersonModel:(personModel *)personModel
{
    self = [super init];
    if (!self) return nil;
    
    _personModel = personModel;
    
    self.backimg = personModel.backimg;
    self.headimg = personModel.headimg;
    self.nickname = personModel.nickname;
    
    return self;
}
@end
