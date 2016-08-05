//
//  LoginViewController.m
//  果动
//
//  Created by mac on 16/5/31.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "LoginViewController.h"
#import "MainViewController.h"
#import "AppDelegate.h"

@interface LoginViewController ()<UITextFieldDelegate>

@end

@implementation LoginViewController
{
    UITextField *_userNameTextField;
    UITextField *_passWordTextField;
    UIImageView *_roundImageView;
    UILabel     *_timeLabel;
    UIButton    *_yanzhengBtn;
    UIButton    *_loginBtn;
    NSMutableArray     *tokenArray;
    dispatch_source_t  _timer;
    
    CGFloat offset;
    CGFloat textHeight;
    NavigationView *navigation;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [navigation removeFromSuperview];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden           = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BASECOLOR;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
  
    navigation = [[NavigationView alloc] initWithtitle:@"登录" viewController:self];
    [app.window addSubview:navigation];
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)createUI {
    
    // 背景图
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight)];
    imageView.image        = [UIImage imageNamed:@"login_base"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    /*** textField直接设置背景图片内容和placeholder会超出图片 所以设置imageView ***/
    // 用户名背景图片
    UIImageView* userimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yindao_textnumber"]];
    userimg.frame        = CGRectMake((viewWidth - viewWidth / 1.2) / 2,
                                      Adaptive(400),
                                      viewWidth / 1.2,
                                      Adaptive(40));
    userimg.userInteractionEnabled = YES;
    [self.view addSubview:userimg];
    
    // 用户名输入框
    _userNameTextField       = [UITextField new];
    _userNameTextField.frame = CGRectMake((viewWidth - viewWidth / 1.2) / 2 + Adaptive(15),
                                          Adaptive(400),
                                          viewWidth / 1.2 - Adaptive(15),
                                          Adaptive(40));
    _userNameTextField.delegate          = self;
    _userNameTextField.backgroundColor   = [UIColor clearColor];
    _userNameTextField.textColor         = [UIColor lightGrayColor];
    _userNameTextField.font              = [UIFont fontWithName:FONT size:Adaptive(14)];
    _userNameTextField.keyboardType      = UIKeyboardTypeNumberPad;
    _userNameTextField.placeholder       = @"请输入您的手机号";
    [_userNameTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_userNameTextField];
    
    
    // 密码背景图片
    UIImageView* passimg           = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yindao_yan.jpg"]];
    passimg.frame                  = CGRectMake((viewWidth - viewWidth / 1.2) / 2,
                                                CGRectGetMaxY(userimg.frame) + Adaptive(10),
                                                viewWidth / 2.5,
                                                Adaptive(40));
    passimg.userInteractionEnabled = YES;
    [self.view addSubview:passimg];
    
    
    // 密码输入框
    _passWordTextField       = [UITextField new];
    _passWordTextField.frame = CGRectMake((viewWidth - viewWidth / 1.2) / 2 + Adaptive(10),
                                          CGRectGetMaxY(userimg.frame) + Adaptive(10),
                                          viewWidth / 2.5 - 10,
                                          Adaptive(40));
    _passWordTextField.delegate          = self;
    _passWordTextField.backgroundColor   = [UIColor clearColor];
    _passWordTextField.textColor         = [UIColor lightGrayColor];
    _passWordTextField.font              = [UIFont fontWithName:FONT size:Adaptive(14)];
    _passWordTextField.keyboardType      = UIKeyboardTypeNumberPad;
    _passWordTextField.placeholder       = @"请输入您的验证码";
    [_passWordTextField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_passWordTextField];
    
    // 获取验证码背景图片
    UIImageView* yanimg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"yindao_yan.jpg"]];
    yanimg.frame        = CGRectMake(CGRectGetMaxX(passimg.frame) + Adaptive(10),
                                     CGRectGetMaxY(userimg.frame) + Adaptive(10),
                                     viewWidth / 2.5,
                                     Adaptive(38));
    [self.view addSubview:yanimg];
    
    // 验证码Label
    _timeLabel               = [[UILabel alloc] init];
    _timeLabel.frame         = yanimg.frame;
    _timeLabel.textAlignment = 1;
    _timeLabel.text          = @"获取验证码";
    _timeLabel.textColor     = [UIColor whiteColor];
    _timeLabel.font          = [UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(14)];
    [self.view addSubview:_timeLabel];
    
    // 获取验证码按钮
    _yanzhengBtn        = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _yanzhengBtn.frame = yanimg.frame;
    [_yanzhengBtn addTarget:self action:@selector(yanzhengqingqiu) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_yanzhengBtn];
    
    //登录按钮
    _loginBtn       = [UIButton buttonWithType:UIButtonTypeCustom];
    _loginBtn.frame = CGRectMake((viewWidth - viewWidth / 1.2) / 2,
                                 CGRectGetMaxY(passimg.frame) + Adaptive(10),
                                 viewWidth / 1.2,
                                 Adaptive(40));
    _loginBtn.titleLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(15)];
    [_loginBtn setBackgroundImage:[UIImage imageNamed:@"yindao_login"] forState:UIControlStateNormal];
    [_loginBtn setTintColor:[UIColor whiteColor]];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal]; //@"Arial-BoldMT"
    [_loginBtn addTarget:self action:@selector(selecloginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    //正在加载小圆圈
    _roundImageView       = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(80),
                                                                          Adaptive(11),
                                                                          Adaptive(18),
                                                                          Adaptive(18))];
    _roundImageView.image = [UIImage imageNamed:@"login_round"];
}

