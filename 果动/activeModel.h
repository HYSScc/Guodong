//
//  activeModel.h
//  果动
//
//  Created by mac on 16/8/2.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface activeModel : NSObject

@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *url;
@property (nonatomic)        int       type;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
