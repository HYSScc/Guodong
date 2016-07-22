//
//  My_NewsTableViewCell.h
//  果动
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyNewsModel;

@interface My_NewsTableViewCell : UITableViewCell <UIActionSheetDelegate>

@property (nonatomic,retain) MyNewsModel *newsModel;

@end
