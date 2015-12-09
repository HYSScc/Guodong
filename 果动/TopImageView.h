//
//  TopView.h
//  果动
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "personModel.h"
@interface TopImageView : UIImageView
<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

+ (instancetype)sharedViewControllerManager;

@property (nonatomic,retain) personModel *person;
@property (nonatomic,retain) UIViewController *viewController;
@end
