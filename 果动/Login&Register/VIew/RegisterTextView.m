//
//  RegisterTextView.m
//  GuoDong
//
//  Created by mac on 16/2/2.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "RegisterTextView.h"
#import "YXEasing.h"
#import "Commonality.h"
#import "APService.h"
#import "HomeController.h"
#import "HttpTool.h"
#import "MainController.h"
#import "NSString+JW.h"

#import "PersonalCenterController.h"
#import "UIImage+JW.h"
#import "TranformFadeView.h"

@implementation RegisterTextView   {
    UITextField       *_userNameTextField;
    UITextField       *_passWordTextField;
    UILabel           *_timeLabel;
    NSString          *_sign;
    NSString          *_strr;
    UIButton          *_yanzhengBtn;
    UIButton          *_loginBtn;
    UIImageView       *_roundImageView;
    NSMutableArray    *_areaArray;
    NSMutableArray    *_messageArray;
    dispatch_source_t  _timer;
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor        = BASECOLOR;
        self.userInteractionEnabled = YES;
        // JustNow 动画调用
        [self JustNowAnimationStart];
        
        // 初始化输入框及缓慢显示动画
        [self initTextFieldAndAnimation];
     
        
           [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];

        
    }
    return self;
}

// JustNow 动画调用
- (void)JustNowAnimationStart {
    UIImageView *fourImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    fourImageView.image        = [UIImage imageNamed:@"yindaoye_4"];
    [self addSubview:fourImageView];
    
    
    
    UIImageView *logoImage1 = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(94)) / 2, Adaptive(190), Adaptive(94), Adaptive(50))];
    logoImage1.image        = [UIImage imageNamed:@"logo1"];
    logoImage1.alpha        = 0;
    [self addSubview:logoImage1];
    
    
    // "JUST NOW" 跳出动画
    CGFloat logo_two_x      = (viewWidth - Adaptive(80)) / 2;
    CGFloat logo_two_width  = Adaptive(90);
    
    
    UIImageView *logoImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(logo_two_x, -Adaptive(10), logo_two_width, Adaptive(10))];
    logoImage2.image        = [UIImage imageNamed:@"logo2"];
    [self addSubview:logoImage2];
    
    
    // 创建关键帧动画（移动距离的动画）
    CAKeyframeAnimation *keyFrameAnimation_two = [CAKeyframeAnimation animation];
    keyFrameAnimation_two.keyPath              = @"position";
    keyFrameAnimation_two.duration             = 1.5;
    keyFrameAnimation_two.values               = \
    [YXEasing calculateFrameFromPoint:logoImage2.center
                              toPoint:CGPointMake(logo_two_x + logo_two_width / 2, Adaptive(180))
                                 func:BounceEaseOut
                           frameCount:1.5 * 30];
    // 添加动画
    logoImage2.center = CGPointMake(logo_two_x + logo_two_width / 2, Adaptive(180));
    [logoImage2.layer addAnimation:keyFrameAnimation_two forKey:nil];
    
    // "果动" 在一秒内显示动画
    [UIView animateWithDuration:3.f animations:^{
        
        logoImage1.alpha    = 1.f;
    }];

    
}

