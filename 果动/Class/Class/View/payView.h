//
//  payView.h
//  果动
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface payView : UIView <UIAlertViewDelegate>
- (instancetype)initWithFrame:(CGRect)frame
                     payMoney:(NSString *)money
                    classTime:(NSString *)time
                   youhuijuan:(NSString *)juan
                     balance:(NSString *)ban
                     order_id:(NSString *)order_id
               viewController:(UIViewController *)viewController;

@property (nonatomic,retain) UILabel  *payMoneyLabel;
@property (nonatomic,retain) UILabel  *youhuiMoneyLabel;
@property (nonatomic,retain) NSString *money;
@property (nonatomic,retain) NSString *ishaveQuan;
@property (nonatomic,retain) NSString *ishaveBalance;
@property (nonatomic,retain) NSString *order_id;
@property (nonatomic,retain) NSString *classTypes;
@property (nonatomic,retain) NSString *package_id;
@end
