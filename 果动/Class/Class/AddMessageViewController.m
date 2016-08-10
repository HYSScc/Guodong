//
//  AddMessageViewController.m
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "AddMessageViewController.h"
#import "AddMessageView.h"
#import "addMessageModel.h"
#import "SHPickerView.h"
#import "ChangeAddressView.h"
#import "AppDelegate.h"
#import "addMessageCourse.h"
#import "PayViewController.h"
@interface AddMessageViewController ()<UITextFieldDelegate,UIAlertViewDelegate>

@end

@implementation AddMessageViewController
{
    
    CGFloat           offset;
    CGFloat           textHeight;
    ChangeAddressView *changeAddressView;
    NSString          *Func_id;
    NSString          *nowClassNumber;
    addMessageModel   *messageModel;
    BOOL               changeTime;
    NSDictionary       *freeDict;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    // 视图移除时  将更多地址View从window移除
    [changeAddressView removeFromSuperview];
    
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden           = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASEGRYCOLOR;
    changeTime  = YES;
   
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:_className viewController:self];
    [self.view addSubview:navigation];
    
    [self startRequest];
    
    // [self requestClassNumber];
    // 手势结束编辑
    UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit:)];
    [self.view addGestureRecognizer:tapLeftDouble];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAddressFrameTable:) name:@"changeAddress" object:nil];
}



- (void)changeAddressFrameTable:(NSNotification *)cation {
    
    AddMessageView *addressView = (AddMessageView *)[self.view viewWithTag:1];
    addressView.messageLabel.text = [cation.userInfo objectForKey:@"address"];
    CGSize textSize = [addressView.messageLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]}];
    
    addressView.messageLabel.textAlignment = 2;
    
    if (textSize.width > addressView.messageLabel.bounds.size.width) {
        addressView.messageLabel.textAlignment = 0;
    }
    self.view.transform = CGAffineTransformIdentity;
    [changeAddressView removeFromSuperview];
    
}

- (void)startRequest {
    
    NSString *url;
    if ([_classOrShip isEqualToString:@"class"]) {
        url = [NSString stringWithFormat:@"%@api/?method=gdcourse.course&class_id=%@&types=1",BASEURL,_class_id];
    } else {
        url = [NSString stringWithFormat:@"%@api/?method=gdcourse.course&class_id=%@&types=2",BASEURL,_class_id];
    }
    
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        messageModel = [[addMessageModel alloc] initWithDictionary:[responseObject objectForKey:@"data"]];
        nowClassNumber = messageModel.package_balance;
        freeDict       = messageModel.isHaveFree;
        [self createUI];
    }];
}


