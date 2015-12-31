//
//  SettingController.m
//  私练
//
//  Created by 1 on 15/1/14.
//  Copyright (c) 2015年 Unique. All rights reserved.
//
#import "AppDelegate.h"
#import "AsynImageView.h"
#import "Commonality.h"
#import "FBShimmering.h"
#import "FBShimmeringLayer.h"
#import "FBShimmeringView.h"
#import "GBViewController.h"
#import "HttpTool.h"
#import "LoginViewController.h"
#import "MoneyViewController.h"
#import "MyExercise.h"
#import "PersonalCenterController.h"
#import "SETViewController.h"
#import "SJAvatarBrowser.h"
#import "UserFeedbackController.h"
#import "VIPViewController.h"
#import "amentViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import <ShareSDK/ShareSDK.h>
@interface PersonalCenterController () <UIAlertViewDelegate, UIActionSheetDelegate, UIScrollViewDelegate, ISSShareViewDelegate> {
    UIImageView* shareAlert;
    UIImageView* _backgroundImage;
    AsynImageView* _iconImageView;
    UIImageView* _bottomImage;
    UILabel* _lab;
    UIButton* _loginbtn;
    UILabel* _nickNameLabel;
    UIButton* _reviseBtn;
    UILabel* addressLabel;
    UILabel* weightLabel;
    UILabel* statureLabel;
    UILabel* birthdayLabel;
    UILabel* nameLabel;
    UILabel* sexLabel;
    NSString* iconString;
    NSString* birthdatSTR;
    NSString* birthdayYEAR;
    NSString* filePath;
    UILabel* viplabel;
    UIImageView* vipheadImage;
    BOOL open;
    BOOL magnify;
    BOOL succImage;
    NSString* gender;
    UISegmentedControl* segmentedControl;
    UIImageView* headbaseView;
    UIImageView* vipImage;
    UIImageView* looknumberImageView;
    UILabel* looknumberLabel;
    UIImageView* shujuView;
    UIImageView* seximg;
    int pickertag;
    NSString* headbaseImageString;
    UIActionSheet* changesheet;
}
@end

@implementation PersonalCenterController

- (void)viewDidLoad
{
    [super viewDidLoad];

    pickertag = -1;
    self.view.backgroundColor = BASECOLOR;
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"个人"];
    self.title = @"个人";

    UIButton* amentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    amentButton.frame = CGRectMake(Adaptive(330),Adaptive(27), Adaptive(17.5),Adaptive(17.5));
    [amentButton setBackgroundImage:[UIImage imageNamed:@"person_set"] forState:UIControlStateNormal];
    [amentButton addTarget:self action:@selector(amentButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:amentButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;

    changesheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从图库选择", nil];
    [self onCreate];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self sendRequest];
}
- (void)sendRequest
{
    addressLabel.text = self.address ? self.address : @"北京市.朝阳区";
    CGSize userNameSize = [addressLabel.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(14)] }];

    addressLabel.bounds = CGRectMake(0, 0, userNameSize.width, userNameSize.height);
    NSString* url = [NSString stringWithFormat:@"%@api/?method=user.get_userinfo", BASEURL];
    if (url) {
        NSArray* cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
        NSLog(@"cookies %@", cookies);
    }
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            NSDictionary* data = responseObject[@"data"];
            UIImageView* vipView = (UIImageView*)[self.view viewWithTag:45 * 5];
            if ([[data objectForKey:@"is_vip"] intValue] == 1) {

                vipView.userInteractionEnabled = NO;
                [vipView setImage:[UIImage imageNamed:@"person_notiao"]];
                [vipView addSubview:viplabel];
                [self.view addSubview:vipheadImage];
            }
            else {
                vipView.userInteractionEnabled = YES;
                [vipView setImage:[UIImage imageNamed:@"person_tiao"]];
                [viplabel removeFromSuperview];
                [vipheadImage removeFromSuperview];
            }
            iconString = data[@"headimg"];
            headbaseImageString = data[@"backimg"];

            [headbaseView setImageWithURL:[NSURL URLWithString:headbaseImageString] success:^(UIImage* image, BOOL cached) {
                NSLog(@"cached %d", cached);
                succImage = YES;
            }
                failure:^(NSError* error) {
                    NSLog(@"error %@", error);
                }];

            [_iconImageView setImageWithURL:[NSURL URLWithString:iconString] placeholderImage:[UIImage imageNamed:@"person_nohead"]];

            if ([[data objectForKey:@"isview"] intValue] != 0) {
                [shujuView addSubview:looknumberImageView];
                if ([[data objectForKey:@"isview"] intValue] >= 99) {
                    looknumberLabel.text = @"99+";
                }
                else {
                    looknumberLabel.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"isview"]];
                }
            }
            else {
                [looknumberImageView removeFromSuperview];
            }
            if ([[data objectForKey:@"nickname"] isKindOfClass:[NSNull class]] || [[data objectForKey:@"nickname"] isEqualToString:@""]) {
                _lab.text = @"GUODONG";
            }
            else {
                _lab.text = [data objectForKey:@"nickname"];
            }

            CGSize userNameSize = [_lab.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(19)] }];
            _lab.bounds = CGRectMake(0, 0, userNameSize.width, userNameSize.height);

            if ([[data objectForKey:@"gender"] isKindOfClass:[NSNull class]]) {
                [seximg setImage:[UIImage imageNamed:@"person_woman"]];
            }
            else {
                [seximg setImage:[[data objectForKey:@"gender"] intValue] == 1 ? [UIImage imageNamed:@"person_man"] : [UIImage imageNamed:@"person_woman"]];
            }
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
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}
#pragma mark 初始化背景图、按钮控件与名字

