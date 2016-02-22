//
//  TopView.m
//  果动
//
//  Created by mac on 15/10/29.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "AsynImageView.h"

#import "PersonalCenterController.h"
#import "TopImageView.h"
#import "amentViewController.h"
#import "personModel.h"
static TopImageView* topView = nil;
@implementation TopImageView {
    int pickertag;
    NSString* locationAddress;
    UIImageView* vipheadImage;
    AsynImageView* iconImageView;
    UIActionSheet* changesheet;
    UIImageView* seximg;
    UILabel* nickname;
    UILabel* addressLabel;
    NSString* headbaseImageString;
}
- (id)init
{
    self = [super init];
    if (self) {
        pickertag = -1;
        self.frame = CGRectMake(0, 0, viewWidth, viewWidth);
        self.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:24 / 255.0 blue:24 / 255.0 alpha:1];
        self.userInteractionEnabled = YES;
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"refush" object:nil];
    }
    return self;
}
- (void)tongzhi:(NSNotification*)notification
{
    NSDictionary* dict = notification.userInfo;
    _person = [dict objectForKey:@"personModel"];
    NSLog(@"_person %@", _person);
    locationAddress = [dict objectForKey:@"locationAddress"];
    _viewController = [dict objectForKey:@"viewController"];
    //背景图片
    [self setImageWithURL:[NSURL URLWithString:_person.backimg]];
    //头像
    headbaseImageString = _person.backimg;
    //是否VIP
    [_person.is_vip intValue] == 1 ? [self addSubview:vipheadImage] : [vipheadImage removeFromSuperview];
    [iconImageView setImageWithURL:[NSURL URLWithString:_person.headimg] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    //性别
    if ([_person.gender isKindOfClass:[NSNull class]]) {
        [seximg setImage:[UIImage imageNamed:@"person_woman"]];
    }
    else {
        [seximg setImage:[_person.gender intValue] == 1 ? [UIImage imageNamed:@"person_man"] : [UIImage imageNamed:@"person_woman"]];
    }
    // 昵称
    if ([_person.nickname isKindOfClass:[NSNull class]] || [_person.nickname isEqualToString:@""] || !_person) {
        nickname.text = @"GUODONG";
    }
    else {
        nickname.text = _person.nickname;
    }
    CGSize nickNameSize = [nickname.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(19)] }];
    nickname.bounds = CGRectMake(0, 0, nickNameSize.width, nickNameSize.height);
    //地址
    addressLabel.text = locationAddress;
    CGSize addressSize = [addressLabel.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(14)] }];
    addressLabel.bounds = CGRectMake(0, 0, addressSize.width, addressSize.height);
}
- (void)createUI
{
    changesheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从图库选择", nil];

    UIButton* headbaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headbaseButton.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [headbaseButton addTarget:self action:@selector(changebaseView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headbaseButton];

    vipheadImage = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(196.5), Adaptive(14), Adaptive(26),Adaptive(22))];
    [vipheadImage setImage:[UIImage imageNamed:@"person_vip"]];

    iconImageView = [[AsynImageView alloc] init];
    iconImageView.frame = CGRectMake((self.bounds.size.width - self.bounds.size.width / 5) / 2,Adaptive(25), self.bounds.size.width / 5, self.bounds.size.width / 5);
    //切圆角
    [HeadComment cornerRadius:iconImageView];
    iconImageView.userInteractionEnabled = YES;
    [iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upLoadImageIcon)]];
    [self addSubview:iconImageView];

    seximg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(iconImageView.frame) - Adaptive(15), CGRectGetMaxY(iconImageView.frame) -Adaptive(10), Adaptive(10), Adaptive(10))];
    [self addSubview:seximg];

    nickname = [UILabel new];
    nickname.frame = CGRectMake((self.bounds.size.width - Adaptive(175)) / 2, CGRectGetMaxY(iconImageView.frame) + Adaptive(20), Adaptive(175), Adaptive(20));
    nickname.textAlignment = 1;
    nickname.font = [UIFont fontWithName:FONT size:Adaptive(18)];
    nickname.textColor = [UIColor whiteColor];
    [self addSubview:nickname];

    addressLabel = [UILabel new];
    addressLabel.textAlignment = 2;
    addressLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
    addressLabel.textColor = [UIColor lightGrayColor];
    addressLabel.frame = CGRectMake((self.bounds.size.width - Adaptive(10)) / 2, CGRectGetMaxY(nickname.frame) + Adaptive(8), Adaptive(10), Adaptive(12.8));
    [self addSubview:addressLabel];

    UIImageView* addimg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(addressLabel.frame) - Adaptive(5), CGRectGetMaxY(nickname.frame) + Adaptive(8), Adaptive(8.8), Adaptive(12.8))];
    [addimg setImage:[UIImage imageNamed:@"person_dingwe"]];
    [self addSubview:addimg];

    UIButton* setPersonButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setPersonButton.frame = CGRectMake((self.bounds.size.width - Adaptive(152.5)) / 2, CGRectGetMaxY(addressLabel.frame) + Adaptive(24), Adaptive(152.5), Adaptive(31.5));
    [setPersonButton addTarget:self action:@selector(setPersonButton) forControlEvents:UIControlEventTouchUpInside];
    [setPersonButton setBackgroundImage:[UIImage imageNamed:@"person_setButton"] forState:UIControlStateNormal];
    [self addSubview:setPersonButton];
}
#pragma mark 更换背景图片
- (void)changebaseView
{
    changesheet.tag = 888;
    [changesheet showInView:self];
}
#pragma mark 更换头像
- (void)upLoadImageIcon
{
    changesheet.tag = 777;
    [changesheet showInView:self];
}
#pragma mark - UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 2)
        return;
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    // 1.设置照片源
    if (buttonIndex == 0) {
        // 拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
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
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{

    [picker dismissViewControllerAnimated:YES completion:nil];
    if (pickertag == 777) {
        NSString* url = [NSString stringWithFormat:@"%@api/?method=user.set_headimg", BASEURL];
        [HttpTool uploadImageWithUrl:url image:info[UIImagePickerControllerEditedImage] completion:^(id responseObject) {

            iconImageView.image = info[UIImagePickerControllerEditedImage];
        }
            errorBlock:^(NSError* error){
            }];
    }
    else {
        self.contentMode = UIViewContentModeScaleAspectFill;
        NSString* url = [NSString stringWithFormat:@"%@api/?method=user.set_background", BASEURL];
        [HttpTool uploadImageWithUrl:url image:info[UIImagePickerControllerEditedImage] completion:^(id responseObject) {

            self.image = info[UIImagePickerControllerEditedImage];
        }
            errorBlock:^(NSError* error){
            }];
    }
}
- (void)setPersonButton
{
    amentViewController* ament = [amentViewController new];
    ament.baseImageStr = headbaseImageString;
    [_viewController.navigationController pushViewController:ament animated:YES];
}
+ (instancetype)sharedViewControllerManager
{
    static dispatch_once_t onceToken;
    static TopImageView* top;

    dispatch_once(&onceToken, ^{
        top = [[TopImageView alloc] init];
    });

    return top;
}
@end
