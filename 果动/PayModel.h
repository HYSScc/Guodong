//
//  PayModel.h
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PayModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *remark;
@property (nonatomic,retain) NSString *price;
@property (nonatomic,retain) NSString *classNumber;
@property (nonatomic,retain) NSString *package_id;
@end
