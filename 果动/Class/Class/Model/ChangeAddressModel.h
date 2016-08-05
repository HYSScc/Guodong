//
//  ChangeAddressModel.h
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChangeAddressModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;
@property (nonatomic,retain) NSString *address;

@end
