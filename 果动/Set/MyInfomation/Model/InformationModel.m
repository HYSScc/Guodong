//
//  InformationModel.m
//  果动
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "InformationModel.h"
#import "InformationAddress.h"

@implementation InformationModel

- (instancetype)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        
        _nickName = [dict objectForKey:@"nickname"];
    
        if ([[dict objectForKey:@"gender"] intValue] == 2) {
            _sex = @"女";
        } else {
            _sex = @"男";
        }
        _birthday   = [dict objectForKey:@"birthday"];
        _headImgUrl = [NSString stringWithFormat:@"%@",[dict objectForKey:@"headimg"]];
        _height     = [NSString stringWithFormat:@"%@",[dict objectForKey:@"height"]];
        _weight     = [NSString stringWithFormat:@"%@",[dict objectForKey:@"weight"]];
        _user_id    = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user_id"]];
        _myBalance = [NSString stringWithFormat:@"%@",[dict objectForKey:@"balance"]];
        _bannerImgUrl = [[dict objectForKey:@"footimg"] count] != 0 ? [[dict objectForKey:@"footimg"] objectForKey:@"url"] : @"";
        
           }
    return self;
}

@end
