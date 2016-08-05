//
//  FeedbackViewController.m
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//
#define ResultString @"请输入您的宝贵建议，我们会定期抽取幸运用户赠送奖品，欢迎多多反馈。"

#import "FeedbackViewController.h"
#import "LoginViewController.h"
@interface FeedbackViewController ()<UITextViewDelegate>
{
    UITextView *_textView;
    UIButton   *saveButton;
}
@end

@implementation FeedbackViewController
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
       
    UIView *navigationView = [UIView new];
    navigationView.frame   = CGRectMake(0, 0, viewWidth, NavigationBar_Height);
    navigationView.backgroundColor = ORANGECOLOR;
    [self.view addSubview:navigationView];
    
    CGFloat navigationHight = navigationView.frame.size.height - Adaptive(20);
    
    UILabel * titleLabel = [UILabel new];
    titleLabel.frame     = CGRectMake(Adaptive(100),
                                      Adaptive(20)+(navigationHight - Adaptive(20)) / 2,
                                      viewWidth - Adaptive(200),
                                      Adaptive(20));
    titleLabel.textColor = BASECOLOR;
    titleLabel.text      = @"意见反馈";
    titleLabel.textAlignment = 1;
    titleLabel.font      = [UIFont fontWithName:FONT_BOLD size:Adaptive(18)];
    [self.view addSubview:titleLabel];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame     = CGRectMake(Adaptive(13),
                                        Adaptive(20)+(navigationHight - Adaptive(20)) / 2,
                                        Adaptive(40),
                                        Adaptive(20));
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTintColor:UIColorFromRGB(0x2b2b2b)];
    cancelButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    
    [navigationView addSubview:cancelButton];
    
    
    saveButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(viewWidth - Adaptive(53),  Adaptive(20)+(navigationHight - Adaptive(20)) / 2, Adaptive(40), Adaptive(20));
    [saveButton setTitle:@"发送" forState:UIControlStateNormal];
    [saveButton setTintColor:UIColorFromRGB(0x7f7f7f)];
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.userInteractionEnabled = NO;
    saveButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [navigationView addSubview:saveButton];
    
    
    if ([HttpTool judgeWhetherUserLogin]) {
        _textView       = [UITextView new];
        _textView.frame = CGRectMake(Adaptive(13),
                                     Adaptive(10) + NavigationBar_Height,
                                     viewWidth - Adaptive(26),
                                     Adaptive(150));
        _textView.textColor = [UIColor grayColor];
        _textView.backgroundColor = BASECOLOR;
        _textView.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        _textView.text      = ResultString;
        _textView.delegate  = self;
        [self.view addSubview:_textView];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }

}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}
- (void)cancelButtonClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveButtonClick:(UIButton *)button {
    
    NSString* url = [NSString stringWithFormat:@"%@api/?method=gdb.feed&", BASEURL];
    NSDictionary* dict = @{ @"info" : _textView.text };
    [HttpTool postWithUrl:url params:dict body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:alert
                                        repeats:YES];
        
    }];
    
}
// 提示框消失
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:ResultString]) {
        textView.text = @"";
    }
    
}
#pragma mark- UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    NSMutableString * changedString = [[NSMutableString alloc]initWithString:textView.text];
    [changedString replaceCharactersInRange:range withString:text];
    
    if (changedString.length!=0) {
        
        [saveButton setTintColor:UIColorFromRGB(0x2b2b2b)];
        saveButton.userInteractionEnabled = YES;
        
    } else {
        [saveButton setTintColor:UIColorFromRGB(0x7f7f7f)];
        saveButton.userInteractionEnabled = NO;
        
    }
    return YES;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = ResultString;
    } else {
        
        CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]} context:nil].size;
        
        CGRect frame = textView.frame;
        if (textSize.height  > Adaptive(150)) {
            frame.size.height = textSize.height + Adaptive(8);
        }
        textView.frame = frame;
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
