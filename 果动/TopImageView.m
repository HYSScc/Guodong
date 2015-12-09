//
//  TopView.m
//  果动
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "TopImageView.h"
#import "Commonality.h"
#import "AsynImageView.h"
#import "personModel.h"
#import "amentViewController.h"
#import "PersonalCenterController.h"
static TopImageView *topView = nil;
@implementation TopImageView
{
    int pickertag;
    NSString * locationAddress;
    UIImageView *vipheadImage;
    AsynImageView * iconImageView;
    UIActionSheet *changesheet;
    UIImageView *seximg;
    UILabel * nickname;
    UILabel * addressLabel;
    NSString *headbaseImageString;
}
-(id)init
{
    self = [super init];
    if (self) {
        NSLog(@"金初始化了");//viewHeight/2.779
        pickertag = -1;
        self.frame = CGRectMake(0, 0, viewWidth, viewWidth);
        self.backgroundColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1];
        self.userInteractionEnabled = YES;
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"refush" object:nil];
    }
    return self;
}
-(void)tongzhi:(NSNotification *)notification
{
    NSDictionary *dict = notification.userInfo;
    _person = [dict objectForKey:@"personModel"];
    NSLog(@"_person %@",_person);
    locationAddress = [dict objectForKey:@"locationAddress"];
    _viewController = [dict objectForKey:@"viewController"];
    //背景图片
    [self setImageWithURL:[NSURL URLWithString:_person.backimg]];
    //头像
    headbaseImageString = _person.backimg;
    //是否VIP
    [_person.is_vip intValue] == 1? [self addSubview:vipheadImage] : [vipheadImage removeFromSuperview];
    [iconImageView setImageWithURL:[NSURL URLWithString:_person.headimg] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    //性别
    if ([_person.gender isKindOfClass:[NSNull class]])
    {
        [seximg setImage:[UIImage imageNamed:@"person_woman"]];
    }
    else
    {
        [seximg setImage:[_person.gender intValue] == 1? [UIImage imageNamed:@"person_man"] : [UIImage imageNamed:@"person_woman"]];
    }
    // 昵称
    if ([_person.nickname isKindOfClass:[NSNull class]] || [_person.nickname isEqualToString:@""] || !_person) {
        nickname.text = @"GUODONG";
    }else{
        nickname.text = _person.nickname;
    }
    CGSize nickNameSize = [nickname.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:viewHeight/35.105]}];
    nickname.bounds = CGRectMake(0,0,nickNameSize.width,nickNameSize.height);
    //地址
    addressLabel.text = locationAddress;
    CGSize addressSize = [addressLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:viewHeight/47.643]}];
    addressLabel.bounds = CGRectMake(0, 0, addressSize.width, addressSize.height);
    
}
-(void)createUI
{
    changesheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从图库选择", nil];
    
    UIButton *headbaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headbaseButton.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [headbaseButton addTarget:self action:@selector(changebaseView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headbaseButton];
    
    vipheadImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewHeight/3.3944, viewHeight/47.6429, viewHeight/25.65385, viewHeight/30.3182)];
    [vipheadImage setImage:[UIImage imageNamed:@"person_vip"]];
    
    iconImageView=[[AsynImageView alloc]init];
    iconImageView.frame=CGRectMake((self.bounds.size.width - self.bounds.size.width/5)/2, viewHeight/26.68, self.bounds.size.width/5, self.bounds.size.width/5);
    //切圆角
    [HeadComment cornerRadius:iconImageView];
    iconImageView.userInteractionEnabled = YES;
    [iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upLoadImageIcon)]];
    [self addSubview:iconImageView];
    
    seximg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) - viewHeight/44.467, CGRectGetMaxY(iconImageView.frame) - viewHeight/66.7, viewHeight/66.7, viewHeight/66.7)];
    [self addSubview:seximg];
    
    nickname=[UILabel new];
    nickname.frame = CGRectMake((self.bounds.size.width - viewHeight/3.811)/2,CGRectGetMaxY(iconImageView.frame) + viewHeight/33.35,viewHeight/3.811,viewHeight/33.35);
    nickname.textAlignment = 1;
    nickname.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
    nickname.textColor=[UIColor whiteColor];
    [self addSubview:nickname];
    
    addressLabel=[UILabel new];
    addressLabel.textAlignment = 2;
    addressLabel.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
    addressLabel.textColor=[UIColor lightGrayColor];
    addressLabel.frame = CGRectMake((self.bounds.size.width - viewHeight/6.67)/2, CGRectGetMaxY(nickname.frame) + viewHeight/83.375, viewHeight/6.67, viewHeight/52.109);
    [self addSubview:addressLabel];
    
    UIImageView *addimg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(addressLabel.frame) - viewHeight/133.4, CGRectGetMaxY(nickname.frame) + viewHeight/83.375, viewHeight/75.795, viewHeight/52.109)];
    [addimg setImage:[UIImage imageNamed:@"person_dingwe"]];
    [self addSubview:addimg];
    
    UIButton *setPersonButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setPersonButton.frame = CGRectMake((self.bounds.size.width - viewHeight/4.374)/2,CGRectGetMaxY(addressLabel.frame) + viewHeight/27.792, viewHeight/4.374, viewHeight/21.175);
    [setPersonButton addTarget:self action:@selector(setPersonButton) forControlEvents:UIControlEventTouchUpInside];
    [setPersonButton setBackgroundImage:[UIImage imageNamed:@"person_setButton"] forState:UIControlStateNormal];
    [self addSubview:setPersonButton];
    
}
#pragma mark 更换背景图片
-(void)changebaseView
{
    changesheet.tag = 888;
    [changesheet showInView:self];
}
#pragma mark 更换头像
-(void)upLoadImageIcon
{
    changesheet.tag = 777;
    [changesheet showInView:self];
}
#pragma mark - UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2) return;
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    // 1.设置照片源
    if (buttonIndex == 0){
        // 拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        // 从照片库选择
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    // 2.允许编辑
    imagePickerController.allowsEditing = YES;
    // 3.设置代理
    imagePickerController.delegate = self;
    // 4.显示照片选择控制器
    [_viewController presentViewController:imagePickerController animated:YES completion:nil];
    pickertag = (int)actionSheet.tag;
}
#pragma mark - UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    if (pickertag == 777) {
        NSString *url = [NSString stringWithFormat:@"%@api/?method=user.set_headimg",BASEURL];
        [HttpTool uploadImageWithUrl:url image:info[UIImagePickerControllerEditedImage] completion:^(id responseObject) {
            NSLog(@"res  %@",responseObject);
            iconImageView.image = info[UIImagePickerControllerEditedImage];
    
        } errorBlock:^(NSError *error) {
            NSLog(@"error  %@",error);
        }];
    }else{
        self.contentMode = UIViewContentModeScaleAspectFill;
        NSString *url = [NSString stringWithFormat:@"%@api/?method=user.set_background",BASEURL];
        [HttpTool uploadImageWithUrl:url image:info[UIImagePickerControllerEditedImage] completion:^(id responseObject) {
            NSLog(@"res  %@",responseObject);
            
            self.image =info[UIImagePickerControllerEditedImage];
            
        } errorBlock:^(NSError *error) {
            NSLog(@"error  %@",error);
        }];
    }
    
}
-(void)setPersonButton
{
    amentViewController *ament = [amentViewController new];
    ament.baseImageStr = headbaseImageString;
    [_viewController.navigationController pushViewController:ament animated:YES];
}
+ (instancetype)sharedViewControllerManager {
    static dispatch_once_t onceToken;
    static TopImageView* top;
    
    dispatch_once(&onceToken, ^{
        top = [[TopImageView alloc] init];
    });
    
    return top;
}
@end
