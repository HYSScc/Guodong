//
//  DetailsCommentView.h
//  果动
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentDetails;

@interface DetailsCommentView : UIView

@property (nonatomic,retain) ContentDetails *details;



- (instancetype)initWithFrame:(CGRect)frame ContentDetails:(ContentDetails *)details viewController:(UIViewController *)controller;



@end
