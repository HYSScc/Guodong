//
//  image.h
//  果动
//
//  Created by mac on 15/9/23.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface image : NSObject

@property (nonatomic,retain)NSString *height;
@property (nonatomic,retain)NSString *width;
@property (nonatomic,retain)NSString *imageURL;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
