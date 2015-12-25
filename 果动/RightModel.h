//
//  RightModel.h
//  果动
//
//  Created by mac on 15/12/24.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RightModel : NSObject

@property (nonatomic,retain) NSString *place;
@property (nonatomic,retain) NSString *number;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *image;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