// 初始化输入框及缓慢显示动画
- (void)initTextFieldAndAnimation {
    
    /*** textField直接设置背景图片内容和placeholder会超出图片 所以设置imageView ***/
    // 用户名背景图片
    UIImageView* userimg           = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yindao_textnumber"]];
    userimg.frame                  = CGRectMake((viewWidth - viewWidth / 1.2) / 2,
                                                Adaptive(455.5),
                                                viewWidth / 1.2,
                                                Adaptive(40));
    userimg.alpha                  = 0;
    userimg.userInteractionEnabled = YES;
    [self addSubview:userimg];

    // 用户名输入框
    _userNameTextField                  = \
    [[SHTextField alloc] initWithFrame:CGRectMake((viewWidth - viewWidth / 1.2) / 2 + Adaptive(15),
                                                  Adaptive(455.5),
                                                  viewWidth / 1.2 - Adaptive(15),
                                                  Adaptive(40))
                                       placeholder:@"请输入您的手机号码"];
    _userNameTextField.delegate         = self;
    _userNameTextField.alpha            = 0;
    [self addSubview:_userNameTextField];
    
    
    // 密码背景图片
    UIImageView* passimg           = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yindao_yan.jpg"]];
    passimg.frame                  = CGRectMake((viewWidth - viewWidth / 1.2) / 2,
                                                CGRectGetMaxY(userimg.frame) + Adaptive(10),
                                                viewWidth / 2.5,
                                                Adaptive(40));
    passimg.alpha                  = 0;
    passimg.userInteractionEnabled = YES;
    [self addSubview:passimg];
    
    
    // 密码输入框
    _passWordTextField                 = \
    [[SHTextField alloc] initWithFrame:CGRectMake((viewWidth - viewWidth / 1.2) / 2 + Adaptive(10),
                                                  CGRectGetMaxY(userimg.frame) + Adaptive(10),
                                                  viewWidth / 2.5 - 10,
                                                  Adaptive(40))
                                    placeholder:@"请输入您的验证码"];
    _passWordTextField.alpha           = 0;
    [self addSubview:_passWordTextField];
    
    // 获取验证码背景图片
    UIImageView* yanimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yindao_yan.jpg"]];
    yanimg.frame        = CGRectMake(CGRectGetMaxX(passimg.frame) + Adaptive(10),
                                     CGRectGetMaxY(userimg.frame) + Adaptive(10),
                                     viewWidth / 2.5,
                                     Adaptive(38));
    yanimg.alpha        = 0;
    [self addSubview:yanimg];
    
    // 验证码Label
    _timeLabel               = [[UILabel alloc] init];
    _timeLabel.frame         = yanimg.frame;
    _timeLabel.textAlignment = 1;
    _timeLabel.alpha         = 0;
    _timeLabel.text          = @"获取验证码";
    _timeLabel.textColor     = [UIColor whiteColor];
    _timeLabel.font          = [UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(14)];
    [self addSubview:_timeLabel];
    
    // 获取验证码按钮
    _yanzhengBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_yanzhengBtn addTarget:self action:@selector(yanzhengqingqiu) forControlEvents:UIControlEventTouchUpInside];
    _yanzhengBtn.frame = yanimg.frame;
    [self addSubview:_yanzhengBtn];
    
    //登录按钮
    _loginBtn                 = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"yindao_login"] forState:UIControlStateNormal];
    _loginBtn.frame           = CGRectMake((viewWidth - viewWidth / 1.2) / 2,
                                          CGRectGetMaxY(passimg.frame) + Adaptive(10),
                                          viewWidth / 1.2,
                                          Adaptive(40));
    _loginBtn.alpha           = 0;
    _loginBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(15)];
    [_loginBtn setTintColor:[UIColor whiteColor]];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal]; //@"Arial-BoldMT"
    [_loginBtn addTarget:self action:@selector(selecloginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginBtn];
    
    //正在加载小圆圈
    _roundImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(80),
                                                                          Adaptive(11),
                                                                          Adaptive(18),
                                                                          Adaptive(18))];
    _roundImageView.image = [UIImage imageNamed:@"login_round"];


    
    // 输入框 在一秒内显示动画
    [UIView animateWithDuration:3.f animations:^{
        
       
        _userNameTextField.alpha = 1.f;
        userimg.alpha            = 1.f;
        _passWordTextField.alpha = 1.f;
        passimg.alpha            = 1.f;
        yanimg.alpha             = 1.f;
        _timeLabel.alpha         = 1.f;
        _loginBtn.alpha          = 1.f;
        
        
    }];

    

}

