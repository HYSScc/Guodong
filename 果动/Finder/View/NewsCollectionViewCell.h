//
//  NewsCollectionViewCell.h
//  果动
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCollectionViewCell : UICollectionViewCell

@property (nonatomic,retain) UIImageView *headerImage;
@property (nonatomic,retain) UILabel     *nameLabel;
@property (nonatomic,retain) UIImageView *contentImage;
@property (nonatomic,retain) UILabel     *contentLabel;
@property (nonatomic,assign) NSInteger   likeNumber;
@property (nonatomic,assign) NSInteger   commentNumber;


@end
