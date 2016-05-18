//
//  ShopModel.h
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopModel : NSObject
@property (nonatomic, retain) NSString* place;
@property (nonatomic, retain) NSString* number;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, retain) NSString* image;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