- (void)createUI {
    
    UIImageView *topImageView = [UIImageView new];
    topImageView.frame        = CGRectMake(0, NavigationBar_Height, viewWidth, messageModel.topImageHeight / 2);
    [topImageView sd_setImageWithURL:[NSURL URLWithString:messageModel.topImageUrl]];
    [self.view addSubview:topImageView];
    
    UIImageView *iconImageView = [UIImageView new];
    
    if ([_classOrShip isEqualToString:@"class"]) {
        iconImageView.frame = CGRectMake((viewWidth - (messageModel.iconWidth / 2)) / 2,
                                         (messageModel.topImageHeight / 2 - (messageModel.iconHeight / 2)) / 2,
                                         messageModel.iconWidth / 2,
                                         messageModel.iconHeight / 2);
    } else {
        iconImageView.frame = CGRectMake((viewWidth - (messageModel.iconWidth / 2)) / 2,
                                         (messageModel.topImageHeight / 2 - (messageModel.iconHeight / 2)) / 3,
                                         messageModel.iconWidth / 2,
                                         messageModel.iconHeight / 2);
    }
    
    
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:messageModel.iconImageUrl]];
    [topImageView addSubview:iconImageView];
    
    
    UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame     = CGRectMake(0, viewHeight  - Adaptive(50), viewWidth, Adaptive(50));
    sureButton.backgroundColor = ORANGECOLOR;
    sureButton.titleLabel.font = [UIFont fontWithName:FONT_BOLD size:Adaptive(15)];
    [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setTitleColor:BASECOLOR forState:UIControlStateNormal];
    [sureButton setTitle:@"下 单" forState:UIControlStateNormal];
    [self.view addSubview:sureButton];
    
    
    NSArray *messageArray;
    if ([_classOrShip isEqualToString:@"class"]) {
        messageArray = @[@{@"title":@"地址",@"type":@"tian"},
                         @{@"title":@"时间",@"type":@"xuan"},
                         @{@"title":@"日期",@"type":@"xuan"},
                         @{@"title":@"电话",@"type":@"tian"},
                         @{@"title":@"姓名",@"type":@"tian"}];
    } else {
        messageArray = @[@{@"title":@"地址",@"type":@"tian"},
                         @{@"title":@"时间",@"type":@"xuan"},
                         @{@"title":@"日期",@"type":@"xuan"},
                         @{@"title":@"电话",@"type":@"tian"},
                         @{@"title":@"姓名",@"type":@"tian"},
                         @{@"title":@"课程",@"type":@"xuan"}];
    }
    
    for (int a = 0; a < messageArray.count; a++) {
        AddMessageView  *addMessageView = [[AddMessageView alloc] initWithFrame:CGRectMake(0,
                                                                                           CGRectGetMinY(sureButton.frame) - Adaptive(50) * (a + 1),
                                                                                           viewWidth,
                                                                                           Adaptive(50))
                                                                     dictionary:messageArray[a]];
        addMessageView.tag = a + 1;
        [addMessageView.messageButton addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        addMessageView.textField.delegate = self;
        [self.view addSubview:addMessageView];
        
        // 设置phoneTextField 的键盘样式 和 号码
        if (a == 3) {
            addMessageView.textField.keyboardType = UIKeyboardTypePhonePad;
            
            if (![_isChange isEqualToString:@"change"]) {
                addMessageView.textField.text    = messageModel.user_phone;
            }
        }
        
        // 设置更多地址的按钮
        if (a == 0) {
            if ([_classOrShip isEqualToString:@"shop"]) {
                
                addMessageView.textField.userInteractionEnabled = NO;
                addMessageView.messageLabel.text = @"建国路华贸公寓5号楼607";
                
            } else {
                if (![_isChange isEqualToString:@"change"]) {
                    addMessageView.messageLabel.text = messageModel.user_address;
                }
                
                CGSize textSize = [addMessageView.messageLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]}];
                
                if (textSize.width > addMessageView.messageLabel.bounds.size.width) {
                    addMessageView.messageLabel.textAlignment = 0;
                }
                
                UIButton *changeAddressButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                changeAddressButton.frame     = CGRectMake(viewWidth - Adaptive(18),
                                                           Adaptive(17),
                                                           Adaptive(16),
                                                           Adaptive(16));
                [changeAddressButton setBackgroundImage:[UIImage imageNamed:@"class_moreAddress"] forState:UIControlStateNormal];
                [changeAddressButton addTarget:self action:@selector(changeAddressButton:) forControlEvents:UIControlEventTouchUpInside];
                [addMessageView addSubview:changeAddressButton];
            }
            
            
            
        }
        // 获取用户姓名
        if (a == 4) {
            if (![_isChange isEqualToString:@"change"]) {
                addMessageView.textField.text = messageModel.user_name;
            }
        }
    }
    
    if ([_isChange isEqualToString:@"change"]) {
        AddMessageView *addressView = (AddMessageView *)[self.view viewWithTag:1];
        AddMessageView *timeView    = (AddMessageView *)[self.view viewWithTag:2];
        AddMessageView *dateView    = (AddMessageView *)[self.view viewWithTag:3];
        AddMessageView *photoView   = (AddMessageView *)[self.view viewWithTag:4];
        AddMessageView *nameView    = (AddMessageView *)[self.view viewWithTag:5];
        AddMessageView *classView   = (AddMessageView *)[self.view viewWithTag:6];
        addressView.messageLabel.text = _address;
        timeView.messageLabel.text  = _time;
        dateView.messageLabel.text  = _date;
        photoView.textField.text    = _phoneNumber;
        nameView.textField.text     = _name;
        classView.messageLabel.text = _className;
        addMessageCourse *courese = messageModel.courseArray[0];
        Func_id = courese.func_id;
    }
}
#pragma mark - 添加更多地址
- (void)changeAddressButton:(UIButton *)button {
    
    // 弹出更多地址时 地址输入框结束编辑
    AddMessageView *addressView = (AddMessageView *)[self.view viewWithTag:1];
    [addressView.textField resignFirstResponder];
    
    // 时间、日期按钮不允许点击
    AddMessageView *timeView    = (AddMessageView *)[self.view viewWithTag:2];
    AddMessageView *dateView    = (AddMessageView *)[self.view viewWithTag:3];
    timeView.userInteractionEnabled = NO;
    dateView.userInteractionEnabled = NO;
    
    // 每次先移除再添加
    [changeAddressView removeFromSuperview];
    
    changeAddressView = [[ChangeAddressView alloc] initWithFrame:CGRectMake(0, viewHeight - Adaptive(166), viewWidth, Adaptive(166))];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    [UIView animateWithDuration:.2f animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, -Adaptive(116));
        [app.window addSubview:changeAddressView];
        
    }];
}

