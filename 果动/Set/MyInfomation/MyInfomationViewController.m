//
//  MyInfomationViewController.m
//  果动
//
//  Created by mac on 16/5/24.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "AppDelegate.h"
#import "MyInfomationViewController.h"
#import "AddressView.h"
#import "LoginViewController.h"
#import "InformationModel.h"
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>

@interface MyInfomationViewController ()<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate,CLLocationManagerDelegate,UITextFieldDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager; // 位置管理器
@property (strong, nonatomic) CLGeocoder        *geoCoder;        // 地理编码器

@end

@implementation MyInfomationViewController
{
    UIImageView  *headImageView;
    UITextField  *nameTextField;
    UILabel      *sexLabel;
    NSString     *sexNumber;
    UIView       *birthdayView;
    UILabel      *birthdayLabel;
    UIDatePicker *birthdayPicker;
    UILabel      *cityLabel;
    NSString     *birthdayTimeString;
    AddressView  *address;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    birthdayTimeString = @"";
    sexNumber          = @"1";
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    
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
    titleLabel.text      = @"个人资料";
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
    
    
    UIButton * saveButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(viewWidth - Adaptive(53),
                                  Adaptive(20)+(navigationHight - Adaptive(20)) / 2,
                                  Adaptive(40),
                                  Adaptive(20));
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [navigationView addSubview:saveButton];
    
    
    if ([HttpTool judgeWhetherUserLogin]) {
        [self createUI];
        [self startRequest];
        [saveButton setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
        saveButton.userInteractionEnabled = YES;
    } else {
        [saveButton setTitleColor:UIColorFromRGB(0x7f7f7f) forState:UIControlStateNormal];
        saveButton.userInteractionEnabled = NO;
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

- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.get_userinfo",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        InformationModel *information = [[InformationModel alloc] initWithDictionary:[responseObject objectForKey:@"data"]];
        [headImageView sd_setImageWithURL:[NSURL URLWithString:information.headImgUrl] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
        nameTextField.text = information.nickName;
        sexLabel.text      = information.sex;
        birthdayLabel.text = information.birthday;
        
        NSDictionary *BMIDcit = @{@"height":information.height ,
                                  @"weight":information.weight};
        NSNotification *BMINotification = [NSNotification notificationWithName:@"BMI" object:nil userInfo:BMIDcit];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:BMINotification];
    }];
}


