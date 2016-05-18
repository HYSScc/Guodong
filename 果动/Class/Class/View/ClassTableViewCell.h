//
//  ClassTableViewCell.h
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassTableViewCell : UITableViewCell

@property (nonatomic,retain) UIImageView *baseImageView;
@property (nonatomic,retain) UILabel     *titleLabel;
@property (nonatomic,retain) UILabel     *classNumberLabel;
@property (nonatomic,retain) UILabel *moreLabel;
@end



@interface LeftLastCell : UITableViewCell
@property (nonatomic,retain) UILabel *moreLabel;

@end
