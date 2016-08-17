//
//  addCoachModel.h
//  果动
//
//  Created by mac on 16/8/16.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface addCoachModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dict;

@property (nonatomic,retain) NSString *coachImageName;
@property (nonatomic,retain) NSString *coachName;
@property (nonatomic,retain) NSString *coach_id;
@property (nonatomic,assign) BOOL     has_course;
@end