- (void)messageButtonClick:(UIButton *)button {
    
    [UIView animateWithDuration:.2f animations:^{
        
    } completion:^(BOOL finished) {
        CGRect frame = CGRectMake(0,
                                  viewHeight - Adaptive(256),
                                  viewWidth,
                                  Adaptive(256));
        SHPickerView *pickerView;
        switch (button.superview.tag) {
            case 3:
            {
                // 日期
                pickerView = [[SHPickerView alloc] initWithFrame:frame tag:button.superview.tag*10 pickerType:@"date" pickerArray:nil];
            }
                break;
            case 2:
            {
                // 时间
                if (!changeTime) {
                    // 不需要更改时间
                    pickerView = [[SHPickerView alloc] initWithFrame:frame tag:button.superview.tag*10 pickerType:@"picker" pickerArray:messageModel.timeArray];
                } else {
                    // 更改时间
                    NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
                    [df setDateFormat:@"HH:mm"];
                    
                    // 当前时间往后两小时
                    // 区分到店还是上门  上门不需要延后两小时
                    
                    NSDate *date;
                    
                    if ([_classOrShip isEqualToString:@"shop"]) {
                        // 到店
                        date = [[NSDate alloc] initWithTimeInterval:0 sinceDate:[NSDate date]];
                    } else {
                        // 上门
                        date = [[NSDate alloc] initWithTimeInterval:7200 sinceDate:[NSDate date]];
                    }
                    
                    NSString *dateString       = [df stringFromDate:date];
                    NSString *dateChangeString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"."];
                    
                    NSMutableArray *changeTimeArray = [NSMutableArray array];
                    
                    for (NSString *string in messageModel.timeArray)
                    {
                        NSString *arrayString  = [string substringToIndex:5];
                        NSString *changeString = [arrayString stringByReplacingOccurrencesOfString:@":" withString:@"."];
                        
                        if ([changeString floatValue]  > [dateChangeString floatValue] )
                        {
                            [changeTimeArray addObject:string];
                        }
                    }
                    
                    if (changeTimeArray.count != 0) {
                      //  [changeTimeArray removeAllObjects];
                        pickerView = [[SHPickerView alloc] initWithFrame:frame tag:button.superview.tag*10 pickerType:@"picker" pickerArray:changeTimeArray];
                    } else {
                        // 时间过晚  提醒订第二天课程
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"时间太晚了" message:@"当前没有空闲的教练,请更改订课日期" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
                        [alert show];
                        [NSTimer scheduledTimerWithTimeInterval:2.0f
                                                         target:self
                                                       selector:@selector(timerFire:)
                                                       userInfo:alert
                                                        repeats:NO];
                    }
                }
            }
                break;
            case 6:
            {
                // 课程
                pickerView = [[SHPickerView alloc] initWithFrame:frame tag:button.superview.tag*10 pickerType:@"class" pickerArray:messageModel.courseArray];
            }
                break;
                
            default:
                break;
        }
        [pickerView.button addTarget:self action:@selector(pickerViewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:pickerView];

    }];
   
}

