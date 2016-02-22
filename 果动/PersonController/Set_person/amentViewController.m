//
//  amentViewController.m
//  果动
//
//  Created by mac on 15/5/20.
//  Copyright (c) 2015年 Unique. All rights reserved.
//


#import "amentViewController.h"
@interface amentViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate> {
    UIImageView* baseImageView;
    UILabel* setSexLabel;
    int gender;
    UITextField* messageTextField;
    UIButton* changeImageButton;
    UIButton* setSexButton;
    UIImageView* centerImge;
}
@end

@implementation amentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:237 / 255.0 green:237 / 255.0 blue:237 / 255.0 alpha:1];
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"编辑资料"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"个人" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    [self createView];
}
- (void)createView
{
    baseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];

    [baseImageView setImage:self.baseImage];
    
//    [baseImageView setImageWithURL:[NSURL URLWithString:self.baseImageStr] success:^(UIImage* image, BOOL cached) {
//        NSLog(@"caced %d   image %@", cached, image);
//    }
//        failure:^(NSError* error) {
//            centerImge = [[UIImageView alloc] initWithFrame:CGRectMake((baseImageView.bounds.size.width - Adaptive(100)) / 2, (baseImageView.bounds.size.height - Adaptive(95)) / 2, Adaptive(100),Adaptive(95))];
//            centerImge.image = [UIImage imageNamed:@"ament_baseimage"];
//
//            centerImge.userInteractionEnabled = YES;
//            [baseImageView addSubview:centerImge];
//        }];
    baseImageView.userInteractionEnabled = YES;
    baseImageView.backgroundColor = BASECOLOR;
    [self.view addSubview:baseImageView];

    changeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    changeImageButton.frame = CGRectMake(0, 0, baseImageView.bounds.size.width, baseImageView.bounds.size.height);
    [changeImageButton addTarget:self action:@selector(changebaseView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeImageButton];

    NSArray* array = @[ @"姓名", @"性别" ];
    for (int a = 0; a < 2; a++) {
        UIView* messageView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetMaxY(baseImageView.frame) + Adaptive(10)) + a * Adaptive(60), viewWidth, Adaptive(50))];
        messageView.userInteractionEnabled = YES;
        messageView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:messageView];

        UILabel* messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(10), (messageView.bounds.size.height - Adaptive(20)) / 2, Adaptive(40), Adaptive(20))];
        messageLabel.text = array[a];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
        [messageView addSubview:messageLabel];

        if (a == 0) {
            messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame) + Adaptive(10), 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - Adaptive(20), messageView.bounds.size.height)];
            messageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            messageTextField.textAlignment = 2;
            messageTextField.delegate = self;
            messageTextField.textColor = [UIColor grayColor];
            messageTextField.font = [UIFont fontWithName:FONT size:Adaptive(18)];
            [messageView addSubview:messageTextField];
        }
        else {
            setSexButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            setSexButton.frame = CGRectMake(CGRectGetMaxX(messageLabel.frame) + Adaptive(10), 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - Adaptive(20), messageView.bounds.size.height);
            [setSexButton addTarget:self action:@selector(setSex) forControlEvents:UIControlEventTouchUpInside];
            [messageView addSubview:setSexButton];

            setSexLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame) + Adaptive(10), 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - Adaptive(20), messageView.bounds.size.height)];
            setSexLabel.textAlignment = 2;
            setSexLabel.textColor = [UIColor grayColor];
            setSexLabel.font = [UIFont fontWithName:FONT size:Adaptive(18)];
            [messageView addSubview:setSexLabel];
        }
    }

    UIButton* sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake(0, viewHeight - Adaptive(50) - NavigationBar_Height, viewWidth, Adaptive(50));
    sureButton.backgroundColor = [UIColor orangeColor];
    sureButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(18)];
    [sureButton setTintColor:[UIColor whiteColor]];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];

    UIPanGestureRecognizer* tapLeftDouble = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapLeftDouble)];
    [self.view addGestureRecognizer:tapLeftDouble];
}
- (void)setSex
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    sheet.tag = 7;
    [sheet showInView:self.view];
}
- (void)changebaseView
{
    UIActionSheet* sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从图库选择", nil];

    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 7) {
        NSLog(@"buttonindex  %ld", (long)buttonIndex);
        if (buttonIndex == 0) {
            setSexLabel.text = @"男";
            gender = 1;
        }
        else if (buttonIndex == 1) {
            setSexLabel.text = @"女";
            gender = 2;
        }
        return;
    }

    if (buttonIndex == 2)
        return;

    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];

    // 1.设置照片源

    if (buttonIndex == 0) { // 拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else { // 从照片库选择
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 2.允许编辑
    imagePickerController.allowsEditing = YES;
    // 3.设置代理
    imagePickerController.delegate = self;
    // 4.显示照片选择控制器
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
#pragma mark - UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString* url = [NSString stringWithFormat:@"%@api/?method=user.set_background", BASEURL];
    [HttpTool uploadImageWithUrl:url image:info[UIImagePickerControllerEditedImage] completion:^(id responseObject) {

        baseImageView.image = info[UIImagePickerControllerEditedImage];
        [centerImge removeFromSuperview];

    }
        errorBlock:^(NSError* error){
        }];
}
- (void)sure
{

    NSString* url = [NSString stringWithFormat:@"%@api/?method=user.set_userinfo", BASEURL];
    NSDictionary* dict = @{ @"gender" : [NSString stringWithFormat:@"%d", gender],
        @"nickname" : messageTextField.text };
    [HttpTool postWithUrl:url params:dict contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            [self.navigationController popViewControllerAnimated:YES];
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
- (void)tapLeftDouble
{
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    setSexButton.userInteractionEnabled = NO;
    changeImageButton.userInteractionEnabled = NO;
    CGFloat offset = self.view.frame.size.height - (textField.superview.frame.origin.y + textField.frame.size.height + 216);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    setSexButton.userInteractionEnabled = YES;
    changeImageButton.userInteractionEnabled = YES;
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 66.0;
        self.view.frame = frame;
    }];
    return YES;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}

@end
