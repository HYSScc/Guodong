//
//  PictureModel.h
//  果动
//
//  Created by mac on 16/6/7.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *imageString;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *content_id;
@property (nonatomic,retain) NSString *content;

@end
