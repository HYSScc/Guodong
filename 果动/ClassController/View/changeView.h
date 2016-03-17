//
//  changeView.h
//  果动
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changeView : UIView

- (instancetype)initWithFrame:(CGRect)frame moneyString:(NSString *)string classNumber:(NSString *)number;

@property (nonatomic,retain) UIImageView *ringImage;
@property (nonatomic,retain) UIImageView *kuangImage;
@property (nonatomic,retain) UIButton    *changeBtn;
@property (nonatomic,retain) UILabel     *moneyLabel;
@property (nonatomic,retain) UILabel     *juanLabel;

@end
