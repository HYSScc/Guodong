//
//  activeViewController.h
//  果动
//
//  Created by mac on 16/3/8.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface activeViewController : UIViewController
@property (nonatomic,retain) NSString *number;
@property (nonatomic,retain) NSMutableArray *activeArray;


@property (nonatomic,strong) NSString *img;
@property (nonatomic,strong) NSString *url;
@property (nonatomic)        int      type;
@property (nonatomic,strong) NSString *name;

@end
