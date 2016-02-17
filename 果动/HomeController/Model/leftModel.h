//
//  leftModel.h
//  果动
//
//  Created by mac on 16/1/5.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface leftModel : NSObject
@property (nonatomic,retain) NSString *left_name;
@property (nonatomic,retain) NSString *left_num;
@property (nonatomic,retain) NSString *left_id;
@property (nonatomic,retain) NSString *left_image;
@property (nonatomic,assign) int status;
- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
