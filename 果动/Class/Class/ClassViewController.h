//
//  ClassViewController.h
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassViewController : UIViewController

+ (instancetype)sharedViewControllerManager;
- (void)removeLocationAnimation;

- (void)pushClassIntroduceView:(NSString *)class className:(NSString *)name classOrShip:(NSString *)type;

@property (nonatomic,copy) void (^pushCityViewController)(NSString* cityName);

@property (nonatomic,copy) void(^pushActiveView)(NSString *number);

@property (nonatomic,assign) BOOL cityAllowed;

@end
