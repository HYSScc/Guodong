//
//  OrderCommentViewController.m
//  果动
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "OrderCommentViewController.h"

@interface OrderCommentViewController ()<UITextViewDelegate>

@end

@implementation OrderCommentViewController
{
    UITextView *_textView;
    UILabel    *line;
    UIButton   *saveButton;
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
    
    
    NSLog(@"order_id %@",_order_id);
    
    
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
    titleLabel.text      = @"评价";
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
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton setTintColor:UIColorFromRGB(0x7f7f7f)];
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.userInteractionEnabled = NO;
    saveButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [navigationView addSubview:saveButton];
    
    
    
    _textView       = [UITextView new];
    _textView.frame = CGRectMake(Adaptive(13),
                                 Adaptive(10) + NavigationBar_Height,
                                 viewWidth - Adaptive(26),
                                 Adaptive(150));
    _textView.textColor = [UIColor grayColor];
    _textView.backgroundColor = BASECOLOR;
    _textView.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    _textView.text      = @"说点什么...";
    _textView.delegate  = self;
    [self.view addSubview:_textView];
    
    line = [UILabel new];
    line.frame = CGRectMake(0, CGRectGetMaxY(_textView.frame) + Adaptive(5), viewWidth, .5);
    line.backgroundColor = BASEGRYCOLOR;
    [self.view addSubview:line];
   
}

- (void)cancelButtonClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveButtonClick:(UIButton *)button
{
    NSString *url      = [NSString stringWithFormat:@"%@api/?method=order.feed",BASEURL];
    NSDictionary *dict = @{@"order_id":_order_id,
                           @"content":_textView.text};
    [HttpTool postWithUrl:url params:dict body:nil progress:^(NSProgress *progress) {
        
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
#pragma mark- UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"说点什么..."]) {
        textView.text = @"";
    }
}

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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
