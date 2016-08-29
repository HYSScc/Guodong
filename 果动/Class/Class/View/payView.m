//
//  payView.m
//  果动
//
//  Created by mac on 16/3/4.
//  Copyright © 2016年 Unique. All rights reserved.
//
#define kUrlScheme @"uniqueguodong117"
#import "payView.h"
#import "makeView.h"
#import "Pingpp.h"

#import "AppDelegate.h"
@implementation payView
{
    makeView                  *make;
    NSMutableAttributedString *str;
    UILabel                   *classTimeLabel;
    NSString                  *classTime;
    NSString                  *youhuijuan;
    NSString                  *balance;
    UILabel                   *animationLabel;
    NSString                  *payMoney;
    NSString                  *kUrl;
    UIViewController          *payViewController;
    NSDictionary              *requestdict; // 支付的数据字典
    
}
- (instancetype)initWithFrame:(CGRect)frame
                     payMoney:(NSString *)money
                    classTime:(NSString *)time
                   youhuijuan:(NSString *)juan
                     balance:(NSString *)ban
                     order_id:(NSString *)order_id
               viewController:(UIViewController *)viewController
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:109/255.0 green:110/255.0 blue:111/255.0 alpha:1];
        youhuijuan  = juan;
        balance    = ban;
        NSLog(@"balance %@",balance);
        payMoney    = money;
        requestdict = [NSDictionary new];
        self.ishaveQuan    = @"0";        // 默认不使用卷
        self.ishaveBalance = @"0";  // 默认不使用余额
        _classTypes = @"gdcourse"; // 默认单次课
        _order_id   = order_id;
        _package_id = @"";
        payViewController = viewController;
        NSLog(@"_classTypes %@ _package_id %@  order_id %@",_classTypes,_package_id,_order_id);
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMoney:) name:@"changeMoney" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeJuan) name:@"makeJuan" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notMakeJuan) name:@"notMakeJuan" object:nil];
        [self createUIWithPayMoney:money classTime:time youhuijuan:juan balance:ban];
    }
    return self;
}

//使用卷
- (void)makeJuan {
   
   
    
    // 数字增加动画
   
    animationLabel.alpha = 1.f;
    NSString *monrySting;
    if ([balance intValue] != 0) {
        // 有余额 使用余额
      self.ishaveBalance = @"1";
        // 判断余额是否大于课程价格
        if ([balance intValue] > [payMoney intValue]) {
            // 大于
            monrySting          = @"0";
            animationLabel.text = [NSString stringWithFormat:@"-%@",payMoney];
        } else {
            // 小于
             monrySting          = [NSString stringWithFormat:@"%@",payMoney];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您的余额不足支付当前课时费，余额可用于充值套餐的抵扣" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去充值", nil];
            alert.tag = 99;
            [alert show];
            
             
             UIImageView *imageViewLeft  = (UIImageView *)[make viewWithTag:3];
             UIImageView *imageViewRight = (UIImageView *)[make viewWithTag:6];
             UILabel *labelRight         = (UILabel *)[make viewWithTag:10];
             UILabel *labelLeft          = (UILabel *)[make viewWithTag:5];
             imageViewLeft.image  = [UIImage imageNamed:@"pay_duihao"];
             imageViewRight.image = [UIImage imageNamed:@"pay_duihao_red"];
             labelLeft.textColor  = [UIColor lightGrayColor];
             labelRight.textColor = ORANGECOLOR;
            
        }
        
        //
    } else {
         self.ishaveQuan = @"1"; // 使用优惠劵
        // 没有余额  使用优惠券
        animationLabel.text = [NSString stringWithFormat:@"-%@",youhuijuan];
        monrySting = [NSString stringWithFormat:@"%d",[payMoney intValue] - [youhuijuan intValue]];
    }
    
    
   
    [UIView animateWithDuration:1.5f animations:^{
        CGRect newFrame    = animationLabel.frame;
        newFrame.origin.x += 50;
        newFrame.origin.y -= 50;
        animationLabel.frame = newFrame;
        animationLabel.alpha = 0.f;

            }];
   str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格: %@元",monrySting]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:14] range:NSMakeRange(0,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:20] range:NSMakeRange(6,monrySting.length)];
    _payMoneyLabel.attributedText = str;

   
   
    [self addSubview:animationLabel];
    
    
}

