//
//  NewsFunctionView.h
//  果动
//
//  Created by mac on 16/5/30.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentDetails;
@class MyNewsModel;
@interface NewsFunctionView : UIView

@property (nonatomic,retain) ContentDetails *details;

@property (nonatomic,retain) MyNewsModel    *newsModel;



@property (nonatomic,retain) UIButton *praiseButton;
@property (nonatomic,retain) UIButton *shareButton;
@property (nonatomic,retain) UIButton *commentButton;
@property (nonatomic,retain) UIButton *moreButton;

@end
