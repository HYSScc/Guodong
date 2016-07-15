//
//  AddMessageViewController.h
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddMessageViewController : UIViewController

@property (nonatomic,retain) NSString *class_id;
@property (nonatomic,retain) NSString *className;
@property (nonatomic,retain) NSString *classOrShip;
@property (nonatomic,retain) NSString *isChange;

@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *phoneNumber;
@property (nonatomic,retain) NSString *date;
@property (nonatomic,retain) NSString *time;
@property (nonatomic,retain) NSString *address;
@property (nonatomic,retain) NSString *order_id;



+ (instancetype)sharedViewControllerManager;

@end
