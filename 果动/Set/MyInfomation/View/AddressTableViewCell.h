//
//  AddressTableViewCell.h
//  果动
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddressTableViewCell : UITableViewCell

@property (nonatomic,retain) UITextView  *addressTextView;
@property (nonatomic,retain) UIImageView *resultImageView;
@property (nonatomic,retain) UIButton    *resultButton,*editButton,*removeButton;
@end
