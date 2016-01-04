//
//  priceList.h
//  果动
//
//  Created by mac on 15/12/22.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface priceList : NSObject
@property (nonatomic,retain) NSString *price_classes_id;
@property (nonatomic,retain) NSString *price_id;
@property (nonatomic,retain) NSString *price_num;
@property (nonatomic,retain) NSString *price_name;
@property (nonatomic,retain) NSString *price_rmb;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