// 获取验证码点击事件
- (void)yanzhengqingqiu
{
    [_passWordTextField becomeFirstResponder];
    int compareResult = 0;
    for (int i = 0; i < _areaArray.count; i++) {
        NSDictionary* dict1 = [_areaArray objectAtIndex:i];
        NSString* code1 = [dict1 valueForKey:@"zone"];
        if ([code1 isEqualToString:[_areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""]]) {
            compareResult = 1;
            NSString* rule1 = [dict1 valueForKey:@"rule"];
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule1];
            BOOL isMatch = [pred evaluateWithObject:_userNameTextField.text];
            if (!isMatch) {
                //手机号码不正确
                [HeadComment message:@"电话号码不正确" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                return;
            }
            break;
        }
    }
    
    if (!compareResult) {
        if (_userNameTextField.text.length != 11) {
            //手机号码不正确
            [HeadComment message:@"请输入正确的手机号码！" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            return;
        }
    }
    if (_userNameTextField.text.length == 0) {
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
            //  dispatch_release(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                _yanzhengBtn.userInteractionEnabled = YES;
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
                _yanzhengBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    //获取token
    NSString* getTokenUrl = [NSString stringWithFormat:@"%@token/?number=%@", BASEURL, _userNameTextField.text];
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
        NSString* numberSTr = _userNameTextField.text;
       
        //当前时间
        NSDate* datenow = [NSDate date];
        //算当前时间到1970有多少秒
        NSString* timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        //时间放到数组里
        _messageArray = [[NSMutableArray alloc] initWithCapacity:0];
        if ([[responseObject allKeys] containsObject:@"token"]) {
            NSString* token = [responseObject objectForKey:@"token"];
            [_messageArray addObject:token];
        }
        [_messageArray addObject:numberSTr];
        [_messageArray addObject:timeSp];
        //数组排序
       
        NSMutableArray* sortedArray = [[_messageArray sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
        
        
        for (int i = 0; i < [sortedArray count]; i++) {
            NSString* string = [sortedArray objectAtIndex:i];
            _strr = [NSString stringWithFormat:@"%@%@", _strr, string];
        }
        //
       
        NSString* abc = [NSString stringWithFormat:@"%@%@", _strr, @"guodongapps"];
        _sign = [abc substringFromIndex:6];
        NSLog(@"签名 %@", _sign);
        NSString* sign1 = [_sign md5:_sign];
        NSString* getMessageUrl = [NSString stringWithFormat:@"%@sendcode/", BASEURL];
        NSDictionary* messagedict = @{ @"number" : _userNameTextField.text,
                                       @"sign" : sign1,
                                       @"time" : timeSp };
        [HttpTool postWithUrl:getMessageUrl params:messagedict contentType:CONTENTTYPE success:^(id responseObject) {
            if (ResponseObject_RC == 0) {
                [sortedArray removeAllObjects];
                [_messageArray removeAllObjects];
                _strr = @"(null)";
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

// 点击登录按钮
- (void)selecloginBtn
{
    //  NSLog(@"test  %d",test);
    int compareResult = 0;
    for (int i = 0; i < _areaArray.count; i++) {
        NSDictionary* dict1 = [_areaArray objectAtIndex:i];
        NSString* code1 = [dict1 valueForKey:@"zone"];
        if ([code1 isEqualToString:[_areaCodeField.text stringByReplacingOccurrencesOfString:@"+" withString:@""]]) {
            compareResult = 1;
            NSString* rule1 = [dict1 valueForKey:@"rule"];
            NSPredicate* pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", rule1];
            BOOL isMatch = [pred evaluateWithObject:_userNameTextField.text];
            if (!isMatch) {
                //手机号码不正确
                [HeadComment message:@"电话号码不正确" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                return;
            }
            break;
        }
    }
    
    if (!compareResult) {
        if (_userNameTextField.text.length != 11) {
            //手机号码不正确
            [HeadComment message:@"请输入正确的手机号码！" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            return;
        }
    }
    if ([_passWordTextField.text isEmptyString] || [_userNameTextField.text isEmptyString]) {
        [HeadComment message:@"内容填写不完整！" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        return;
    }
    [_loginBtn setTitle:@"正在登录" forState:UIControlStateNormal];
    [_loginBtn addSubview:_roundImageView];
    CABasicAnimation* basic2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basic2.fromValue = [NSNumber numberWithFloat:0];
    basic2.byValue = [NSNumber numberWithFloat:M_PI * 2];
    basic2.repeatCount = 10000;
    basic2.duration = 2;
    [_roundImageView.layer addAnimation:basic2 forKey:@"basic1"];
    
    //登陆
    NSDictionary* dict = @{ @"number" : _userNameTextField.text,
                            @"code" : _passWordTextField.text,
                            @"registerID" : [APService registrationID] };
    
    NSLog(@"RegistrationID  %@", [APService registrationID]);
    NSString* loginurl = [NSString stringWithFormat:@"%@userlogin/", BASEURL];
    [HttpTool postWithUrl:loginurl params:dict contentType:CONTENTTYPE success:^(id responseObject) {
        
        if (ResponseObject_RC == 0) {
            
            if (![_passWordTextField.text isEqual:@"1234"]) {
                dispatch_source_cancel(_timer);
            }
            [_roundImageView.layer removeAllAnimations];
            MainController* MainVC = [MainController new];
            self.window.rootViewController = MainVC;
        }
        else {
            [_roundImageView.layer removeAllAnimations];
            [_roundImageView removeFromSuperview];
            [_loginBtn setTitle:@"登录失败" forState:UIControlStateNormal];
            
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:self witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }fail:^(NSError* error){}];
}


// 表随键盘高度变化
- (void)keyboardShow:(NSNotification*)note {
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        
        self.transform = CGAffineTransformMakeTranslation(0, -deltaY);
    }];
}
- (void)keyboardHide:(NSNotification*)note {
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
}
#pragma mark 触摸屏幕回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
