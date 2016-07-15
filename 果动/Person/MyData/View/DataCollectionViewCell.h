//
//  DataCollectionViewCell.h
//  果动
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
// 图片放大
#import "TapImageView.h"
@class MyDataModel;

@interface DataCollectionViewCell : UICollectionViewCell

@property (nonatomic,retain) MyDataModel *dataModel;
@property (nonatomic,retain) TapImageView *leftImageView, *rightImageView;
@end
