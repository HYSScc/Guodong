//
//  MyDairyCoachCell.h
//  果动
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyDairyModel;

@interface MyDairyCoachCell : UITableViewCell

@property (nonatomic,retain) MyDairyModel *dairy;
@property (nonatomic,retain) NSString     *nickName;
@property (nonatomic,retain) UIButton *addUserButton;
@end