- (void)createUI {
    
    for (int a = 0; a < 5; a++) {
        UIView *backgroundView         = [UIView new];
        backgroundView.backgroundColor = [UIColor blackColor];
        backgroundView.frame           = CGRectMake(Adaptive(13),
                                                    NavigationBar_Height + Adaptive(10) + a*Adaptive(53),
                                                    viewWidth - Adaptive(26),
                                                    Adaptive(43));
        [self.view addSubview:backgroundView];
        UIView *baseView = [UIView new];
        baseView.frame   = CGRectMake(.5,
                                      .5,
                                      backgroundView.bounds.size.width - 1,
                                      backgroundView.bounds.size.height - 1);
        baseView.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
        [backgroundView addSubview:baseView];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame     = CGRectMake(0, 0, baseView.bounds.size.width, baseView.bounds.size.height);
        button.tag       = a + 1;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [baseView addSubview:button];
        
        if (a == 0) {
            
            
            backgroundView.frame  = CGRectMake(Adaptive(34.5),
                                                        Adaptive(10) + NavigationBar_Height,
                                                        viewWidth - Adaptive(47.5),
                                                        Adaptive(43));
            
            baseView.frame   = CGRectMake(.5,
                                          .5,
                                          backgroundView.bounds.size.width - 1,
                                          backgroundView.bounds.size.height - 1);
            
            headImageView       = [UIImageView new];
            headImageView.frame = CGRectMake(Adaptive(13.5),
                                             Adaptive(10) + NavigationBar_Height,
                                             Adaptive(43),
                                             Adaptive(42));
            headImageView.layer.cornerRadius  = headImageView.bounds.size.width / 2;
            headImageView.layer.masksToBounds = YES;
            [self.view addSubview:headImageView];
            
            UILabel *label = [UILabel new];
            label.frame    = CGRectMake(Adaptive(36.5),
                                        (Adaptive(45) - Adaptive(14)) / 2,
                                        Adaptive(60),
                                        Adaptive(14));
            label.textColor = [UIColor grayColor];
            label.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
            label.text      = @"更换头像";
            [baseView addSubview:label];
            
        } else {
            
            NSArray *array = @[@"昵称",@"性别",@"出生日月",@"所在城市"];
            UILabel *label = [UILabel new];
            label.frame    = CGRectMake(Adaptive(13),
                                        (Adaptive(45) - Adaptive(14)) / 2,
                                        Adaptive(60),
                                        Adaptive(14));
            label.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
            label.textColor = [UIColor whiteColor];
            label.text      = array[a - 1];
            [baseView addSubview:label];
            
            switch (a) {
                case 1:
                {
                    // 呢称
                    nameTextField       = [UITextField new];
                    nameTextField.frame = CGRectMake(Adaptive(58),
                                                     Adaptive(3),
                                                     baseView.bounds.size.width - Adaptive(36.5),
                                                     baseView.bounds.size.height);
                    nameTextField.font  = [UIFont fontWithName:FONT size:Adaptive(12)];
                    nameTextField.textColor   = [UIColor grayColor];
                    nameTextField.delegate = self;
                    nameTextField.placeholder = @"请输入您的呢称";
                    [nameTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
                    [baseView addSubview:nameTextField];
                }
                    break;
                case 2:
                {
                    // 性别
                    sexLabel       = [UILabel new];
                    sexLabel.frame = CGRectMake(Adaptive(58),
                                                (Adaptive(45) - Adaptive(14)) / 2,
                                                baseView.bounds.size.width - Adaptive(58),
                                                Adaptive(14));
                    sexLabel.textColor = [UIColor grayColor];
                    sexLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
                    sexLabel.text      = @"请选择您的性别";
                    [baseView addSubview:sexLabel];
                }
                    break;
                case 3:
                {
                    //出生年月
                    birthdayLabel       = [UILabel new];
                    birthdayLabel.frame = CGRectMake(CGRectGetMaxX(label.frame) + Adaptive(10),
                                                     (Adaptive(45) - Adaptive(14)) / 2,
                                                     baseView.bounds.size.width - Adaptive(58),
                                                     Adaptive(14));
                    birthdayLabel.textColor = [UIColor grayColor];
                    birthdayLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
                    birthdayLabel.text      = @"未添加";
                    [baseView addSubview:birthdayLabel];
                }
                    break;
                case 4:
                {
                    //所在城市
                    cityLabel       = [UILabel new];
                    cityLabel.frame = CGRectMake(CGRectGetMaxX(label.frame) + Adaptive(10),
                                                 (Adaptive(45) - Adaptive(14)) / 2,
                                                 baseView.bounds.size.width - Adaptive(58),
                                                 Adaptive(14));
                    cityLabel.textColor = [UIColor grayColor];
                    cityLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
                    cityLabel.text      = @"定位中";
                    [baseView addSubview:cityLabel];
                    
                    // 开始定位
                    [self startLocation];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    UIView *addressbackgroundView = [UIView new];
    addressbackgroundView.frame   = CGRectMake(Adaptive(13),
                                               NavigationBar_Height + Adaptive(53) * 5 + Adaptive(10),
                                               viewWidth - Adaptive(26),
                                               Adaptive(270));
    addressbackgroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:addressbackgroundView];
    
    
    address = [AddressView new];
    address.frame        = CGRectMake(.5,
                                      .5,
                                      addressbackgroundView.bounds.size.width - 1,
                                      addressbackgroundView.bounds.size.height - 1);
    [addressbackgroundView addSubview:address];
    
}

#pragma mark - 各个功能触发按钮
- (void)buttonClick:(UIButton *)button {
    
    UIButton *birthdayButton = (UIButton *)[self.view viewWithTag:4];
    birthdayButton.userInteractionEnabled = YES;
    [birthdayView removeFromSuperview];
    
    switch (button.tag) {
        case 1:
        {
            
            [self addHeadChooseView];
        }
            break;
        case 3:
        {
            
            [self addSexChooseView];
        }
            break;
        case 4:
        {
            [self addBirthdayChooseView];
        }
            break;
            
        default:
            break;
    }
}
// 添加头像选择器
- (void)addHeadChooseView {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册获取",@"拍照", nil];
    actionSheet.tag = 100;
    [actionSheet showInView:self.view];
    
}

// 添加性别选择器
- (void)addSexChooseView {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    actionSheet.tag = 200;
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 100:
        {
            // 头像
            if (buttonIndex == 2)
                return;
            UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
            // 1.设置照片源
            if (buttonIndex == 1) {
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
        }
            break;
        case 200:
        {
            // 性别
            switch (buttonIndex) {
                case 0:
                    sexLabel.text = @"男";
                    sexNumber     = @"1";
                    break;
                case 1:
                    sexLabel.text = @"女";
                    sexNumber     = @"2";
                    break;
                case 2:
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}
#pragma mark - UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString* url = [NSString stringWithFormat:@"%@api/?method=user.set_headimg", BASEURL];
    NSData *data  = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], 1);
    
    [HttpTool postWithUrl:url params:nil body:@[@{@"myfiles":data}] progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        headImageView.image = info[UIImagePickerControllerEditedImage];
    }];
}

// 添加出生年月选择器
- (void)addBirthdayChooseView {
    
    UIButton *button = (UIButton *)[self.view viewWithTag:4];
    button.userInteractionEnabled = NO;
    
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    birthdayView         = [UIView new];
    birthdayView.frame   = CGRectMake(0,
                                      viewHeight - Adaptive(256),
                                      viewWidth,
                                      Adaptive(256));
    birthdayView.backgroundColor = [UIColor grayColor];
    [app.window addSubview:birthdayView];
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame     = CGRectMake(0, 0, viewWidth, Adaptive(40));
    sureButton.backgroundColor  = ORANGECOLOR;
    sureButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [sureButton setTintColor:[UIColor whiteColor]];
    [sureButton setTitle:@"完成" forState:UIControlStateNormal];
    [sureButton addTarget:self action:@selector(sureBirthdayClick:) forControlEvents:UIControlEventTouchUpInside];
    [birthdayView addSubview:sureButton];
    
    birthdayPicker       = [UIDatePicker new];
    birthdayPicker.frame = CGRectMake(0, CGRectGetMaxY(sureButton.frame), viewWidth, Adaptive(216));
    birthdayPicker.backgroundColor = [UIColor whiteColor];
    birthdayPicker.datePickerMode  = UIDatePickerModeDate;
    [birthdayView addSubview:birthdayPicker];
    
    
}

- (void)sureBirthdayClick:(UIButton *)button {
    
    UIButton *birthdayButton = (UIButton *)[self.view viewWithTag:4];
    birthdayButton.userInteractionEnabled = YES;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    NSString* dateString = [formatter stringFromDate:birthdayPicker.date];
    birthdayLabel.text = dateString;
    
    birthdayTimeString = [NSString stringWithFormat:@"%ld", (long)[birthdayPicker.date timeIntervalSince1970]];
    [birthdayView removeFromSuperview];
}


// 开始定位
- (void)startLocation {
    //定位管理器
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    if (!_geoCoder) {
        //创建并初始化编码器
        _geoCoder = [[CLGeocoder alloc] init];
    }
    //设置代理
    _locationManager.delegate = self;
    //设置定位精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    //多少米定位一次
    _locationManager.distanceFilter = 10.0;
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
    
}
#pragma mark - CoreLocation
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations {
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
    CLLocation* location = [locations firstObject]; //取出第一个位置
    
    NSString *urlString  = [NSString stringWithFormat:@"%@geocoding/", BASEURL];
    NSDictionary *locationDict = @{ @"lnt" : [NSString stringWithFormat:@"%f", location.coordinate.longitude],@"lat" : [NSString stringWithFormat:@"%f", location.coordinate.latitude]};
    
    
    [HttpTool postWithUrl:urlString params:locationDict body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSString *city = [[responseObject objectForKey:@"city"] objectForKey:@"name"];
        if (city) {
            cityLabel.text = city;
        }
    }];
}

- (void)cancelButtonClick:(UIButton *)button {
    [self.view endEditing:YES];
    [address endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveButtonClick:(UIButton *)button {
    
    NSString *heightString = @"";
    NSString *weightString = @"";
    if (address.heightTextField.text.length > 2) {
        heightString = [address.heightTextField.text substringToIndex:address.heightTextField.text.length - 2];
    }
    if (address.weightTextField.text.length > 2) {
        weightString = [address.weightTextField.text substringToIndex:address.weightTextField.text.length - 2];
    }
    
    
    NSString *url          = [NSString stringWithFormat:@"%@api/?method=user.set_userinfo",BASEURL];
    NSDictionary *infodict = @{@"nickname":nameTextField.text,
                               @"gender":sexNumber,
                               @"birthday":birthdayTimeString,
                               @"height":heightString,
                               @"weight":weightString};
    
    [HttpTool postWithUrl:url params:infodict body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:.5f
                                         target:self
                                       selector:@selector(timerFireMethod:)
                                       userInfo:alert
                                        repeats:YES];
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [birthdayView removeFromSuperview];
    UIButton *headButton     = (UIButton *)[self.view viewWithTag:1];
    UIButton *sexButton      = (UIButton *)[self.view viewWithTag:3];
    UIButton *birthdayButton = (UIButton *)[self.view viewWithTag:4];
    headButton.userInteractionEnabled     = NO;
    sexButton.userInteractionEnabled      = NO;
    birthdayButton.userInteractionEnabled = NO;
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    UIButton *headButton     = (UIButton *)[self.view viewWithTag:1];
    UIButton *sexButton      = (UIButton *)[self.view viewWithTag:3];
    UIButton *birthdayButton = (UIButton *)[self.view viewWithTag:4];
    headButton.userInteractionEnabled     = YES;
    sexButton.userInteractionEnabled      = YES;
    birthdayButton.userInteractionEnabled = YES;
}

// 提示框消失
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
