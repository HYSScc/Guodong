//
//  OrderRemarkCell.h
//  果动
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
@class OrderDataModel;
@interface OrderRemarkCell : UITableViewCell
@property (nonatomic,retain) OrderDataModel *dataModel;

@property (nonatomic,retain) UIButton *removeButton,*commentButton,*payButton;
@end
