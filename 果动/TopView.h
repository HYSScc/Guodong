//
//  TopView.h
//  果动
//
//  Created by mac on 15/12/21.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TopView : UIView
@property (nonatomic,retain) UILabel *classnumberLabel;

- (id)initWithFrame:(CGRect)frame imageTypeWith:(int)type ClassNumberWith:(int)number showClassNumberWith:(BOOL)isShow;
@end
