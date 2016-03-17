//
//  TableViewCell_total.h
//  果动
//
//  Created by mac on 15/8/20.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
//公共的cell
@interface TableViewCell_total : UITableViewCell
@property (nonatomic, retain) UILabel* classLabel;
@property (nonatomic, retain) UILabel* dateLabel;
@property (nonatomic, retain) UILabel* statusLabel;
@property (nonatomic, retain) UIImageView* nextImageView;
@property (nonatomic, retain) UIView* ccView;
@property (nonatomic, retain) NSMutableAttributedString* str;
@property (nonatomic, retain) UILabel* name;
@property (nonatomic, retain) UILabel* datetime;
@property (nonatomic, retain) UILabel* number;
@property (nonatomic, retain) UILabel* address;
@property (nonatomic, retain) UIButton* jiantouButton;
@property (nonatomic, retain) UIButton *chargeback;
@property (nonatomic, retain) UIView   *backView;
@property (nonatomic, retain) UIButton *backSureButton,*backCancelButton;
@end

//有教练接单
@interface TableViewCell_haveCoach : TableViewCell_total
@property (nonatomic, retain) UIView* coachView;
@property (nonatomic, retain) UILabel* coachName;
@property (nonatomic, retain) UILabel* coachSex;
@property (nonatomic, retain) UILabel* coachClass;
@property (nonatomic, retain) UIImageView* coachImg;
@end


// 套餐课程Cell
@interface TableViewCell_package : UITableViewCell
@end