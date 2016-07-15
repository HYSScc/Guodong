//
//  FinderViewController.h
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinderViewController : UIViewController

+ (instancetype)sharedViewControllerManager;

- (void)pushPublishViewWithName:(NSString *)name;

- (void)pushWebViewWithName:(NSString *)content_id;

- (void)pushNewsDetailsViewWithindex:(NSInteger )index;

@end
