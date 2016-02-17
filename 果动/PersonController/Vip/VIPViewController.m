//
//  VIPViewController.m
//  果动
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "Commonality.h"
#import "LoginViewController.h"
#import "VIPViewController.h"
@interface VIPViewController () <UITextFieldDelegate, UIAlertViewDelegate> {
    UITextField* _textUserName;
    UITextField* _password;
    UIImageView* roundImageView;
    UIButton* loginButton;
}
@end

@implementation VIPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"VIP"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"个人" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    UIImageView* baseImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"vip_baseImage"]];
    baseImageView.frame = CGRectMake(0, 0, viewWidth, viewHeight - NavigationBar_Height);
    baseImageView.userInteractionEnabled = YES;
    [self.view addSubview:baseImageView];

    NSArray* array = @[ @"温馨提示:", @"参加果动活动就有机会获得VIP卡;", @"活动内容及相关信息请关注“果动app”;", @"最终解释权归果动所有!" ];
    for (int a = 0; a < 4; a++) {
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(13), (viewHeight - Adaptive(100) * 2) + a * Adaptive(25), viewWidth - viewWidth / 4, Adaptive(25))];
        label.text = array[a];
        label.textColor = [UIColor colorWithRed:228.00 / 255 green:221.00 / 255 blue:216.00 / 255 alpha:1];
        label.font = [UIFont fontWithName:FONT size:Adaptive(16)];
        [self.view addSubview:label];
    }

    _textUserName = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(241)) / 2, viewHeight / 3, Adaptive(241), Adaptive(42))];
    _textUserName.borderStyle = UITextBorderStyleNone;
    _textUserName.placeholder = @"请输入您的VIP卡号";
    _textUserName.textAlignment = 1;
    _textUserName.keyboardType = UIKeyboardTypePhonePad;
    _textUserName.background = [UIImage imageNamed:@"yindao_textnumber"];
    _textUserName.delegate = self;
    _textUserName.backgroundColor = [UIColor clearColor];
    _textUserName.textColor = [UIColor whiteColor];
    _textUserName.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [_textUserName setValue:[UIColor colorWithRed:152.00 / 255 green:141.00 / 255 blue:112.00 / 255 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_textUserName setValue:[UIFont boldSystemFontOfSize:Adaptive(16)] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_textUserName];

    _password = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(241)) / 2, CGRectGetMaxY(_textUserName.frame) + Adaptive(10), Adaptive(241), Adaptive(42))];
    _password.borderStyle = UITextBorderStyleNone;
    _password.placeholder = @"请输入您的验证码";
    _password.textAlignment = 1;
    _password.background = [UIImage imageNamed:@"yindao_textnumber"];
    _password.delegate = self;
    _password.secureTextEntry = YES;
    _password.backgroundColor = [UIColor clearColor];
    _password.keyboardType = UIKeyboardTypePhonePad;
    _password.textColor = [UIColor colorWithRed:152.00 / 255 green:141.00 / 255 blue:112.00 / 255 alpha:1];
    _password.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [_password setValue:[UIColor colorWithRed:152.00 / 255 green:141.00 / 255 blue:112.00 / 255 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
    [_password setValue:[UIFont boldSystemFontOfSize:Adaptive(16)] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:_password];

    loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginButton.frame = CGRectMake((viewWidth - Adaptive(241)) / 2, CGRectGetMaxY(_password.frame) + Adaptive(10), Adaptive(241),Adaptive(35));
    [loginButton setTintColor:[UIColor whiteColor]];
    [loginButton setTitle:@"验证" forState:UIControlStateNormal]; //@"Arial-BoldMT"
    loginButton.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(15)];
    [loginButton setBackgroundImage:[UIImage imageNamed:@"vip_yanzheng"] forState:UIControlStateNormal];
    [loginButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];

    roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(loginButton.bounds.size.width / 4, (loginButton.bounds.size.height - Adaptive(18)) / 2,Adaptive(18), Adaptive(18))];
    roundImageView.image = [UIImage imageNamed:@"login_round"];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
- (void)buttonClick:(UIButton*)button
{
    //GD0000200   601824
    [self.view endEditing:YES];

    if (_textUserName.text.length == 0 || _password.text.length == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"所有项都是必填项" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];

        [alert show];
        return;
    }

    [loginButton setTitle:@"正在验证" forState:UIControlStateNormal];
    [loginButton addSubview:roundImageView];
    CABasicAnimation* basic2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basic2.fromValue = [NSNumber numberWithFloat:0];
    basic2.byValue = [NSNumber numberWithFloat:M_PI * 2];
    basic2.repeatCount = 10000;
    basic2.duration = 2;
    [roundImageView.layer addAnimation:basic2 forKey:@"basic1"];
    NSString* url = [NSString stringWithFormat:@"%@api/?method=user.verifyVip&number=%@&pwd=%@", BASEURL, _textUserName.text, _password.text];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            [roundImageView.layer removeAllAnimations];
            [roundImageView removeFromSuperview];

            [loginButton setTitle:@"验证成功" forState:UIControlStateNormal];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else if (ResponseObject_RC == NotLogin_RC_Number) {
            [HeadComment message:@"您还没有登录呢！" delegate:self witchCancelButtonTitle:@"暂不" otherButtonTitles:@"去登录", nil];
        }
        else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
        fail:^(NSError* error){
        }];
}
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 77) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        }
    }
}
@end