- (void)onCreate
{
    //分享提示的View
    shareAlert = [[UIImageView alloc] initWithFrame:CGRectMake(50, 0, viewWidth - 100, 50)];
    shareAlert.layer.cornerRadius = 10;
    shareAlert.layer.masksToBounds = YES;
    shareAlert.backgroundColor = [UIColor whiteColor];

    headbaseView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewWidth)];
    headbaseView.backgroundColor = [UIColor colorWithRed:24 / 255.0 green:24 / 255.0 blue:24 / 255.0 alpha:1];
    headbaseView.userInteractionEnabled = YES;
    [self.view addSubview:headbaseView];

    UIButton* headbaseButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    headbaseButton.frame = CGRectMake(0, 0, headbaseView.bounds.size.width, headbaseView.bounds.size.height);
    [headbaseButton addTarget:self action:@selector(changebaseView) forControlEvents:UIControlEventTouchUpInside];
    [headbaseView addSubview:headbaseButton];

    UIScrollView* functionScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, viewHeight - NavigationBar_Height - viewWidth, viewWidth, viewWidth - .5)];
    if (IS_IPhone6plus) {
        functionScrollView.frame = CGRectMake(0, viewHeight - Tabbar_Height - viewWidth, viewWidth, viewWidth - .5);
    }
    functionScrollView.delegate = self;
    functionScrollView.backgroundColor = [UIColor clearColor];
    functionScrollView.contentSize = CGSizeMake(viewWidth, viewWidth);
    [self.view addSubview:functionScrollView];
    for (int a = 0; a < 5; a++) {
        UIImageView* View = [[UIImageView alloc] init];
        View.frame = CGRectMake(0, a * ((functionScrollView.contentSize.height - Tabbar_Height) / 5), viewWidth, (functionScrollView.contentSize.height - Tabbar_Height) / 5);
        View.tag = 45 * a + 45;
        View.image = [UIImage imageNamed:@"person_tiao"];
        View.userInteractionEnabled = YES;
        [functionScrollView addSubview:View];
    }

    vipheadImage = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(196.5), Adaptive(14), Adaptive(26), Adaptive(22))];
    [vipheadImage setImage:[UIImage imageNamed:@"person_vip"]];

    _iconImageView = [[AsynImageView alloc] init];
    //到时候从网络获取数据
    _iconImageView.frame = CGRectMake((headbaseView.bounds.size.width - headbaseView.bounds.size.width / 5) / 2, Adaptive(25), headbaseView.bounds.size.width / 5, headbaseView.bounds.size.width / 5);
    [_iconImageView setImage:[UIImage imageNamed:@"person_nohead"]];
    //切圆角
    [HeadComment cornerRadius:_iconImageView];
    _iconImageView.userInteractionEnabled = YES;
    [_iconImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(upLoadImageIcon)]];
    [headbaseView addSubview:_iconImageView];
    //
    //
    seximg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconImageView.frame) - Adaptive(15), CGRectGetMaxY(_iconImageView.frame) - Adaptive(10), Adaptive(10), Adaptive(10))];
    [seximg setImage:[UIImage imageNamed:@"person_woman"]];
    [headbaseView addSubview:seximg];

    _lab = [UILabel new];
    _lab.text = @"GUODONG";
    _lab.textAlignment = 1;
    _lab.font = [UIFont fontWithName:FONT size:Adaptive(18)];
    _lab.textColor = [UIColor whiteColor];
    _lab.frame = CGRectMake((headbaseView.bounds.size.width - Adaptive(175)) / 2, CGRectGetMaxY(_iconImageView.frame) + Adaptive(20), Adaptive(175), Adaptive(20));
    [headbaseView addSubview:_lab];

    addressLabel = [UILabel new];
    addressLabel.text = @"北京市.朝阳区";
    addressLabel.textAlignment = 2;
    addressLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
    addressLabel.textColor = [UIColor whiteColor];
    addressLabel.frame = CGRectMake((headbaseView.bounds.size.width - Adaptive(100)) / 2 + 12.5, CGRectGetMaxY(_lab.frame) + Adaptive(8), Adaptive(100), Adaptive(12.8));
    [headbaseView addSubview:addressLabel];

    UIImageView* addimg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(addressLabel.frame) - Adaptive(5), CGRectGetMaxY(_lab.frame) + Adaptive(8), Adaptive(8.8), Adaptive(12.8))];
    [addimg setImage:[UIImage imageNamed:@"person_dingwe"]];
    // addimg.backgroundColor = [UIColor blackColor];
    [headbaseView addSubview:addimg];

    UIButton* setPersonButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setPersonButton.frame = CGRectMake((headbaseView.bounds.size.width - Adaptive(152.5)) / 2, CGRectGetMaxY(addressLabel.frame) + Adaptive(20), Adaptive(152.5), Adaptive(31.5));
    [setPersonButton addTarget:self action:@selector(setPersonButton) forControlEvents:UIControlEventTouchUpInside];
    [setPersonButton setBackgroundImage:[UIImage imageNamed:@"person_setButton"] forState:UIControlStateNormal];
    [headbaseView addSubview:setPersonButton];

    //
    /*****************功能区--文字******************/
    UIImageView* shareView = (UIImageView*)[self.view viewWithTag:45];
    UILabel* shareLabel = [UILabel new];
    shareLabel.text = @"分享";
    shareLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    shareLabel.textColor = [UIColor whiteColor];
    shareLabel.frame = CGRectMake(Adaptive(13), (shareView.bounds.size.height - 21) / 2, Adaptive(60), 21);
    [shareView addSubview:shareLabel];

    shujuView = (UIImageView*)[self.view viewWithTag:45 * 2];
    UILabel* shujuLable = [UILabel new];
    shujuLable.textColor = [UIColor whiteColor];
    shujuLable.frame = CGRectMake(Adaptive(13), (shujuView.bounds.size.height - 21) / 2,Adaptive(80), 21);
    shujuLable.text = @"我的数据";
    shujuLable.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    [shujuView addSubview:shujuLable];

    /***显示是否有数据没看***/

    looknumberImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(shujuView.frame) - Adaptive(70), (shujuView.bounds.size.height - 20) / 2, Adaptive(30), Adaptive(20))];
    looknumberImageView.layer.cornerRadius = 4;
    looknumberImageView.layer.masksToBounds = YES;
    looknumberImageView.backgroundColor = [UIColor orangeColor];

    looknumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Adaptive(30), Adaptive(20))];
    looknumberLabel.text = @"2";
    looknumberLabel.textColor = [UIColor whiteColor];
    looknumberLabel.textAlignment = 1;
    looknumberLabel.font = [UIFont fontWithName:FONT size:Adaptive(14)];
    [looknumberImageView addSubview:looknumberLabel];

    /*******************/
    UIImageView* fabuView = (UIImageView*)[self.view viewWithTag:45 * 3];
    UILabel* fabuLabel = [UILabel new];
    fabuLabel.textColor = [UIColor whiteColor];
    fabuLabel.frame = CGRectMake(Adaptive(13), (fabuView.bounds.size.height - Adaptive(21)) / 2, Adaptive(80), Adaptive(21));
    fabuLabel.text = @"我的发布";
    fabuLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    [fabuView addSubview:fabuLabel];

    UIImageView* sifagnqianView = (UIImageView*)[self.view viewWithTag:45 * 4];
    UILabel* sifangqianLabel = [UILabel new];
    sifangqianLabel.textColor = [UIColor whiteColor];
    sifangqianLabel.frame = CGRectMake(Adaptive(13), (sifagnqianView.bounds.size.height - Adaptive(21)) / 2, Adaptive(80), Adaptive(21));
    sifangqianLabel.text = @"私房钱";
    sifangqianLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    [sifagnqianView addSubview:sifangqianLabel];

    UIImageView* vipView = (UIImageView*)[self.view viewWithTag:45 * 5];
    UILabel* vioLabel = [UILabel new];
    vioLabel.textColor = [UIColor whiteColor];
    vioLabel.frame = CGRectMake(Adaptive(13), (vipView.bounds.size.height - Adaptive(21)) / 2, Adaptive(80), Adaptive(21));
    vioLabel.text = @"VIP";
    vioLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    [vipView addSubview:vioLabel];

    viplabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - Adaptive(80) - Adaptive(10), (vipView.bounds.size.height - Adaptive(21)) / 2, Adaptive(80), Adaptive(21))];
    viplabel.text = @"已是Vip会员";
    viplabel.textAlignment = 0;
    viplabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    viplabel.textColor = [UIColor grayColor];

    /*****************功能区--按钮******************/
    UIButton* fenxiangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fenxiangButton.frame = CGRectMake(0, 0, shareView.bounds.size.width, shareView.bounds.size.height);
    [fenxiangButton addTarget:self action:@selector(fenxiangButton) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:fenxiangButton];

    UIButton* shujuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    shujuButton.frame = CGRectMake(0, 0, shujuView.bounds.size.width, shujuView.bounds.size.height);
    [shujuButton addTarget:self action:@selector(yonghufankui) forControlEvents:UIControlEventTouchUpInside];
    [shujuView addSubview:shujuButton];

    UIButton* fabuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fabuButton.frame = CGRectMake(0, 0, fabuView.bounds.size.width, fabuView.bounds.size.height);
    [fabuButton addTarget:self action:@selector(wodefabu) forControlEvents:UIControlEventTouchUpInside];
    [fabuView addSubview:fabuButton];

    UIButton* sifangqian = [UIButton buttonWithType:UIButtonTypeCustom];
    sifangqian.frame = CGRectMake(0, 0, sifagnqianView.bounds.size.width, sifagnqianView.bounds.size.height);
    [sifangqian addTarget:self action:@selector(sifangqian:) forControlEvents:UIControlEventTouchUpInside];
    [sifagnqianView addSubview:sifangqian];
    //

    UIButton* VipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    VipButton.frame = CGRectMake(0, 0, vipView.bounds.size.width, vipView.bounds.size.height);
    [VipButton addTarget:self action:@selector(VIP:) forControlEvents:UIControlEventTouchUpInside];
    [vipView addSubview:VipButton];
}
- (void)VIP:(UIButton*)button
{
    VIPViewController* vip = [VIPViewController new];
    [self.navigationController pushViewController:vip animated:YES];
}
- (void)sifangqian:(UIButton*)button
{
    MoneyViewController* money = [MoneyViewController new];
    [self.navigationController pushViewController:money animated:YES];
}
#pragma mark 更换背景图片
- (void)changebaseView
{
    changesheet.tag = 888;
    [changesheet showInView:self.view];
}
#pragma mark 更换头像
- (void)upLoadImageIcon
{
    changesheet.tag = 777;
    [changesheet showInView:self.view];
}
- (void)setPersonButton
{
    amentViewController* ament = [amentViewController new];
    ament.baseImageStr = headbaseImageString;
    [self.navigationController pushViewController:ament animated:YES];
}
- (void)amentButton
{
    SETViewController* set = [SETViewController new];
    [self.navigationController pushViewController:set animated:YES];
}
- (void)wodefabu
{
    GBViewController* gdVC = [GBViewController new];
    gdVC.isMy = @"999";
    [self.navigationController pushViewController:gdVC animated:YES];
}
- (void)fenxiangButton
{

    /*	@param 	content 	分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
     *	@param 	defaultContent 	默认分享内容（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、有道云笔记、facebook、twitter、邮件、打印、短信、微信、QQ、拷贝）
     *	@param 	image 	分享图片（新浪、腾讯、网易、搜狐、豆瓣、人人、开心、facebook、twitter、邮件、打印、微信、QQ、拷贝、短信）
     *	@param 	title 	标题（QQ空间、人人、微信、QQ）
     *	@param 	url 	链接（QQ空间、人人、instapaper、微信、QQ）
     *	@param 	description 	主体内容（人人）
     *	@param 	mediaType 	分享类型（QQ、微信）
     *	@param 	locationCoordinate 	地理位置 (新浪、腾讯、Twitter)
     */

    NSString* imagePath = [[NSBundle mainBundle] pathForResource:@"logo" ofType:@"png"];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"http://itunes.apple.com/cn/app/guo-dong/id998425416?l=en&mt=8" //分享内容
                                       defaultContent:nil //默认分享内容
                                                image:[ShareSDK imageWithPath:imagePath] //分享图片
                                                title:@"果动网络" //标题
                                                  url:XiaZaiConnent //链接
                                          description:nil //主体内容
                                            mediaType:SSPublishContentMediaTypeNews]; //分享类型

    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    /*container 	用于显示分享界面的容器，如果只显示在iPhone客户端可以传入nil。如果需要在iPad上显示需要指定容器。
     *	@param 	shareList 	平台类型列表
     *	@param 	content 	分享内容
     *  @param  statusBarTips   状态栏提示标识：YES：显示； NO：隐藏
     *  @param  authOptions 授权选项，用于指定接口在需要授权时的一些属性（如：是否自动授权，授权视图样式等），默认可传入nil
     *  @param  shareOptions    分享选项，用于定义分享视图部分属性（如：标题、一键分享列表、功能按钮等）,默认可传入nil
     *  @param  targets         自定义标识集合，设置自定义标识可以在管理后台查看相关标识的分享统计数据
     *  @param  result  分享返回事件处理*/

    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {

                                if (state == SSResponseStateBegan) {

                                    NSString* url = [NSString stringWithFormat:@"%@api/?method=user.share", BASEURL];
                                    NSDate* date = [NSDate date];
                                    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                                    [formatter setDateFormat:@"yyyy年MM月dd日 HH时mm分ss秒"];

                                    NSString* string = [formatter stringFromDate:date];
                                    NSDate* date1 = [formatter dateFromString:string];
                                    NSString* timeSp = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];

                                    NSDictionary* dict = @{ @"platform" : @"wx",
                                        @"date" : timeSp };
                                    [HttpTool postWithUrl:url params:dict contentType:CONTENTTYPE success:^(id responseObject) {
                                        if (ResponseObject_RC == 0) {
                                            NSDictionary* data = [responseObject objectForKey:@"data"];
                                            if (data) {
                                                NSString* info = [data objectForKey:@"info"];
                                                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:info delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];

                                                [alert show];
                                            }
                                        }
                                        else {
                                            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
                                        }
                                    }
                                        fail:^(NSError* error){
                                        }];
                                }
                                else if (state == SSResponseStateFail) {
                                    NSLog(@"发布失败!error code == %ld, error code == %@", (long)[error errorCode], [error errorDescription]);
                                }
                            }];
}

