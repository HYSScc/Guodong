
//
//  changeView.m
//  果动
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "changeView.h"

@implementation changeView

- (instancetype)initWithFrame:(CGRect)frame moneyString:(NSString *)string classNumber:(NSString *)number;
{
    self = [super initWithFrame:frame];
    if (self) {
       
        [self createUIWithMoney:string classNumber:number];
    }
    return self;
}

- (void)createUIWithMoney:(NSString *)money classNumber:(NSString *)number {
    self.backgroundColor    = BASECOLOR;
    
    _ringImage              = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(2),
                                                                            (self.bounds.size.height - Adaptive(11)) / 2,
                                                                            Adaptive(11),
                                                                            Adaptive(11))];
    _ringImage.image        = [UIImage imageNamed:@"pay_ring_gry"];
    [self addSubview:_ringImage];
    
    _kuangImage                 = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(20),
                                                                                Adaptive(3),
                                                                                self.bounds.size.width - Adaptive(60),
                                                                                self.bounds.size.height - Adaptive(6))];
    _kuangImage.image = [UIImage imageNamed:@"pay_kuang_gry"];
    _kuangImage.userInteractionEnabled = YES;
    [self addSubview:_kuangImage];
    
    _changeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _changeBtn.frame = CGRectMake(Adaptive(2),
                                  Adaptive(3),
                                  Adaptive(220),
                                  self.bounds.size.height - Adaptive(6));
    
    [self addSubview:_changeBtn];
   
    NSString *className = [NSString stringWithFormat:@"%@元/%@课时",money,number];
   
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:className];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0,money.length)];
    
    
    
    _moneyLabel      = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(22),
                                                                 0,
                                                                 self.bounds.size.width *.5,
                                                                 self.bounds.size.height)];
    _moneyLabel.textColor = [UIColor lightGrayColor];
    _moneyLabel.font = [UIFont fontWithName:FONT size:15];
    _moneyLabel.attributedText = attributedString;
       [self addSubview:_moneyLabel];
    
    
    _juanLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.bounds.size.width - Adaptive(120), 0, Adaptive(80), self.bounds.size.height)];
    _juanLabel.textColor = [UIColor orangeColor];
    _juanLabel.font = [UIFont fontWithName:FONT size:11.5];
    [self addSubview:_juanLabel];
    
   

}


@end