#pragma mark - picker完成按钮点击事件
- (void)pickerViewButtonClick:(UIButton *)button {
    
    
    AddMessageView *addMessageView   = (AddMessageView *)[self.view viewWithTag:button.tag / 100];
    SHPickerView   *pickerView       = (SHPickerView *)[self.view viewWithTag:button.tag / 10];
    addMessageView.messageLabel.text = [pickerView changeReturnString];
    
   
    
    if (button.tag == 600) {
        Func_id = [pickerView changeReturnFunc_id];
        if ([_classOrShip isEqualToString:@"shop"]) {
            _className = [pickerView changeReturnString];
        }
        
    }
    
    if (button.tag == 300) {
        
        NSDateFormatter*df = [[NSDateFormatter alloc]init];//格式化
        
        [df setDateFormat:@"yyyy年MM月dd日"];
        
        NSString* dateString = [df stringFromDate:[NSDate date]];
        
        if (![dateString isEqualToString:addMessageView.messageLabel.text]) {
            changeTime = NO;
        }
    }
    
    [pickerView removeFromSuperview];
}

#pragma mark - 下单按钮点击事件
- (void)sureButtonClick:(UIButton *)button {
    
    /****** 检查所有信息填写完整 ******/
    
    AddMessageView *addressView = (AddMessageView *)[self.view viewWithTag:1];
    AddMessageView *timeView    = (AddMessageView *)[self.view viewWithTag:2];
    AddMessageView *dateView    = (AddMessageView *)[self.view viewWithTag:3];
    AddMessageView *photoView   = (AddMessageView *)[self.view viewWithTag:4];
    AddMessageView *nameView    = (AddMessageView *)[self.view viewWithTag:5];
    AddMessageView *classView   = (AddMessageView *)[self.view viewWithTag:6];
    
    
    
    /*************** 区分到店还是上门 ******************/
    
    
    addMessageCourse *courese = messageModel.courseArray[0];
    
    
    
    if ([_classOrShip isEqualToString:@"class"]) {
        // 上门
        if ([addressView.messageLabel.text length] == 0 ||
            [timeView.messageLabel.text length] == 0 ||
            [dateView.messageLabel.text length] == 0 ||
            [photoView.textField.text   length] == 0 ||
            [nameView.textField.text    length] == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息填写不完整" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f
                                             target:self
                                           selector:@selector(timerFire:)
                                           userInfo:alert
                                            repeats:NO];
            return;
        }
        Func_id = courese.func_id;
    } else {
        // 到店
        
        if ([addressView.messageLabel.text length] == 0 ||
            [timeView.messageLabel.text length]    == 0 ||
            [dateView.messageLabel.text length]    == 0 ||
            [photoView.textField.text   length]    == 0 ||
            [nameView.textField.text    length]    == 0 ||
            [classView.messageLabel.text length]   == 0) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"信息填写不完整" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
            [alert show];
            [NSTimer scheduledTimerWithTimeInterval:1.5f
                                             target:self
                                           selector:@selector(timerFire:)
                                           userInfo:alert
                                            repeats:NO];
            return;
        }
    }
    
    
    /******* 正则检查电话号码 ******/
    
    BOOL photo = [AddMessageViewController isValidateTelNumber:photoView.textField.text];
    if (!photo) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"电话号码输入有误" delegate:nil cancelButtonTitle:nil otherButtonTitles: nil];
        [alert show];
        [NSTimer scheduledTimerWithTimeInterval:1.5f
                                         target:self
                                       selector:@selector(timerFire:)
                                       userInfo:alert
                                        repeats:NO];
        return;
    }
    /*****************************/
    
    
    
    // 有免费券
    
    if ([freeDict count] != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[freeDict objectForKey:@"tips"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认",nil];
       
        [alert show];
    } else {
        // 有套餐课程 并且 没有免费券
        
        if ([nowClassNumber intValue] != 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"预约课程:%@  当前剩余:%@课时",_className,nowClassNumber] delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消",@"确认",nil];
            
            [alert show];
            
        } else{
            // 没有套餐课程 没有免费券  直接请求
            [self requestSuccess];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
     if (buttonIndex == 1) [self requestSuccess];
    
}

- (void)requestSuccess {
    
    
    AddMessageView *addressView = (AddMessageView *)[self.view viewWithTag:1];
    AddMessageView *timeView    = (AddMessageView *)[self.view viewWithTag:2];
    AddMessageView *dateView    = (AddMessageView *)[self.view viewWithTag:3];
    AddMessageView *photoView   = (AddMessageView *)[self.view viewWithTag:4];
    AddMessageView *nameView    = (AddMessageView *)[self.view viewWithTag:5];
    
    NSString *course_type = [_classOrShip isEqualToString:@"class"] ? @"1" : @"2";
    
    addMessageCourse *courese = messageModel.courseArray[0];
    /*****发起请求******/
    
    
    // 封装时间戳
    NSString* timeString = [timeView.messageLabel.text substringToIndex:5];
    
    NSString* string = [NSString stringWithFormat:@"%@ %@:00", dateView.messageLabel.text, timeString];
    
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日HH:mm:ss"];
    NSDate* date1 = [dateFormatter dateFromString:string];
    NSString* timeSp = [NSString stringWithFormat:@"%ld", (long)[date1 timeIntervalSince1970]];
    
    NSString     *url;
    NSDictionary *dict;
    
    
    if ([_isChange isEqualToString:@"change"]) {
        url = [NSString stringWithFormat:@"%@api/?method=gdcourse.modify",BASEURL];
        
        dict        = @{@"func_id":Func_id,
                        @"course_num":@"1",
                        @"course_type":course_type,
                        @"number":photoView.textField.text,
                        @"name":[nameView.textField.text trimString],
                        @"address":addressView.messageLabel.text,
                        @"time":timeSp,
                        @"order_id":_order_id};
    } else {
        url = [NSString stringWithFormat:@"%@api/?method=gdcourse.get_order",BASEURL];
        dict        = @{@"func_id":Func_id,
                        @"course_num":@"1",
                        @"course_type":course_type,
                        @"number":photoView.textField.text,
                        @"name":[nameView.textField.text trimString],
                        @"address":addressView.messageLabel.text,
                        @"time":timeSp};
    }
    
    
    
    [HttpTool postWithUrl:url params:dict body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        
        if ([[[responseObject objectForKey:@"data"] objectForKey:@"order_type"] isEqualToString:@"gd"]) {
            PayViewController *pay = [PayViewController new];
            pay.oneClassPrice = courese.oneClassPrice;
            pay.oneClassTime  = courese.oneClassTime;
            pay.userMoney     = messageModel.user_money;
            pay.packageArray  = messageModel.packageArray;
            pay.iconImageUrl  = messageModel.iconImageUrl;
            pay.iconWidth     = messageModel.iconWidth;
            pay.iconHeight    = messageModel.iconHeight;
            pay.rechargeUrl   = messageModel.rechargeUrl;
            pay.rechargeWidth = messageModel.rechargeWidth;
            pay.rechargeHeight= messageModel.rechargeHeight;
            
            NSDictionary *messageDict = @{@"isChange":@"change",
                                          @"order_id":[NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"order_id"]]};
            
            pay.addressMessageDict = messageDict;
            
            pay.order_id      = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"order_id"]];
            [self.navigationController pushViewController:pay animated:YES];
        } else {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[responseObject objectForKey:@"data"] objectForKey:@"info"] delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
            [alert show];
            
            [NSTimer scheduledTimerWithTimeInterval:1.5f
                                             target:self
                                           selector:@selector(timerFireMethod:)
                                           userInfo:alert
                                            repeats:YES];
        }
    }];
    
}


