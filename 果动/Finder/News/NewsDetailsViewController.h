//
//  NewsDetailsViewController.h
//  果动
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface NewsDetailsViewController : UIViewController

@property (nonatomic,retain) NSString       *talk_id;

+ (instancetype)sharedViewControllerManager;
- (void)removeNewssss:(NSString *)talk_id user_id:(NSString *)user_id;

@end
