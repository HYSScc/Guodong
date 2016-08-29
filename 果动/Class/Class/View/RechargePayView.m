//
//  RechargePayView.m
//  果动
//
//  Created by mac on 16/7/6.
//  Copyright © 2016年 Unique. All rights reserved.
//
#define kUrlScheme @"uniqueguodong117"
#import "Pingpp.h"
#import "RechargePayView.h"
#import "makeView.h"
#import "AddMessageViewController.h"
@implementation RechargePayView
{
    UILabel   *priceLabel;
    UILabel   *classNumberLabel;
    NSString  *priceNumber;
    NSString  *classNumber;
    NSString  *type_id;
    makeView  *make;
    NSString  *balance;
    UILabel   *animationLabel;
    NSMutableAttributedString *str;
    UIViewController *viewController;
}
- (instancetype)initWithFrame:(CGRect)frame balance:(NSString *)ban viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:109/255.0 green:110/255.0 blue:111/255.0 alpha:1];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeJuan) name:@"makeJuan" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notMakeJuan) name:@"notMakeJuan" object:nil];
        balance = ban;
        
        self.frame     = frame;
        viewController = controller;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"price" object:nil];
        
        priceLabel = [UILabel new];
        priceLabel.frame    = CGRectMake(0,
                                         Adaptive(13),
                                         viewWidth,
                                         Adaptive(20));
        priceLabel.textColor = ORANGECOLOR;
        priceLabel.textAlignment = 1;
        [self addSubview:priceLabel];
        
        
        classNumberLabel = [UILabel new];
        classNumberLabel.frame = CGRectMake(0,
                                            CGRectGetMaxY(priceLabel.frame) + Adaptive(10),
                                            viewWidth,
                                            Adaptive(15));
        classNumberLabel.textColor = [UIColor lightGrayColor];
        classNumberLabel.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
        classNumberLabel.textAlignment = 1;
        [self addSubview:classNumberLabel];
        
        UILabel *line = [UILabel new];
        line.frame    = CGRectMake(0, CGRectGetMaxY(classNumberLabel.frame) + Adaptive(13),
                                   viewWidth, .5);
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
        
      // 动画label
        animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth / 2 + Adaptive(20), Adaptive(20), Adaptive(60), Adaptive(16))];
        animationLabel.textColor = ORANGECOLOR;
        animationLabel.font      = [UIFont fontWithName:FONT size:Adaptive(16)];
        
        CGFloat MaxLine_Y;
        
        if ([balance intValue] != 0) {
            // 有余额 充值套餐是抵扣
            _youhuiMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          CGRectGetMaxY(line.frame) + Adaptive(10),
                                                                          viewWidth,
                                                                          Adaptive(15))];
            _youhuiMoneyLabel.textAlignment = 1;
            _youhuiMoneyLabel.font          = [UIFont fontWithName:FONT size:Adaptive(14)];
            _youhuiMoneyLabel.text = [NSString stringWithFormat:@"您有%@元的余额可以使用，是否使用?",balance];
            [self addSubview:_youhuiMoneyLabel];
            
            make = [[makeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_youhuiMoneyLabel.frame) + Adaptive(10), viewWidth, Adaptive(20))];
            [self addSubview:make];
            
           
            UILabel *linetwo = [UILabel new];
            linetwo.frame    = CGRectMake(0, CGRectGetMaxY(make.frame) + Adaptive(13),
                                       viewWidth, .5);
            linetwo.backgroundColor = [UIColor lightGrayColor];
            [self addSubview:linetwo];
            
            MaxLine_Y  = CGRectGetMaxY(linetwo.frame) - Adaptive(20);
        } else {
            MaxLine_Y  = CGRectGetMaxY(line.frame) ;
        }
        
        
        //微信支付
        UIImageView *weixinImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth / 6, MaxLine_Y + Adaptive(28), Adaptive(47), Adaptive(61))];
        weixinImage.userInteractionEnabled = YES;
        weixinImage.image = [UIImage imageNamed:@"pay_wx"];
        [self addSubview:weixinImage];
        
        UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        wxBtn.frame = CGRectMake(0, 0, weixinImage.bounds.size.width, weixinImage.bounds.size.height);
        wxBtn.tag = 10;
        [wxBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        [weixinImage addSubview:wxBtn];
        
        //银联支付
        UIImageView *ylImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weixinImage.frame) + viewWidth / 10, MaxLine_Y + Adaptive(30), Adaptive(58), Adaptive(59))];
        ylImage.userInteractionEnabled = YES;
        ylImage.image = [UIImage imageNamed:@"pay_yl"];
        [self addSubview:ylImage];
        
        UIButton *ylBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        ylBtn.tag = 20;
        ylBtn.frame = CGRectMake(0, 0, ylImage.bounds.size.width, ylImage.bounds.size.height);
        [ylBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        [ylImage addSubview:ylBtn];
        
        //支付宝支付
        UIImageView *zfbImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ylImage.frame) + viewWidth / 10, MaxLine_Y + Adaptive(37), Adaptive(80), Adaptive(52))];
        zfbImage.userInteractionEnabled = YES;
        zfbImage.image = [UIImage imageNamed:@"pay_zfb"];
        [self addSubview:zfbImage];
        
        UIButton *zfbBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        zfbBtn.tag = 30;
        zfbBtn.frame = CGRectMake(0, 0, zfbImage.bounds.size.width, zfbImage.bounds.size.height);
        [zfbBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        [zfbImage addSubview:zfbBtn];
        
    }
    return self;
}
//使用卷
- (void)makeJuan {
    
    // 数字增加动画
    self.ishave = @"1"; // 使用余额
    animationLabel.alpha = 1.f;
    animationLabel.text = [NSString stringWithFormat:@"-%@",balance];
    NSString *monrySting = [NSString stringWithFormat:@"%d",[priceNumber intValue] - [balance intValue]];
    
    
    
    [UIView animateWithDuration:1.5f animations:^{
        CGRect newFrame    = animationLabel.frame;
        newFrame.origin.x += 50;
        newFrame.origin.y -= 50;
        animationLabel.frame = newFrame;
        animationLabel.alpha = 0.f;
        
    }];
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格: %@元",monrySting]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(14)] range:NSMakeRange(0,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(20)] range:NSMakeRange(6,monrySting.length)];
    priceLabel.attributedText = str;
    
    
    
    [self addSubview:animationLabel];
    
    
}

