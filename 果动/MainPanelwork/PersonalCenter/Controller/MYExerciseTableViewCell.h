//
//  MYExerciseTableViewCell.h
//  果动
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MYExerciseTableViewCell : UITableViewCell
@property (nonatomic, retain) NSString* coach;
@property (nonatomic, retain) NSString* time;
@property (nonatomic, retain) NSString* ID;
@property (nonatomic, retain) UILabel* timeLabel;
@property (nonatomic, retain) UILabel* coachLabel;
@property (nonatomic, retain) UIImageView* baseImageView;
@end
