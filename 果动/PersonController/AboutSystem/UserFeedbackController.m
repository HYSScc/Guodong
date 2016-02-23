//
//  UserFeedbackController.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//


#import "UserFeedbackController.h"
@interface UserFeedbackController () <UITextViewDelegate> {
    UITextView* _textView;
    UIButton* sureButton;
    UIImageView* roundImageView;
}
@end

@implementation UserFeedbackController

- (void)viewDidLoad
{

    [super viewDidLoad];

    self.view.backgroundColor = BASECOLOR;

    self.navigationItem.titleView = [HeadComment titleLabeltext:@"用户反馈"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"反馈" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    UIImageView* lineImage1 = [UIImageView new];

    lineImage1.image = [UIImage imageNamed:@"home__line1"];

    lineImage1.frame = CGRectMake(0, 0, viewWidth, 0.5);

    [self.view addSubview:lineImage1];

    UIImageView* backImageview = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(10), Adaptive(20), viewWidth - Adaptive(20), Adaptive(222.333))];
    backImageview.userInteractionEnabled = YES;
    [self.view addSubview:backImageview];

    _textView = [[UITextView alloc] initWithFrame:CGRectMake(Adaptive(10), Adaptive(10), viewWidth - Adaptive(40), Adaptive(222.333) - Adaptive(20))];
    _textView.delegate = self;
    _textView.textColor = [UIColor whiteColor];
    _textView.font = [UIFont fontWithName:FONT size:Adaptive(14)];
    _textView.text = @" 欢迎提出您的宝贵意见,我们会加倍努力！";
    _textView.layer.borderColor = [UIColor grayColor].CGColor;
    _textView.layer.borderWidth = 0.5;
    _textView.layer.cornerRadius = 5.0;
    _textView.backgroundColor = BASECOLOR;
    [backImageview addSubview:_textView];

    sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake((viewWidth - Adaptive(250)) / 2, CGRectGetMaxY(_textView.frame) + Adaptive(80), Adaptive(250),Adaptive(45));
    [sureButton setTintColor:[UIColor whiteColor]];
    [sureButton setTitle:@"提交" forState:UIControlStateNormal];
    sureButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"userFeed_tijiao"] forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(fankui) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];

    roundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(sureButton.bounds.size.width / 5, (sureButton.bounds.size.height - Adaptive(18)) / 2, Adaptive(18), Adaptive(18))];
    roundImageView.image = [UIImage imageNamed:@"login_round"];
}
- (void)textViewDidBeginEditing:(UITextView*)textView
{
    if ([textView.text isEqualToString:@" 欢迎提出您的宝贵意见,我们会加倍努力！"]) {
        textView.text = @"";
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}
- (void)fankui
{
    NSLog(@"点击了按钮");
    [sureButton addSubview:roundImageView];
    [sureButton setTitle:@"正在提交" forState:UIControlStateNormal];
    CABasicAnimation* basic2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    basic2.fromValue = [NSNumber numberWithFloat:0];
    basic2.byValue = [NSNumber numberWithFloat:M_PI * 2];
    basic2.repeatCount = 10000;
    basic2.duration = 2;
    [roundImageView.layer addAnimation:basic2 forKey:@"basic1"];
    NSString* url = [NSString stringWithFormat:@"%@api/?method=gdb.feed&", BASEURL];
    NSDictionary* dict = @{ @"info" : _textView.text };
    [HttpTool postWithUrl:url params:dict contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            [roundImageView.layer removeAllAnimations];
            [roundImageView removeFromSuperview];
            [sureButton setTitle:@"反馈成功" forState:UIControlStateNormal];

            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"反馈成功" message:@"感谢您的建议,我们会做的更好" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
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
    [self.navigationController popViewControllerAnimated:YES];
}
@end