//不使用卷
- (void)notMakeJuan {
     NSLog(@"不使用卷");
    
    if ([balance intValue] != 0) {
        self.ishaveBalance = @"0";
    } else {
         // 没有余额  使用优惠券
         self.ishaveQuan = @"0"; // 不使用卷
    }
    
   
    animationLabel.frame = CGRectMake(viewWidth / 2 + Adaptive(20), Adaptive(20), Adaptive(40), Adaptive(15));
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格: %@元",payMoney]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:14] range:NSMakeRange(0,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:20] range:NSMakeRange(6,payMoney.length)];
    _payMoneyLabel.attributedText = str;
    [animationLabel removeFromSuperview];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        if (alertView.tag == 99) {
            // 充值套餐
            NSNotification *notification = [[NSNotification alloc] initWithName:@"pushRechargeVC" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        } else if (alertView.tag == 98){
            // 确认用余额订课
            [self payWithDict:requestdict];
        } else {
            // 前往订单
            NSNotification *notification = [[NSNotification alloc] initWithName:@"pushPersonView" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
        
       
    }
    
}

- (void)changeMoney:(NSNotification *)notification {
    
    _money      = [notification.userInfo objectForKey:@"money"];
    payMoney    = _money;
    _classTypes = [notification.userInfo objectForKey:@"payTypes"];
    _package_id = [notification.userInfo objectForKey:@"package_id"];
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格: %@元",_money]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:14] range:NSMakeRange(0,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:20] range:NSMakeRange(6,_money.length)];
    _payMoneyLabel.attributedText = str;
    
}

- (void)createUIWithPayMoney:(NSString *)money classTime:(NSString *)classtime youhuijuan:(NSString *)juan balance:(NSString *)ban{
    
    for (int a = 1; a < 3 ; a++) {
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  (self.bounds.size.height / 3) * a,
                                                                  viewWidth,
                                                                  .6)];
        line.tag = a * 10;
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
    }
    
    /**
     *  当前价格
     */
    
    animationLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth / 2 + Adaptive(20), Adaptive(20), Adaptive(40), Adaptive(15))];
    animationLabel.textColor = ORANGECOLOR;
    animationLabel.font      = [UIFont fontWithName:FONT size:16];
    
    
    
  
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格: %@元",money]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:14] range:NSMakeRange(0,6)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:20] range:NSMakeRange(6,money.length)];
    
    _payMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Adaptive(20), viewWidth, Adaptive(20))];
    _payMoneyLabel.attributedText = str;
    _payMoneyLabel.textAlignment  = 1;
    _payMoneyLabel.textColor      = ORANGECOLOR;
    [self addSubview:_payMoneyLabel];
    
    
    classTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               CGRectGetMaxY(_payMoneyLabel.frame) + Adaptive(10),
                                                               viewWidth,
                                                               Adaptive(20))];
    classTimeLabel.textAlignment = 1;
    classTimeLabel.textColor     = [UIColor lightGrayColor];
    classTimeLabel.font          = [UIFont fontWithName:FONT size:12];
     classTimeLabel.text         = [NSString stringWithFormat:@"课程总时长%@分钟",classtime];
    [self addSubview:classTimeLabel];
    
    /**
     *  是否使用优惠劵
     *
     */
    
   
    
    
    UILabel *line = (UILabel *)[self viewWithTag:10];
    _youhuiMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(line.frame) + Adaptive(15),
                                                                  viewWidth,
                                                                  Adaptive(20))];
    _youhuiMoneyLabel.textAlignment = 1;
    _youhuiMoneyLabel.font          = [UIFont fontWithName:FONT size:14];
    
    // 有余额的时候优先显示并使用余额
    if ([ban intValue] != 0) {
        _youhuiMoneyLabel.text = [NSString stringWithFormat:@"您有%@元的余额可以使用，是否使用?",ban];
    } else {
        _youhuiMoneyLabel.text = [NSString stringWithFormat:@"您有%@元的优惠券可以使用，是否使用?",juan];
    }

    [self addSubview:_youhuiMoneyLabel];
    
    if ([juan isEqualToString:@"0"] && [ban isEqualToString:@"0"]) {
        make = [[makeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_youhuiMoneyLabel.frame) + Adaptive(15), viewWidth, Adaptive(20))];
        [self addSubview:make];
        
        UIImageView *imageViewLeft  = (UIImageView *)[make viewWithTag:3];
        UIImageView *imageViewRight = (UIImageView *)[make viewWithTag:6];
        UILabel *labelRight         = (UILabel *)[make viewWithTag:10];
        UILabel *labelLeft          = (UILabel *)[make viewWithTag:5];
        imageViewLeft.image  = [UIImage imageNamed:@"pay_duihao"];
        imageViewRight.image = [UIImage imageNamed:@"pay_duihao_red"];
        labelLeft.textColor  = [UIColor lightGrayColor];
        labelRight.textColor = [UIColor lightGrayColor];
        make.userInteractionEnabled = NO;
        
    } else {
        make = [[makeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_youhuiMoneyLabel.frame) + Adaptive(15), viewWidth, Adaptive(20))];
        [self addSubview:make];
    }
   
    
    /**
     *  支付方式
     */
    
    UILabel *lineTwo = (UILabel *)[self viewWithTag:20];
    
    //微信支付
    UIImageView *weixinImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth / 6, CGRectGetMaxY(lineTwo.frame) + Adaptive(8), Adaptive(47), Adaptive(61))];
    weixinImage.userInteractionEnabled = YES;
    weixinImage.image = [UIImage imageNamed:@"pay_wx"];
    [self addSubview:weixinImage];
    
    UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    wxBtn.frame = CGRectMake(0, 0, weixinImage.bounds.size.width, weixinImage.bounds.size.height);
    wxBtn.tag = 10;
    [wxBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    [weixinImage addSubview:wxBtn];
    
    //银联支付
    UIImageView *ylImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(weixinImage.frame) + viewWidth / 10, CGRectGetMaxY(lineTwo.frame) + Adaptive(10), Adaptive(58), Adaptive(59))];
    ylImage.userInteractionEnabled = YES;
    ylImage.image = [UIImage imageNamed:@"pay_yl"];
    [self addSubview:ylImage];
    
    UIButton *ylBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    ylBtn.tag = 20;
    ylBtn.frame = CGRectMake(0, 0, ylImage.bounds.size.width, ylImage.bounds.size.height);
    [ylBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    [ylImage addSubview:ylBtn];
    
    //支付宝支付
    UIImageView *zfbImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(ylImage.frame) + viewWidth / 10, CGRectGetMaxY(lineTwo.frame) + Adaptive(17), Adaptive(80), Adaptive(52))];
    zfbImage.userInteractionEnabled = YES;
    zfbImage.image = [UIImage imageNamed:@"pay_zfb"];
    [self addSubview:zfbImage];
    
    UIButton *zfbBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    zfbBtn.tag = 30;
    zfbBtn.frame = CGRectMake(0, 0, zfbImage.bounds.size.width, zfbImage.bounds.size.height);
    [zfbBtn addTarget:self action:@selector(payClick:) forControlEvents:UIControlEventTouchUpInside];
    [zfbImage addSubview:zfbBtn];
}

