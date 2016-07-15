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
- (NSString *)changeReturnString;

- (NSString *)changeReturnFunc_id;
@property (nonatomic,retain) UIButton *button;

@end
