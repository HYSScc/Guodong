//
//  QuestionandSport.h
//  果动
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatModel.h"
@interface QuestionandSport : UIViewController
@property (nonatomic,retain)NSString *headimgstr;
@property (nonatomic,retain)NSString *nickname;
@property (strong, nonatomic) ChatModel *chatModel;
@property (strong, nonatomic) UITableView *chatTableView;
@property (nonatomic,assign) int  keyboardHeight,keyboardOriginY;

+ (instancetype)sharedViewControllerManager;
@end