- (void)yonghufankui
{
    MyExercise* exercise = [MyExercise new];
    [self.navigationController pushViewController:exercise animated:YES];
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
    [self presentViewController:imagePickerController animated:YES completion:nil];
    pickertag = (int)actionSheet.tag;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    [self.view endEditing:YES];
}

#pragma mark - UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info

{
    [picker dismissViewControllerAnimated:YES completion:nil];

    NSLog(@"PICKTAG  %d", pickertag);

    if (pickertag == 777) {
        NSString* url = [NSString stringWithFormat:@"%@api/?method=user.set_headimg", BASEURL];

        [HttpTool uploadImageWithUrl:url image:info[UIImagePickerControllerEditedImage] completion:^(id responseObject) {

            _iconImageView.image = info[UIImagePickerControllerEditedImage];

        }
            errorBlock:^(NSError* error){
            }];
    }
    else {
        NSLog(@"自己穿了图片");
        NSString* url = [NSString stringWithFormat:@"%@api/?method=user.set_background", BASEURL];
        [HttpTool uploadImageWithUrl:url image:info[UIImagePickerControllerEditedImage] completion:^(id responseObject) {

            headbaseView.image = info[UIImagePickerControllerEditedImage];

        }
            errorBlock:^(NSError* error){
            }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    // 只要偏移量有改变  就会调用
    NSLog(@"succImage %d", succImage);
    if (succImage == YES) {

        if ((scrollView.contentOffset.y >= 110 || scrollView.contentOffset.y <= -120) && !magnify) {
            NSLog(@"放大之前 %d", magnify);
            [SJAvatarBrowser showImage:headbaseView];
            magnify = YES;
        }
        if (scrollView.contentOffset.y == 0 || scrollView.contentOffset.y == .5) {
            magnify = NO;
        }
    }
}

+ (instancetype)sharedViewControllerManager
{
    static dispatch_once_t onceToken;
    static PersonalCenterController* viewController;

    dispatch_once(&onceToken, ^{
        viewController = [[PersonalCenterController alloc] init];
    });

    return viewController;
}
@end
