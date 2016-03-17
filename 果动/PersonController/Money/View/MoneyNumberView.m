//
//  MoneyNumberView.m
//  果动
//
//  Created by mac on 16/3/2.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MoneyNumberView.h"
#import "HQGZViewController.h"

@interface MoneyNumberView ()

@property (nonatomic,retain) UILabel     *numberLabel;
@property (nonatomic,retain) UILabel     *addNumberLabel;
@property (nonatomic,retain) UIButton    *questionBtn;
@property (nonatomic,retain) UIButton    *exchangeBtn;
@property (nonatomic,retain) UIViewController *viewController;
@property (nonatomic,retain) SHTextField *textField;


@end


@implementation MoneyNumberView
{
    BOOL        isExchange;
    NSInteger   addNumber;
}

- (id)initWithFrame:(CGRect)frame viewController:(UIViewController *)controller {
    
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    
    if (self) {
        _viewController = controller;
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"money" object:nil];
    }
    
    return self;
    
}
- (void)tongzhi:(NSNotification *)notification {
    _number = [[notification.userInfo objectForKey:@"money"] integerValue];
    _numberLabel.text  = [NSString stringWithFormat:@"￥%ld",(long)_number];
    
}
-(void)createUI
{
    self.backgroundColor  = [UIColor colorWithRed:127 / 255.0 green:127 / 255.0 blue:127 / 255.0 alpha:1];
    
    // number                = 2345;
    addNumber             = 78;
    
    _numberLabel          = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                      self.bounds.size.height / 4,
                                                                      viewWidth,
                                                                      Adaptive(30))];
    _numberLabel.font          = [UIFont fontWithName:FONT size:Adaptive(50)];
    _numberLabel.textAlignment = 1;
    
    _numberLabel.textColor     = [UIColor orangeColor];
    [self addSubview:_numberLabel];
    
    
    _addNumberLabel           = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth / 2 + Adaptive(45),
                                                                          self.bounds.size.height / 4 - Adaptive(45),
                                                                          Adaptive(45),
                                                                          Adaptive(45))];
    _addNumberLabel.textColor = [UIColor orangeColor];
    _addNumberLabel.font      = [UIFont fontWithName:FONT size:18];
    _addNumberLabel.text      = [NSString stringWithFormat:@"+%ld",(long)addNumber];
    
    
    _exchangeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _exchangeBtn.frame = CGRectMake((self.bounds.size.width - Adaptive(35)) / 2, CGRectGetMaxY(_numberLabel.frame) + Adaptive(40), Adaptive(35), Adaptive(35));
    
    [_exchangeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_exchangeBtn setBackgroundImage:[UIImage imageNamed:@"Money_exchange"] forState:UIControlStateNormal];
    [self addSubview:_exchangeBtn];
    
    
    _textField = [[SHTextField alloc] initWithFrame:CGRectMake(viewWidth / 4,
                                                               CGRectGetMaxY(_numberLabel.frame) + Adaptive(40),
                                                               viewWidth / 2,
                                                               Adaptive(35))
                                        placeholder:@"请输入兑换码"];
    
    _textField.background    = [UIImage imageNamed:@"Money_textField"];
    _textField.textAlignment = 1;
    _textField.alpha         = 0.f;
    _textField.keyboardType  = UIKeyboardTypeDefault;
    
    _questionBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _questionBtn.frame = CGRectMake(viewWidth - Adaptive(30),
                                    self.bounds.size.height - Adaptive(30),
                                    Adaptive(25),
                                    Adaptive(25));
    [_questionBtn addTarget:self action:@selector(hqgzButton) forControlEvents:UIControlEventTouchUpInside];
    [_questionBtn setBackgroundImage:[UIImage imageNamed:@"Money_question"] forState:UIControlStateNormal];
    [self addSubview:_questionBtn];
    
}

- (void)buttonClick:(UIButton *)button {
    
    if (!isExchange) {
        
        
        // 位移动画
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
        animation.fromValue         = @(button.layer.position.x); // 起始帧
        animation.toValue           = @(viewWidth * .82); // 终了帧
        animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.duration          = .4f;
        button.layer.position       = CGPointMake(viewWidth * .82,button.layer.position.y);

        [button.layer addAnimation:animation forKey:@"move-rotate-layer"];
        [_textField becomeFirstResponder];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:.5f];
        
    } else {
        
        [_textField resignFirstResponder];
        NSString *exchangeUrl      = [NSString stringWithFormat:@"%@api/?method=gdmoney.exchange",BASEURL];
        NSDictionary *exchangeDict = @{@"code":_textField.text};
        [HttpTool postWithUrl:exchangeUrl params:exchangeDict contentType:CONTENTTYPE success:^(id responseObject) {
            if (ResponseObject_RC == 0 ) {
                
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"nickname"] isKindOfClass:[NSNull class]]) {
                    addNumber                 = [[[responseObject objectForKey:@"data"] objectForKey:@"number"] integerValue];
                    _addNumberLabel.text      = [NSString stringWithFormat:@"+%ld",(long)addNumber];
                    _numberLabel.text         = [NSString stringWithFormat:@"￥%ld",_number + addNumber];
                    NSLog(@"addNumber  %ld",(long)addNumber);
                    [self addSubview:_addNumberLabel];
                    
                   
                    // 数字增加动画
                    [UIView animateWithDuration:1.5f animations:^{
                        CGRect newFrame    = _addNumberLabel.frame;
                        newFrame.origin.x += 50;
                        newFrame.origin.y -= 50;
                        _addNumberLabel.frame = newFrame;
                        _addNumberLabel.alpha = 0.f;
                    }];
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    
                    [alert show];
                }
                NSNotification *notification = [NSNotification notificationWithName:@"refushTableView"
                                                                             object:nil
                                                                           userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                [UIView animateWithDuration:.1f animations:^{
                    _textField.alpha = 0.f;
                    
                } completion:^(BOOL finished) {
                    [_textField removeFromSuperview];
                    [self delayMethodBack];
                }];
            } else {
                [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
        } fail:^(NSError *error) {}];
    }
}

- (void)delayMethod {
    
    [self addSubview:_textField];
    [UIView animateWithDuration:.1f animations:^{
        
        _textField.alpha = 1.f;
    }];
    isExchange = !isExchange;
}

- (void)delayMethodBack {
    // 位移动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.fromValue         = @(_exchangeBtn.layer.position.x); // 起始帧
    animation.toValue           = @(self.bounds.size.width / 2); // 终了帧
    animation.timingFunction    = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.duration          = .4f;
    _exchangeBtn.layer.position = CGPointMake(self.bounds.size.width / 2, _exchangeBtn.layer.position.y);
    // 添加动画
    [_exchangeBtn.layer addAnimation:animation forKey:@"move-rotate-layer"];
    
    isExchange = !isExchange;
}

- (void)hqgzButton
{
    HQGZViewController* hqgz = [HQGZViewController new];
    [_viewController.navigationController pushViewController:hqgz animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [_textField resignFirstResponder];
}

@end
