//
//  LoginViewController.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "APService.h"
#import "Commonality.h"
#import "HomeController.h"
#import "HttpTool.h"
#import "LoginViewController.h"
#import "MainController.h"
#import "NSString+JW.h"
#import "PersonalCenterController.h"
@interface LoginViewController () <UITextFieldDelegate> {
    UIImageView* _userNameImage;
    UIImageView* _passwordImage;
    UIImageView* _lineImage1;
    UIImageView* _lineImage2;
    UITextField* _textUserName;
    UITextField* _textPassword;
    NSMutableArray* _areaArray;
    NSTimer* _timer1;
    NSTimer* _timer2;
    NSString* strr;
    NSString* sign;
    UIButton* yanzhengmaBtn;
    UIButton* loginBtn;
    int test;
    dispatch_source_t _timer;
    NSMutableArray* messageArray;
    UIImageView* roundImageView;
}
@property (nonatomic, strong) UITextField* areaCodeField;
@property (nonatomic, strong) UILabel* timeLabel;
@end
@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;

    messageArray = [[NSMutableArray alloc] initWithCapacity:0];

    self.navigationItem.titleView = [HeadComment titleLabeltext:@"登录"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"设置" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    [self onCreate];
}
#pragma mark 初始化背景图、按钮控件与名字
- (void)onCreate
{
    UIImageView* image1line = [UIImageView new];
    image1line.image = [UIImage imageNamed:@"home__line1"];
    image1line.frame = CGRectMake(0, 0, viewWidth, 1);
    [self.view addSubview:image1line];

    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    imageView.image = [UIImage imageNamed:@"yindaoye_4"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];

    UIImageView* userimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yindao_textnumber"]];
    userimg.frame = CGRectMake((viewWidth - viewWidth / 1.2) / 2, Adaptive(400), viewWidth / 1.2, Adaptive(40));
    userimg.userInteractionEnabled = YES;
    [imageView addSubview:userimg];
    //152  141  112
    NSLog(@"ad400 %f",Adaptive(400));
    _textUserName = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth - viewWidth / 1.2) / 2 + Adaptive(15), Adaptive(400), viewWidth / 1.2 - Adaptive(15), Adaptive(40))];
    _textUserName.borderStyle = UITextBorderStyleNone;
    _textUserName.placeholder = @"请输入您的手机号码";
    _textUserName.delegate = self;
    _textUserName.backgroundColor = [UIColor clearColor];
    _textUserName.keyboardType = UIKeyboardTypeNumberPad;
    _textUserName.textColor = [UIColor lightGrayColor];
    _textUserName.font = [UIFont fontWithName:FONT size:Adaptive(14)];
    [_textUserName setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_textUserName setValue:[UIFont fontWithName:FONT size:Adaptive(14)] forKeyPath:@"_placeholderLabel.font"];
    [imageView addSubview:_textUserName];

    UIImageView* passimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yindao_yan.jpg"]];
    passimg.frame = CGRectMake((viewWidth - viewWidth / 1.2) / 2, CGRectGetMaxY(userimg.frame) + Adaptive(10), viewWidth / 2.5, Adaptive(40));
    passimg.userInteractionEnabled = YES;
    [imageView addSubview:passimg];

     _textPassword = [[UITextField alloc] initWithFrame:CGRectMake((viewWidth - viewWidth / 1.2) / 2 + Adaptive(10), CGRectGetMaxY(userimg.frame) + Adaptive(10), viewWidth / 2.5 - 10, Adaptive(40))];
    _textPassword.borderStyle = UITextBorderStyleRoundedRect;
    _textPassword.placeholder = @"请输入验证码";
    _textPassword.textColor = [UIColor lightGrayColor];
    _textPassword.backgroundColor = [UIColor clearColor];
    _textPassword.keyboardType = UIKeyboardTypeNumberPad;
    _textPassword.font = [UIFont fontWithName:FONT size:Adaptive(14)];

    [_textPassword setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_textPassword setValue:[UIFont fontWithName:FONT size:Adaptive(14)] forKeyPath:@"_placeholderLabel.font"];

    [imageView addSubview:_textPassword];

    UIImageView* yanimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yindao_yan.jpg"]];
    yanimg.frame = CGRectMake(CGRectGetMaxX(passimg.frame) + Adaptive(10), CGRectGetMaxY(userimg.frame) + Adaptive(10), viewWidth / 2.5, Adaptive(38));
    [imageView addSubview:yanimg];

    _timeLabel = [[UILabel alloc] init];
    _timeLabel.frame = yanimg.frame;
    _timeLabel.textAlignment = 1;

    _timeLabel.text = @"获取验证码";
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(14)];
    [imageView addSubview:_timeLabel];

    yanzhengmaBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [yanzhengmaBtn addTarget:self action:@selector(yanzhengqingqiu) forControlEvents:UIControlEventTouchUpInside];

    yanzhengmaBtn.frame = yanimg.frame;
    [imageView addSubview:yanzhengmaBtn];

    //登陆
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"yindao_login"] forState:UIControlStateNormal];
    loginBtn.frame = CGRectMake((viewWidth - viewWidth / 1.2) / 2, CGRectGetMaxY(passimg.frame) + Adaptive(10), viewWidth / 1.2, Adaptive(40));
    [loginBtn setTintColor:[UIColor whiteColor]];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal]; //@"Arial-BoldMT"
    loginBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(15)];
    [loginBtn addTarget:self action:@selector(selecloginBtn) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:loginBtn];
    
    roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(80), Adaptive(11), Adaptive(18), Adaptive(18))];
    roundImageView.image = [UIImage imageNamed:@"login_round"];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
