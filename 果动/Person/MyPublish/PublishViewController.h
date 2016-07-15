//
//  PublishViewController.h
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishViewController : UIViewController

@property (nonatomic,copy) void (^changeView)(int number);


@property (nonatomic,retain) NSString *user_id;
@end
