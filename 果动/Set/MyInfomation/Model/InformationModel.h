//
//  InformationModel.h
//  果动
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InformationModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *nickName;
@property (nonatomic,retain) NSString *sex;
@property (nonatomic,retain) NSString *headImgUrl;
@property (nonatomic,retain) NSString *birthday;
@property (nonatomic,retain) NSString *height;
@property (nonatomic,retain) NSString *weight;
@property (nonatomic,retain) NSString *user_id;
@property (nonatomic,retain) NSString *myBalance;

@property (nonatomic,retain) NSString *bannerImgUrl;

@end
