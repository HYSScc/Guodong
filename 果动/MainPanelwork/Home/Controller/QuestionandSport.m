//
//  QuestionandSport.m
//  果动
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "QuestionandSport.h"
#import "UIView+LQXkeyboard.h"
#import "Commonality.h"
#import "SETViewController.h"
#import "NSString+DocumentPath.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SportsViewController.h"
#import "TCMessage.h"
//检查网络是否连接
#import "Reachability.h"
#import "ChatModel.h"
#import "UUInputFunctionView.h"
#import "UUMessageCell.h"
#import "UUMessage.h"
#import "UUMessageFrame.h"

@interface QuestionandSport ()<UUInputFunctionViewDelegate,UUMessageCellDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AVAudioPlayerDelegate>
{
    UITableView *_tableView;
    UIView *_inputView;
    UITextField *_textField;
    
    NSMutableArray *_bubbleArray;
    int keyBoardHeight;
    //录音
    BOOL musicbtnstatic;
    UIButton *musicButton;
  
    NSDate *date;
    NSString *path;
}

@property (weak, nonatomic)  NSLayoutConstraint *bottomConstraint;
@property (nonatomic,assign) BOOL recording;
@property (nonatomic,strong) NSString *fileName;
@property (nonatomic,strong) AVAudioRecorder *recorder;
@property (nonatomic,strong) AVAudioPlayer *player;

@end

@implementation QuestionandSport
{
    UUInputFunctionView *IFView;
    
}
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//每次进入页面调用连接方法
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    //添加通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardChange:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewScrollToBottom) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(reachabilityChanged:)
     
                                                 name:kReachabilityChangedNotification
     
                                               object:nil];
    
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.guodongwl.com"];
    
    [reach startNotifier];
    
    
    
}
//检测网络是否连接
-(void)reachabilityChanged:(NSNotification *)notification
{
    Reachability *reach = [notification object];
    
    if([reach isKindOfClass:[Reachability class]]){
        
        NetworkStatus status = [reach currentReachabilityStatus];
        
        NSLog(@"status  %ld",(long)status);
        switch (status) {
            case 0:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"网络连接中断" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                
                [alert show];
            }
                break;
                
            default:
                break;
        }
        //Insert your code here
        
    }
}