////不使用卷
- (void)notMakeJuan {
//    NSLog(@"不使用卷");
    self.ishave = @"0"; // 不使用卷
    animationLabel.frame = CGRectMake(viewWidth / 2 + Adaptive(20), Adaptive(20), Adaptive(60), Adaptive(16));
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格：%@元",priceNumber]];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(15)] range:NSMakeRange(0,5)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(20)] range:NSMakeRange(5,priceNumber.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(15)] range:NSMakeRange(5+priceNumber.length,1)];
    
    priceLabel.attributedText = string;
    [animationLabel removeFromSuperview];
}


- (void)payClick:(UIButton *)button {
    NSNotification *notification =[NSNotification notificationWithName:@"removeRechargeView" object:nil userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

    
    NSString * kUrl = [NSString stringWithFormat:@"%@charge/", BASEURL];

    NSDictionary *requestdict;
    
    switch (button.tag) {
        case 10:
            NSLog(@"点击了微信支付");
            requestdict = @{
                            @"channel" : @"wx",
                            @"types"   : @"package",
                            @"package_id":type_id,
                             @"is_use_balance": _ishave,
                            };
            break;
        case 20:
            NSLog(@"点击了银联支付");
            requestdict = @{
                            @"channel" : @"upacp",
                            @"types"   : @"package",
                            @"package_id":type_id,
                             @"is_use_balance": _ishave,
                            };
            break;
        case 30:
            NSLog(@"点击了支付宝支付");
            requestdict = @{
                            @"channel" : @"alipay",
                            @"types"   : @"package",
                            @"package_id":type_id,
                             @"is_use_balance": _ishave,
                            };
            break;
            
        default:
            break;
    }
    NSLog(@"支付数据 %@",requestdict);
    
    
    [HttpTool postWithUrl:kUrl params:requestdict body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString* charge = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"charge = %@", charge);
    
      
        
        [Pingpp createPayment:charge
               viewController:viewController
                 appURLScheme:kUrlScheme
               withCompletion:^(NSString *result, PingppError *error) {
                   NSLog(@"completion block: %@", result);
                   if ([result isEqualToString:@"success"]) {
                       // 支付成功
                       NSLog(@"成功");
                       NSNotification *notification = [NSNotification notificationWithName:@"pushMainView" object:nil userInfo:nil];
                       
                       //通过通知中心发送通知
                       [[NSNotificationCenter defaultCenter] postNotification:notification];
                       
                   } else {
                       // 支付失败或取消
                       NSLog(@"Error: code=%lu msg=%@", error.code, [error getMsg]);
                   }
               }];
        
    }];
    
}
- (void)tongzhi:(NSNotification *)notification {
   
    
    priceNumber = [notification.userInfo objectForKey:@"price"];
    classNumber = [notification.userInfo objectForKey:@"classNumber"];
    type_id     = [notification.userInfo objectForKey:@"id"];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格：%@元",priceNumber]];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(15)] range:NSMakeRange(0,5)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(20)] range:NSMakeRange(5,priceNumber.length)];
    [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(15)] range:NSMakeRange(5+priceNumber.length,1)];
    
    priceLabel.attributedText = string;
    
    classNumberLabel.text = [NSString stringWithFormat:@"套餐包含%@课时",classNumber];
    
}
@end
