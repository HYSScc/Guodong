//
//  InformationAddress.h
//  果动
//
//  Created by mac on 16/6/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationAddress : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *address;
@property (nonatomic,assign) BOOL      isDefault;
@property (nonatomic,assign) int       address_id;
@end
