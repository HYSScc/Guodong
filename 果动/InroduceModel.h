//
//  InroduceModel.h
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InroduceModel : NSObject
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *price;
@property (nonatomic,retain) NSString *introduce;
@property (nonatomic,retain) NSString *courseNumber;
@property (nonatomic,retain) NSString *iconImageURL;
@property (nonatomic,assign) int      iconWidth;
@property (nonatomic,assign) int      iconHeight;
@property (nonatomic,retain) NSArray  *imageArray;
@property (nonatomic,retain) NSString *course_time;

@property (nonatomic,retain) NSString *coments_num;
@property (nonatomic,retain) NSMutableArray *commentArray;



@end
