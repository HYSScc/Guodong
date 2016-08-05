//
//  HomeModel.h
//  果动
//
//  Created by mac on 16/5/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSMutableArray *bannerArray;
@property (nonatomic,retain) NSMutableArray *activeArray;
@property (nonatomic,retain) NSMutableArray *coach_imgArray;
@property (nonatomic,retain) NSMutableArray *classArray;
@property (nonatomic,retain) NSString       *rechargeImg;
@end
