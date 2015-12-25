//
//  RightVBaseView.h
//  果动
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RightVBaseView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,retain) NSMutableArray *modelArray;
@end
