//
//  OrderRemarkCell.m
//  果动
//
//  Created by mac on 16/6/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "OrderDataModel.h"
#import "OrderRemarkCell.h"

@implementation OrderRemarkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = BASEGRYCOLOR;
        
        _removeButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       
        [_removeButton.layer setBorderWidth:.5];
        //设置按钮的边界颜色
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef color              = CGColorCreate(colorSpaceRef, (CGFloat[]){255/255.0,125/255.0,40/255.0,1});
        [_removeButton.layer setBorderColor:color];
        
        _removeButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
        [_removeButton setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
        [_removeButton setTitle:@"删除订单" forState:UIControlStateNormal];
        [self addSubview:_removeButton];
        
        
        _commentButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       
        [_commentButton.layer setBorderWidth:.5];
         _commentButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
        //设置按钮的边界颜色
        CGColorSpaceRef commentColorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef commentColor = CGColorCreate(commentColorSpaceRef, (CGFloat[]){255/255.0,125/255.0,40/255.0,1});
        [_commentButton.layer setBorderColor:commentColor];
        
        [_commentButton setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
        [_commentButton setTitle:@"去评价" forState:UIControlStateNormal];
        [self addSubview:_commentButton];
        
        
        _payButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
       
        [_payButton.layer setBorderWidth:.5];
        _payButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
        //设置按钮的边界颜色
        CGColorSpaceRef ColorSpaceRef = CGColorSpaceCreateDeviceRGB();
        CGColorRef Color = CGColorCreate(ColorSpaceRef, (CGFloat[]){255/255.0,125/255.0,40/255.0,1});
        [_payButton.layer setBorderColor:Color];
        
        [_payButton setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
        [_payButton setTitle:@"去付款" forState:UIControlStateNormal];
        [self addSubview:_payButton];
        
    }
    return self;
}

- (void)setDataModel:(OrderDataModel *)dataModel {
 
    // 待付款  无教练栏  加载删除栏
    if ([dataModel.course_status intValue] == 6) {
        _commentButton.frame = CGRectMake(0,0,0,0);
        _removeButton.frame = CGRectMake(viewWidth - Adaptive(146),
                                         Adaptive(10),
                                         Adaptive(60),
                                         Adaptive(20));
        _payButton.frame = CGRectMake(CGRectGetMaxX(_removeButton.frame) + Adaptive(13),
                                      Adaptive(10),
                                      Adaptive(60),
                                      Adaptive(20));
       
    } else if ([dataModel.course_status intValue] == 7) {
        
        
            // 待评价
            
            _payButton.frame = CGRectMake(0,0,0,0);
            _removeButton.frame = CGRectMake(viewWidth - Adaptive(146),
                                             Adaptive(10),
                                             Adaptive(60),
                                             Adaptive(20));
            _commentButton.frame = CGRectMake(CGRectGetMaxX(_removeButton.frame) + Adaptive(13),
                                              Adaptive(10),
                                              Adaptive(60),
                                              Adaptive(20));
            
            
        } else {
            // 已评价
            _payButton.frame = CGRectMake(0,0,0,0);
            _commentButton.frame = CGRectMake(0,0,0,0);
            _removeButton.frame = CGRectMake(viewWidth - Adaptive(73),
                                             Adaptive(10),
                                             Adaptive(60),
                                             Adaptive(20));
        }
        

    
    
    CGRect Frame      = self.frame;
    Frame.size.height = CGRectGetMaxY(_removeButton.frame) + Adaptive(10);
    self.frame        = Frame;
    
}
@end
