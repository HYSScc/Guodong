//
//  amentViewController.m
//  果动
//
//  Created by mac on 15/5/20.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "amentViewController.h"
#import "Commonality.h"
#import "HttpTool.h"
@interface amentViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    UIImageView *baseImageView;
    UILabel *setSexLabel;
    int gender;
    UITextField *messageTextField;
    UIButton *changeImageButton;
    UIButton *setSexButton;
    UIImageView *centerImge;
}
@end

@implementation amentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
     self.view.backgroundColor = [UIColor colorWithRed:237/255.0 green:237/255.0 blue:237/255.0 alpha:1];
     self.navigationItem.titleView = [HeadComment titleLabeltext:@"编辑资料"];
    BackView *backView = [[BackView alloc] initWithbacktitle:@"个人" viewController:self];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    [self createView];
    
}
-(void)createView
{
    //NSLog(@"self.baseImage %@",self.baseImageStr);

   
    baseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
    
    [baseImageView setImageWithURL:[NSURL URLWithString:self.baseImageStr] success:^(UIImage *image, BOOL cached) {
        NSLog(@"caced %d   image %@",cached,image);
    } failure:^(NSError *error) {
        centerImge = [[UIImageView alloc] initWithFrame:CGRectMake((baseImageView.bounds.size.width - viewHeight/6.67)/2, (baseImageView.bounds.size.height - viewHeight/7.021)/2, viewHeight/6.67, viewHeight/7.021)];
        centerImge.image = [UIImage imageNamed:@"ament_baseimage"];
        
        centerImge.userInteractionEnabled = YES;
        [baseImageView addSubview:centerImge];
    }];
    baseImageView.userInteractionEnabled = YES;
    baseImageView.backgroundColor = BASECOLOR;
    [self.view addSubview:baseImageView];
    
   
    
    changeImageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    changeImageButton.frame = CGRectMake(0, 0, baseImageView.bounds.size.width, baseImageView.bounds.size.height);
    [changeImageButton addTarget:self action:@selector(changebaseView)  forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:changeImageButton];
    
    NSArray *array = @[@"姓名",@"性别"];
    for (int a = 0; a < 2; a++) {
        UIView *messageView = [[UIView alloc] initWithFrame:CGRectMake(0, (CGRectGetMaxY(baseImageView.frame) + viewHeight/66.7) + a*(viewHeight/11.117), viewWidth, viewHeight/13.34)];
        messageView.userInteractionEnabled = YES;
        messageView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:messageView];
        
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/66.7, (messageView.bounds.size.height - viewHeight/33.35)/2, viewHeight/16.675, viewHeight/33.35)];
        messageLabel.text = array[a];
        messageLabel.textColor = [UIColor lightGrayColor];
        messageLabel.font = [UIFont fontWithName:FONT size:viewHeight/41.6875];
        [messageView addSubview:messageLabel];
        
        if (a == 0 ) {
            messageTextField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageView.bounds.size.height)];
            messageTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
            messageTextField.textAlignment = 2;
            messageTextField.delegate = self;
            messageTextField.textColor = [UIColor grayColor];
            messageTextField.font  = [UIFont fontWithName:FONT size:viewHeight/37.056];
            [messageView addSubview:messageTextField];

        }
        else
        {
            setSexButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            setSexButton.frame = CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageView.bounds.size.height);
            [setSexButton addTarget:self action:@selector(setSex) forControlEvents:UIControlEventTouchUpInside];
            [messageView addSubview:setSexButton];
            
            setSexLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(messageLabel.frame)+viewHeight/66.7, 0, viewWidth - CGRectGetMaxX(messageLabel.frame) - viewHeight/33.35, messageView.bounds.size.height)];
            setSexLabel.textAlignment = 2;
            setSexLabel.textColor = [UIColor grayColor];
            setSexLabel.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
            [messageView addSubview:setSexLabel];
        }
    }
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake(0, viewHeight - viewHeight/13.34 - NavigationBar_Height, viewWidth, viewHeight/13.34);
    sureButton.backgroundColor = [UIColor orangeColor];
    sureButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
    [sureButton setTintColor:[UIColor whiteColor]];
    [sureButton setTitle:@"确认" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureButton];
    
    
    UIPanGestureRecognizer *tapLeftDouble  = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(tapLeftDouble)];
    [self.view addGestureRecognizer:tapLeftDouble];

    
}
-(void)setSex
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"男" otherButtonTitles:@"女", nil];
    sheet.tag = 7;
    [sheet showInView:self.view];
}
-(void)changebaseView
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从图库选择", nil];
   
    [sheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 7) {
        NSLog(@"buttonindex  %ld",(long)buttonIndex);
        if (buttonIndex == 0) {
            setSexLabel.text = @"男";
            gender = 1;
        }
        else if (buttonIndex == 1)
        {
            setSexLabel.text = @"女";
            gender = 2;
        }
        return;
    }
    
     if (buttonIndex == 2) return;
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    // 1.设置照片源
    
    if (buttonIndex == 0)
    { // 拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else
    { // 从照片库选择
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
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.set_background",BASEURL];
    [HttpTool uploadImageWithUrl:url image:info[UIImagePickerControllerEditedImage] completion:^(id responseObject) {
        NSLog(@"res  %@",responseObject);
        
        baseImageView.image = info[UIImagePickerControllerEditedImage];
        [centerImge removeFromSuperview];
    
    } errorBlock:^(NSError *error) {
        NSLog(@"error  %@",error);
    }];

}
-(void)sure
{
    NSLog(@"点击了确认");
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.set_userinfo",BASEURL];
    NSDictionary *dict = @{@"gender":[NSString stringWithFormat:@"%d",gender],@"nickname":messageTextField.text};
    [HttpTool postWithUrl:url params:dict contentType:CONTENTTYPE success:^(id responseObject) {
        NSLog(@"res  %@",responseObject);
        if ([[responseObject objectForKey:@"rc"] intValue] == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }

    } fail:^(NSError *error) {
        NSLog(@"error  %@",error);
    }];
}
-(void)tapLeftDouble
{
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    setSexButton.userInteractionEnabled = NO;
    changeImageButton.userInteractionEnabled = NO;
    CGFloat offset = self.view.frame.size.height - (textField.superview.frame.origin.y + textField.frame.size.height+216);
    NSLog(@"textField.frame.origin.y %f",textField.frame.origin.y);
    NSLog(@"offset %f",offset);
    if (offset<=0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
