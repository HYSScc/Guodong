//
//  PersonalCenterController.h
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//
typedef void (^SuccessBlock)(id responseObject);
//typedef void(^FailBlock)(NSError *error);
#import <UIKit/UIKit.h>

@interface PersonalCenterController : UIViewController <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
+ (instancetype)sharedViewControllerManager;
@property (nonatomic, retain) NSString* address;
@property (nonatomic, assign) int succ;
@end
