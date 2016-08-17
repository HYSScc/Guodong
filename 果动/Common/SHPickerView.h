//
//  SHPickerView.h
//  果动
//
//  Created by mac on 16/6/14.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SHPickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag pickerType:(NSString *)type pickerArray:(NSArray *)array;

// 选择date并返回
- (NSString *)changeReturnClass_id;

- (NSString *)changeReturnString;

- (NSString *)changeReturnFunc_id;

- (NSString *)returnCoach_id;

- (NSString *)returnCoachName;
@property (nonatomic,retain) UIButton *button;
@property (nonatomic,retain) UICollectionView *collection;
@end