//退出页面关闭连接
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    NSLog(@"Close Connected");
    // _webSocket.delegate = nil;
    //  [_webSocket close];
    //  _webSocket = nil;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:NULL];
}
#pragma mark - SRWebSocketDelegate



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"问答"];
    UIImageView * lineImage1=[UIImageView new];
    lineImage1.image=[UIImage imageNamed:@"home__line1"];
    lineImage1.frame              = CGRectMake(0, 0, viewWidth, 1);
    [self.view addSubview:lineImage1];
    
    
    
    UIButton *amentButton=[UIButton buttonWithType:UIButtonTypeSystem];
    amentButton.frame = CGRectMake(viewHeight/2.0212, viewHeight/24.7037, viewHeight/22.233, viewHeight/22.233);
    amentButton.titleLabel.font = [UIFont fontWithName:FONT size:13];
    [amentButton setTitle:@"活动" forState:UIControlStateNormal];
    [amentButton addTarget:self action:@selector(amentButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:amentButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    
    
    _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, viewWidth, viewHeight-64-40)];
    _chatTableView.dataSource = self;
    _chatTableView.delegate = self;
    _chatTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _chatTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_chatTableView];
    
    
    [self loadBaseViewsAndData];
    
}
-(void)amentButton
{
    
    SportsViewController *sportsVC = [[SportsViewController alloc] init];
    [self.navigationController pushViewController:sportsVC animated:YES];
    
    

    
}
-(void)keyboardChange:(NSNotification *)notification
{
    
    
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardEndFrame;
    
    [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [UIView setAnimationCurve:animationCurve];
    
    if (notification.name == UIKeyboardWillShowNotification) {
        self.chatTableView.frame = CGRectMake(0, -keyboardEndFrame.size.height, viewWidth, viewHeight-64-40);
    }else{
        // self.chatTableView.frame = CGRectMake(0, 0, viewWidth, viewHeight-64-40);
    }
    
    [self.view layoutIfNeeded];
    
    //adjust UUInputFunctionView's originPoint
    
    CGRect newFrame = IFView.frame;
     newFrame.size.height = 40;
    newFrame.origin.y = keyboardEndFrame.origin.y - newFrame.size.height-64;
   
    IFView.frame = newFrame;
    
    [UIView commitAnimations];
    
}

//tableView Scroll to bottom
- (void)tableViewScrollToBottom
{
    //    self.view.frame = CGRectMake(0, -IFView.bounds.origin.y, viewWidth, viewHeight-64);
    if (self.chatModel.dataSource.count==0)
        return;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.chatModel.dataSource.count-1) inSection:0];
    [self.chatTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void)loadBaseViewsAndData
{
    self.chatModel = [[ChatModel alloc]init];
    self.chatModel.headimgstr = self.headimgstr;
    self.chatModel.nickname = self.nickname;
    self.chatModel.isGroupChat = NO;
    [self.chatModel populateRandomDataSource];
    
    
    
    IFView = [[UUInputFunctionView alloc]initWithSuperVC:self];
    NSLog(@"IFView.frame  %f",IFView.frame.origin.y);
    IFView.delegate = self;
    IFView.dataSouceCount = self.chatModel.dataSource.count;
    [self.view addSubview:IFView];
    
    __block QuestionandSport *quest = self;
    
    IFView.lastRowBlock =^{
        [UIView animateWithDuration:0.3 animations:^{
            quest.chatTableView.frame = CGRectMake(0, -208, viewWidth, viewHeight-64-40);
            NSLog(@"进block了么");
        }];
       
    };
    
    
    
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}
#pragma mark - InputFunctionViewDelegate
//添加
//点击发送 调用UUInput方法 再调用dealTheFunctionData方法 再调用addSpecifiedItem方法
- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendMessage:(NSString *)message type:(NSString *)type
{
    
    NSDictionary *dic = @{@"strContent": message,
                          @"type": @(UUMessageTypeText)};
    funcView.TextViewInput.text = @"";
    [funcView changeSendBtnWithPhoto:YES];
    [self dealTheFunctionData:dic type:type];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendPicture:(UIImage *)image type:(NSString *)type
{
    NSDictionary *dic = @{@"picture": image,
                          @"type": @(UUMessageTypePicture)};
    [self dealTheFunctionData:dic type:type];
}

- (void)UUInputFunctionView:(UUInputFunctionView *)funcView sendVoice:(NSData *)voice time:(NSInteger)second type:(NSString *)type
{
    NSDictionary *dic = @{@"voice": voice,
                          @"strVoiceTime": [NSString stringWithFormat:@"%d",(int)second],
                          @"type": @(UUMessageTypeVoice)};
    [self dealTheFunctionData:dic type:type];
}
//添加
- (void)dealTheFunctionData:(NSDictionary *)dic type:(NSString *)type
{
    [self.chatModel addSpecifiedItem:dic type:type];
    [self.chatTableView reloadData];
    [self tableViewScrollToBottom];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatModel.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (cell == nil) {
        cell = [[UUMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
        cell.delegate = self;
      
        
    }
    
       [cell setMessageFrame:self.chatModel.dataSource[indexPath.row]];
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.chatModel.dataSource[indexPath.row] cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}
//拖动tableView
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [IFView.faceButton setBackgroundImage:[UIImage imageNamed:@"talk_face"] forState:UIControlStateNormal];
    IFView.isFace = NO;
    //tableView 的frame 复原
    self.chatTableView.frame = CGRectMake(0, 0, viewWidth, viewHeight-64-40);
    //输入框的位置复原
    IFView.frame = CGRectMake(0, viewHeight-(viewHeight/16.675)-64, viewWidth, viewHeight/16.675);
    //移除表情View
    [IFView.faceView removeFromSuperview];
    [self.view endEditing:YES];
    
}
#pragma mark - cellDelegate
- (void)headImageDidClick:(UUMessageCell *)cell userId:(NSString *)userId{
    // headIamgeIcon is clicked
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:cell.messageFrame.message.strName message:@"headImage clicked" delegate:nil cancelButtonTitle:@"sure" otherButtonTitles:nil];
    [alert show];
}
+ (instancetype)sharedViewControllerManager {
    static dispatch_once_t onceToken;
    static QuestionandSport* viewController;
    
    dispatch_once(&onceToken, ^{
        viewController = [[QuestionandSport alloc] init];
    });
    
    return viewController;
}



@end
