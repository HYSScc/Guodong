//
//  MyDairyModel.h
//  果动
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyDairyModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *coachContent;
@property (nonatomic,retain) NSString *dairy_id;
@property (nonatomic,retain) NSString *title;
@property (nonatomic,retain) NSString *userContent;
@property (nonatomic,retain) NSArray  *photoArray;

@end