// 提示框消失  需要返回
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


// 提示框消失 不需要返回
- (void)timerFire:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    
}

//表随键盘高度变化
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY      = keyBoardRect.size.height;
    CGFloat  height     = self.view.frame.size.height  - (offset + textHeight + deltaY);
    if (height <= 0) {
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, height);;
        }];
    }
}
-(void)keyboardHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        
    }];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    offset     = textField.superview.frame.origin.y;
    textHeight = textField.bounds.size.height;
    AddMessageView *timeaddMessageView   = (AddMessageView *)[self.view viewWithTag:2];
    AddMessageView *dateaddMessageView   = (AddMessageView *)[self.view viewWithTag:3];
    timeaddMessageView.userInteractionEnabled = NO;
    dateaddMessageView.userInteractionEnabled = NO;
    
    if (textField.superview.tag == 1) {
        AddMessageView *addressView = (AddMessageView*)textField.superview;
        
        
        textField.text = addressView.messageLabel.text;
        addressView.messageLabel.text = @"";
        
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    AddMessageView *timeaddMessageView   = (AddMessageView *)[self.view viewWithTag:2];
    AddMessageView *dateaddMessageView   = (AddMessageView *)[self.view viewWithTag:3];
    timeaddMessageView.userInteractionEnabled = YES;
    dateaddMessageView.userInteractionEnabled = YES;
    
    if (textField.superview.tag == 1) {
        
        AddMessageView *addressView   = (AddMessageView*)textField.superview;
        addressView.messageLabel.text = textField.text;
        textField.text = @"";
        
        CGSize textSize = [addressView.messageLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]}];
        
        if (textSize.width > addressView.messageLabel.bounds.size.width) {
            addressView.messageLabel.textAlignment = 0;
        }
    }
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [changeAddressView removeFromSuperview];
    AddMessageView *timeaddMessageView   = (AddMessageView *)[self.view viewWithTag:2];
    AddMessageView *dateaddMessageView   = (AddMessageView *)[self.view viewWithTag:3];
    timeaddMessageView.userInteractionEnabled = YES;
    dateaddMessageView.userInteractionEnabled = YES;
    self.view.transform = CGAffineTransformIdentity;
    [self.view endEditing:YES];
}
-(void)endEdit:(UIGestureRecognizer *)gesture
{
    [changeAddressView removeFromSuperview];
    AddMessageView *timeaddMessageView   = (AddMessageView *)[self.view viewWithTag:2];
    AddMessageView *dateaddMessageView   = (AddMessageView *)[self.view viewWithTag:3];
    timeaddMessageView.userInteractionEnabled = YES;
    dateaddMessageView.userInteractionEnabled = YES;
    self.view.transform = CGAffineTransformIdentity;
    [self.view endEditing:YES];
}
//是否是有效的正则表达式
+ (BOOL)isValidateRegularExpression:(NSString*)strDestination byExpression:(NSString*)strExpression
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    return [predicate evaluateWithObject:strDestination];
}
//验证电话号码
+ (BOOL)isValidateTelNumber:(NSString*)number
{
    NSString* strRegex = @"[0-9]{11,11}";
    
    BOOL rt = [self isValidateRegularExpression:number byExpression:strRegex];
    
    return rt;
}
+ (instancetype)sharedViewControllerManager {
    static dispatch_once_t onceToken;
    static AddMessageViewController* viewController;
    
    dispatch_once(&onceToken, ^{
        viewController = [[AddMessageViewController alloc] init];
    });
    
    return viewController;
}


@end