- (void)payClick:(UIButton *)button {
    
   // 区分是否使用优惠劵
    
    
    kUrl = [NSString stringWithFormat:@"%@charge/", BASEURL];
    
    switch (button.tag) {
        case 10:
            NSLog(@"点击了微信支付");
            requestdict = @{@"gd_money":_ishaveQuan,
                            @"channel" : @"wx",
                            @"types"   : _classTypes,
                            @"order_no" : _order_id,
                            @"package_id":_package_id,
                            @"is_use_balance": _ishaveBalance,
                            };
            break;
        case 20:
            NSLog(@"点击了银联支付");
            requestdict = @{@"gd_money":_ishaveQuan,
                            @"channel" : @"upacp",
                            @"types"   : _classTypes,
                            @"order_no" : _order_id,
                            @"package_id":_package_id,
                            @"is_use_balance": _ishaveBalance,
                            };
            break;
        case 30:
            NSLog(@"点击了支付宝支付");
            requestdict = @{@"gd_money":_ishaveQuan,
                            @"channel" : @"alipay",
                            @"types"   : _classTypes,
                            @"order_no" : _order_id,
                            @"package_id":_package_id,
                            @"is_use_banlace": _ishaveBalance,
                            };
            break;
            
        default:
            break;
    }

    
    
    
    if ([_ishaveBalance isEqualToString:@"1"]) {
        // 使用余额订课
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您将使用余额订课,请确认" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag = 98;
        [alert show];
        
    } else {
        // 正常支付
        [self payWithDict:requestdict];
    }
    
    
    
  }

- (void)payWithDict:(NSDictionary *)dict {
    [HttpTool postWithUrl:kUrl params:requestdict body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        NSData* data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if ([[dict allKeys] containsObject:@"status"] && [[dict objectForKey:@"status"] isEqualToString:@"free"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您已成功使用余额订课,请前往订单查看" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
            alert.tag = 100;
            [alert show];
        } else {
            [Pingpp createPayment:dict
                   viewController:payViewController
                     appURLScheme:kUrlScheme
                   withCompletion:^(NSString *result, PingppError *error) {
                       NSLog(@"completion block: %@", result);
                       if ([result isEqualToString:@"success"]) {
                           // 支付成功
                           NSLog(@"成功");
                           
                           NSNotification *notification = [[NSNotification alloc] initWithName:@"pushOrderView" object:nil userInfo:nil];
                           [[NSNotificationCenter defaultCenter] postNotification:notification];
                       } else {
                           // 支付失败或取消
                           NSLog(@"Error: code=%lu msg=%@", (unsigned long)error.code, [error getMsg]);
                       }
                   }];
        }
    }];
}

@end
