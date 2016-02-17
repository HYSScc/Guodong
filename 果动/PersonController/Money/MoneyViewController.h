//
//  MoneyViewController.h
//  果动
//
//  Created by mac on 15/6/12.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray* request;
@end
