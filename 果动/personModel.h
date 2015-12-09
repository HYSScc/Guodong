//
//  personModel.h
//  果动
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface personModel : NSObject
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic,retain) NSString *backimg;
@property (nonatomic,retain) NSString *gender;
@property (nonatomic,retain) NSString *headimg;
@property (nonatomic,retain) NSString *is_vip;
@property (nonatomic,retain) NSString *isView;
@property (nonatomic,retain) NSString *nickname;
@end
