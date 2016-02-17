//
//  LeftVBaseView.h
//  果动
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "SDCycleScrollView.h"
#import <UIKit/UIKit.h>
@interface LeftVBaseView : UIView<UICollectionViewDataSource ,UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout>

@property (nonatomic, retain) NSMutableArray* scrimgArray;
@property (nonatomic, retain) NSString* isVIP;
@end
