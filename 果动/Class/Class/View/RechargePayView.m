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
#import "AddMessageViewController.h"
@implementation RechargePayView
{
    UILabel   *priceLabel;
    UILabel   *classNumberLabel;
    NSString  *priceNumber;
    NSString  *classNumber;
    NSString  *type_id;
    UIViewController *viewController;
}
- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:109/255.0 green:110/255.0 blue:111/255.0 alpha:1];
        
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
        
        
        //微信支付
        UIImageView *weixinImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth / 6, CGRectGetMaxY(line.frame) + Adaptive(28), Adaptive(47), Adaptive(61))];
        weixinImage.userInteractionEnabled = YES;
        weixinImage.image = [UIImage imageNamed:@"pay_wx"];
        [self addSubview:weixinImage];
        
        UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        wxBtn.frame = CGRectMake(0, 0, weixinImage.bounds.size.width, weixinImage.bounds.size.height);
        wxBtn.tag = 10;
        [wxBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        [weixinImage addSubview:wxBtn];
        
        //银联支付
        UIImageView *ylImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weixinImage.frame) + viewWidth / 10, CGRectGetMaxY(line.frame) + Adaptive(30), Adaptive(58), Adaptive(59))];
        ylImage.userInteractionEnabled = YES;
        ylImage.image = [UIImage imageNamed:@"pay_yl"];
        [self addSubview:ylImage];
        
        UIButton *ylBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        ylBtn.tag = 20;
        ylBtn.frame = CGRectMake(0, 0, ylImage.bounds.size.width, ylImage.bounds.size.height);
        [ylBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
        [ylImage addSubview:ylBtn];
        
        //支付宝支付
        UIImageView *zfbImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ylImage.frame) + viewWidth / 10, CGRectGetMaxY(line.frame) + Adaptive(37), Adaptive(80), Adaptive(52))];
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
                            @"package_id":type_id
                            };
            break;
        case 20:
            NSLog(@"点击了银联支付");
            requestdict = @{
                            @"channel" : @"upacp",
                            @"types"   : @"package",
                            @"package_id":type_id
                            };
            break;
        case 30:
            NSLog(@"点击了支付宝支付");
            requestdict = @{
                            @"channel" : @"alipay",
                            @"types"   : @"package",
                            @"package_id":type_id
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
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格：%@元",priceNumber]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:15] range:NSMakeRange(0,5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:20] range:NSMakeRange(5,priceNumber.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:15] range:NSMakeRange(5+priceNumber.length,1)];
    
    priceLabel.attributedText = str;
    
    classNumberLabel.text = [NSString stringWithFormat:@"套餐包含%@课时",classNumber];
    
}
@end
