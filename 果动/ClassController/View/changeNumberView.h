//
//  changeNumberView.h
//  果动
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface changeNumberView : UIView
- (instancetype)initWithFrame:(CGRect)frame
                  classNumber:(NSInteger)chassNumber
              changeViewArray:(NSMutableArray *)array
                    price_one:(NSString *)one
              onePersonNumber:(NSString *)onePersonNumber
            classPersonNumber:(NSString *)number;


@property (nonatomic,assign) NSInteger  imageStyleNumber;


@end
