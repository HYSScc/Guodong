//
//  MoneyTableViewCell.h
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MoneyModel;

@interface MoneyTableViewCell : UITableViewCell

@property (nonatomic,retain) UIImageView *baseImageView;
@property (nonatomic,retain) UILabel     *moneyLabel;
@property (nonatomic,retain) UILabel     *nameLabel;
@property (nonatomic,retain) UILabel     *dateLabel;
@property (nonatomic,retain) UILabel     *contentLabel;
@property (nonatomic,retain) MoneyModel  *moneyModel;

@property (nonatomic,retain) UILabel *leftLine, *rightLine;
@end
