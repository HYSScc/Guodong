//
//  RegisterTextView.h
//  GuoDong
//
//  Created by mac on 16/2/2.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterTextView : UIView <UITextFieldDelegate>
@property (nonatomic, strong) UITextField* areaCodeField;
@property (nonatomic, strong) UILabel* timeLabel;
@end
