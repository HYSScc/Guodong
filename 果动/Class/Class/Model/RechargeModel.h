//
//  RechargeModel.h
//  果动
//
//  Created by mac on 16/7/6.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RechargeModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *titleName;
@property (nonatomic,retain) NSString *price;
@property (nonatomic,retain) NSString *classNumber;
@property (nonatomic,retain) NSString *type_id;

@end
