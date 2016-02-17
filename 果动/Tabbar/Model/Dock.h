//
//  Dock.h
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

//#define kDockH 54

@class Dock;

@protocol DockDelegate <NSObject>
@optional
- (void)dock:(Dock *)dock selectedItemFrom:(NSInteger)from to:(NSInteger)to;

@end

@interface Dock : UIView


-(void)addItemWithTitle:(NSString *)title Icon:(NSString *)icon selectedIcon:(NSString *)selectedIcon;

@property (nonatomic, assign) id<DockDelegate> delegate;


@end
