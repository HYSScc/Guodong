//
//  AddMessageView.h
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMessageView : UIView
- (instancetype)initWithFrame:(CGRect)frame dictionary:(NSDictionary *)dict;

@property (nonatomic,retain) UITextField  *textField;
@property (nonatomic,retain) UIButton    *messageButton;
@property (nonatomic,retain) UILabel     *messageLabel;
@end
