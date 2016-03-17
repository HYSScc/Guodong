//
//  payViewController.h
//  果动
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payViewController : UIViewController

@property (nonatomic,assign) NSInteger imageStyleNumber;
@property (nonatomic,retain) NSString  *price_one;
@property (nonatomic,retain) NSString  *price_many;
@property (nonatomic,retain) NSString  *course_time;
@property (nonatomic,assign) BOOL      isHaveJuan;
@property (nonatomic,retain) NSString  *packageName;
@property (nonatomic,retain) NSString  *publicity_code;
@property (nonatomic,retain) NSString  *classNumber;
@property (nonatomic,retain) NSString  *youhuijuan;
@property (nonatomic,retain) NSMutableArray *packageArray;
@property (nonatomic,retain) NSString  *price_number;
@property (nonatomic,retain) NSString *onePersonNumber;
@property (nonatomic,retain) NSString *order_id;
@property (nonatomic,retain) NSString *classTypes;
@property (nonatomic,retain) NSString *package_id;
@end