//表随键盘高度变化
- (void)keyboardShow:(NSNotification*)note
{
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;

    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{

        self.view.transform = CGAffineTransformMakeTranslation(0, -deltaY);

    }];
}
- (void)keyboardHide:(NSNotification*)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;

    }];
}

#pragma mark 触摸屏幕回收键盘
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}

- (void)selecloginBtn
{
    //13810660831
    int compareResult = 0;
    for (int i = 0; i < _areaArray.count; i++) {
        NSDictionary* dict1 = [_areaArray objectAtIndex:i];
        NSString* code1 = [dict1 valueForKey:@"zone"];
        if ([code1 isEqualToString:[_areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""]]) {
            compareResult = 1;
            NSString* rule1 = [dict1 valueForKey:@"rule"];
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule1];
            BOOL isMatch = [pred evaluateWithObject:_textUserName.text];
            if (!isMatch) {
                //手机号码不正确
                [HeadComment message:@"电话号码不正确" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                return;
            }
            break;
        }
    }

    if (!compareResult) {
        if (_textUserName.text.length != 11) {
            //手机号码不正确
            [HeadComment message:@"请输入正确的手机号码！" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            return;
        }
    }
    if ([_textPassword.text isEmptyString] || [_textUserName.text isEmptyString]) {
        [HeadComment message:@"内容填写不完整！" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }
    [loginBtn setTitle:@"正在登录" forState:UIControlStateNormal];
    [loginBtn addSubview:roundImageView];
    CABasicAnimation* basic2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basic2.fromValue = [NSNumber numberWithFloat:0];
    basic2.byValue = [NSNumber numberWithFloat:M_PI * 2];
    basic2.repeatCount = 10000;
    basic2.duration = 2;
    [roundImageView.layer addAnimation:basic2 forKey:@"basic1"];

    //登陆
    NSDictionary* dict = @{ @"number" : _textUserName.text,
        @"code" : _textPassword.text,
        @"registerID" : [APService registrationID] };

    NSLog(@"RegistrationID  %@", [APService registrationID]);

    NSString* loginurl = [NSString stringWithFormat:@"%@userlogin/", BASEURL];
    [HttpTool postWithUrl:loginurl params:dict contentType:@"application/json" success:^(id responseObject) {

        if (ResponseObject_RC == 0) {

            if (![_textPassword.text isEqual:@"1234"])
                dispatch_source_cancel(_timer);

            [roundImageView.layer removeAllAnimations];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else {
            [roundImageView.layer removeAllAnimations];
            [roundImageView removeFromSuperview];
            [loginBtn setTitle:@"登录失败" forState:UIControlStateNormal];
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:self witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
        fail:^(NSError* error){
        }];
}

- (void)yanzhengqingqiu
{
    [_textPassword becomeFirstResponder];
    int compareResult = 0;
    for (int i = 0; i < _areaArray.count; i++) {
        NSDictionary* dict1 = [_areaArray objectAtIndex:i];
        NSString* code1 = [dict1 valueForKey:@"zone"];
        if ([code1 isEqualToString:[_areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""]]) {
            compareResult = 1;
            NSString* rule1 = [dict1 valueForKey:@"rule"];
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule1];
            BOOL isMatch = [pred evaluateWithObject:_textUserName.text];
            if (!isMatch) {
                //手机号码不正确
                [HeadComment message:@"电话号码不正确" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                return;
            }
            break;
        }
    }

    if (!compareResult) {
        if (_textUserName.text.length != 11) {
            //手机号码不正确
            [HeadComment message:@"请输入正确的手机号码！" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            return;
        }
    }
    if ([_textUserName.text isEmptyString]) {
        [HeadComment message:@"内容填写不完整！" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }
    //13286832951
    __block int timeout = 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if (timeout <= 0) { //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                yanzhengmaBtn.userInteractionEnabled = YES;
                _timeLabel.text = @"获取验证码";
            });
        }
        else {
            //  int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString* strTime = [NSString stringWithFormat:@"%.2dS", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([strTime intValue] == 00) {
                    _timeLabel.text = @"60S";
                }
                else {
                    _timeLabel.text = strTime;
                }

                yanzhengmaBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    //获取token
    NSString* getTokenUrl = [NSString stringWithFormat:@"%@token/?number=%@", BASEURL, _textUserName.text];
    [HttpTool postWithUrl:getTokenUrl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        /*
         请求参数：number=18618265727&timestamp=12456&sign=e1a4b2dd5816ff40d125f836669652eb
         app_kye = guodongapps
         number 电话号码， timestamp： 时间戳  sign：签名
         
         将 number timestamp sign 参数值排序好 加上 app_key 得到 src_str
         
         签名= md5(src_str)
         */
        //app_kye
        // NSString *app_kye = @"guodongapps";
        //用户手机号
        NSString* numberSTr = _textUserName.text;
        //当前时间
        NSDate* datenow = [NSDate date];
        //算当前时间到1970有多少秒
        NSString* timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        //时间放到数组里

        if ([[responseObject allKeys] containsObject:@"token"]) {
            NSString* token = [responseObject objectForKey:@"token"];
            [messageArray addObject:token];
        }
        [messageArray addObject:numberSTr];
        [messageArray addObject:timeSp];
        //数组排序

        NSMutableArray* sortedArray = [[messageArray sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        for (int i = 0; i < [sortedArray count]; i++) {
            NSString* string = [sortedArray objectAtIndex:i];
            strr = [NSString stringWithFormat:@"%@%@", strr, string];
        }

        NSString* abc = [NSString stringWithFormat:@"%@%@", strr, @"guodongapps"];
        sign = [abc substringFromIndex:6];
        NSLog(@"签名 %@", sign);
        NSString* sign1 = [sign md5:sign];
        NSString* getMessageUrl = [NSString stringWithFormat:@"%@sendcode/", BASEURL];
        NSDictionary* messagedict = @{ @"number" : _textUserName.text,
            @"sign" : sign1,
            @"time" : timeSp };
        [HttpTool postWithUrl:getMessageUrl params:messagedict contentType:CONTENTTYPE success:^(id responseObject) {
            if (ResponseObject_RC == 0) {
                [sortedArray removeAllObjects];
                [messageArray removeAllObjects];
                strr = @"(null)";
            }
            else {
                [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
        }
            fail:^(NSError* error){
            }];
    }
        fail:^(NSError* error){
        }];
    dispatch_resume(_timer);
}
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    }
}
@end