// 获取验证码点击事件
- (void)yanzhengqingqiu {
    
    if (_userNameTextField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"输入的手机号码有误"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        
        [alert show];
    } else {
        
        [_passWordTextField becomeFirstResponder];
        
        /***************倒计时开始********************/
        
        __block int timeout = 60; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if (timeout <= 0) {
                // 倒计时结束，关闭定时器
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 重新开启按钮交互性
                    _yanzhengBtn.userInteractionEnabled = YES;
                    _timeLabel.text = @"获取验证码";
                });
            } else {
                // 倒计时过程中
                int seconds          = timeout % 60; // 秒数对60取余
                NSString *timeString = [NSString stringWithFormat:@"%.2d秒",seconds];
                NSLog(@"timeString %@",timeString);
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([timeString intValue] == 00) {
                        _timeLabel.text = @"60S";
                    } else {
                        _timeLabel.text = timeString;
                    }
                    _yanzhengBtn.userInteractionEnabled = NO;
                });
                timeout--;
            }
        });
        
        /***************网络请求token值*********************/
        
        NSString* getTokenUrl = [NSString stringWithFormat:@"%@token/?number=%@", BASEURL, _userNameTextField.text];
        [HttpTool postWithUrl:getTokenUrl params:nil body:nil progress:^(NSProgress * progress) {
            
        } success:^(id responseObject) {
            
            /*
             请求参数：number=18618265727&timestamp=12456&sign=e1a4b2dd5816ff40d125f836669652eb
             app_kye = guodongapps
             number 电话号码， timestamp： 时间戳  sign：签名
             
             将 number timestamp sign 参数值排序好 加上 app_key 得到 src_str
             
             签名= md5(src_str)
             */
            
            tokenArray            = [NSMutableArray array];
            
            //用户手机号
            NSString* photoNumber = _userNameTextField.text;
            
            //当前时间戳
            NSString* timeString  = [NSString stringWithFormat:@"%ld",
                                     (long)[[NSDate date] timeIntervalSince1970]];
            
            // 将手机号和时间戳放入token数组
            [tokenArray addObject:photoNumber];
            [tokenArray addObject:timeString];
            
            
            // 接收token值
            if ([[responseObject allKeys] containsObject:@"token"]) {
                NSString *token = [responseObject objectForKey:@"token"];
                [tokenArray addObject:token];
            }
            
            // 数组排序
            NSMutableArray *sortedArray = (NSMutableArray *)[tokenArray sortedArrayUsingSelector:@selector(compare:)];
            
            // 遍历数组 将数组元素组成字符串
            NSString *sortedString = @"";
            for (int a = 0; a < [sortedArray count]; a++) {
                NSString *string = [sortedArray objectAtIndex:a];
                sortedString     = [NSString stringWithFormat:@"%@%@",sortedString,string];
            }
            
            NSString *tokenString = [NSString stringWithFormat:@"%@guodongapps",sortedString];
            NSString *MDString    = [tokenString md5:tokenString];
            
            
            /***************网络请求验证码*********************/
            
            NSString* getMessageUrl = [NSString stringWithFormat:@"%@sendcode/", BASEURL];
            NSDictionary* messagedict = @{ @"number" : _userNameTextField.text,
                                           @"sign" : MDString,
                                           @"time" : timeString
                                           };
            [HttpTool postWithUrl:getMessageUrl params:messagedict body:nil progress:^(NSProgress * progress) {
                
            } success:^(id responseObject) {
                
                // 成功后清空所有数据
                [tokenArray  removeAllObjects];
                
                
            }];
        }];
        dispatch_resume(_timer);
    }
}

// 点击登录按钮
- (void)selecloginBtn {
    
    if (_userNameTextField.text.length != 11) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"输入的手机号码有误"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles: nil];
        
        [alert show];
    } else {
        
        if (_passWordTextField.text.length == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"验证码不能为空"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles: nil];
            
            [alert show];
        } else {
            
            [_loginBtn setTitle:@"正在登录" forState:UIControlStateNormal];
            [_loginBtn addSubview:_roundImageView];
            
            // 动效
            CABasicAnimation* basic2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
            basic2.fromValue   = [NSNumber numberWithFloat:0];
            basic2.byValue     = [NSNumber numberWithFloat:M_PI * 2];
            basic2.repeatCount = 10000;
            basic2.duration    = 2;
            [_roundImageView.layer addAnimation:basic2 forKey:@"basic1"];
            
            NSDictionary* dict = @{ @"number"     : _userNameTextField.text,
                                    @"code"       : _passWordTextField.text,
                                    @"registerID" : [JPUSHService registrationID] ? [JPUSHService registrationID] :@""
                                    };
            NSString* loginurl = [NSString stringWithFormat:@"%@userlogin/",BASEURL];
            [HttpTool postNotZreoReturnWithUrl:loginurl params:dict success:^(id responseObject) {
                
                if (ResponseObject_RC == 0) {
                    
                    
                    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                    [dict setObject:@"ture" forKey:@"login"];
                    
                    // NSHomeDirectory() 沙盒根目录的路径
                    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/d.plist"];
                    [dict writeToFile:path atomically:YES];
                    
                    // 跳转页面
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    
                    // 倒计时结束，关闭定时器
                    if (_timer) {
                         dispatch_source_cancel(_timer);
                    }
                } else {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                    [alert show];
                }
                // 移除动效
                [_roundImageView.layer removeAllAnimations];
                [_roundImageView removeFromSuperview];
            }];
        }
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    offset     = textField.frame.origin.y;
    textHeight = textField.bounds.size.height;
    
    return YES;
}

// 表随键盘高度变化
- (void)keyboardShow:(NSNotification*)note {

    
    
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY      = keyBoardRect.size.height;
    CGFloat  height     = self.view.frame.size.height  - (offset + textHeight + deltaY );
    if (height <=0) {
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, height - Adaptive(10));;
        }];
    }

    
}
- (void)keyboardHide:(NSNotification*)note {
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark 触摸屏幕回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}


@end
