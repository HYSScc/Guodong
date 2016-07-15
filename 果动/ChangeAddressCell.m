
//
//  ChangeAddressCell.m
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ChangeAddressCell.h"
#import "ChangeAddressModel.h"
@implementation ChangeAddressCell
{
    UILabel *addressLabel;
    UILabel *line;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor   = BASEGRYCOLOR;
        addressLabel           = [UILabel new];
        addressLabel.textColor = [UIColor whiteColor];
        addressLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        addressLabel.textAlignment = 1;
        addressLabel.numberOfLines = 0;
        [self addSubview:addressLabel];
        
        line       = [UILabel new];
        line.backgroundColor = BASECOLOR;
        [self addSubview:line];
    }
    return self;
}

- (void)setAddress:(ChangeAddressModel *)address {
    
    CGSize textSize = [address.address boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]} context:nil].size;
    
   
    if (textSize.height > Adaptive(50)) {
       addressLabel.frame = CGRectMake(Adaptive(13),
                                       0,
                                       viewWidth - Adaptive(26),
                                       textSize.height);
    } else {
        addressLabel.frame = CGRectMake(Adaptive(13),
                                        0,
                                        viewWidth - Adaptive(26),
                                        Adaptive(50));
    }
    
    addressLabel.text = address.address;
    line.frame        = CGRectMake(0,
                                   CGRectGetMaxY(addressLabel.frame),
                                   viewWidth,
                                   .5);
    CGRect Frame      = self.frame;
    Frame.size.height = CGRectGetMaxY(line.frame);
    self.frame        = Frame;
}

@end
