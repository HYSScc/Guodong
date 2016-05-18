//
//  ClassModel.h
//  果动
//
//  Created by mac on 16/5/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *class_id;
@property (nonatomic,retain) NSString *class_name;
@property (nonatomic,retain) NSString *class_number;
@property (nonatomic,retain) NSString *class_imageUrl;

@end
