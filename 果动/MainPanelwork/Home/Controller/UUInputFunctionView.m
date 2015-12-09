//
//  UUInputFunctionView.m
//  UUChatDemoForTextVoicePicture
//
//  Created by shake on 14-8-27.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUInputFunctionView.h"
#import "Mp3Recorder.h"
#import "UUProgressHUD.h"
#import "ACMacros.h"
#import "QuestionandSport.h"
#import "SRWebSocket.h"
#import "Commonality.h"
#import "CollectionViewCell.h"
#import "AppDelegate.h"
#import "YLGIFImage.h"
#import "YLImageView.h"
static NSString * CellIdentifier;
@interface UUInputFunctionView ()<UITextViewDelegate,Mp3RecorderDelegate,SRWebSocketDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    BOOL isbeginVoiceRecord;
    Mp3Recorder *MP3;
    NSInteger playTime;
    NSTimer *playTimer;
    //socket
    SRWebSocket *_webSocket;
    UILabel *placeHold;
    /////
    NSString * imagepath;
    // UIView *faceView;
}
@property (nonatomic,retain)NSString *uid;
@end

@implementation UUInputFunctionView

- (id)initWithSuperVC:(UIViewController *)superVC
{
    //NSLog(@"superVC = %@",superVC);
    self.superVC = superVC;
    CGRect frame = CGRectMake(0, Main_Screen_Height-(viewHeight/16.675)-64, Main_Screen_Width, viewHeight/16.675);
    self.userInteractionEnabled = YES;
    self = [super initWithFrame:frame];
    if (self) {
        NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie *cookie in [cookieJar cookies])
        {
            
            if ([cookie.name isEqualToString:@"uid"]) {
                _uid = cookie.value;
                NSLog(@"uid%@", cookie.value);
            }
        }
        
        [self _reconnect];
        
        MP3 = [[Mp3Recorder alloc]initWithDelegate:self];
        self.backgroundColor = BASECOLOR;
        //发送消息
        self.btnSendMessage = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnSendMessage.frame = CGRectMake(Main_Screen_Width-(viewHeight/16.675), viewHeight/133.4, viewHeight/22.233, viewHeight/22.233);
        self.isAbleToSendTextMessage = NO;
        [self.btnSendMessage setTitle:@"" forState:UIControlStateNormal];
        [self.btnSendMessage setBackgroundImage:[UIImage imageNamed:@"Chat_take_picture"] forState:UIControlStateNormal];
        self.btnSendMessage.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnSendMessage addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnSendMessage];
        
        //改变状态（语音、文字）
        self.btnChangeVoiceState = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnChangeVoiceState.frame = CGRectMake(viewHeight/133.4, viewHeight/133.4, viewHeight/22.233, viewHeight/22.233);
        isbeginVoiceRecord = NO;
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"chat_voice_record"] forState:UIControlStateNormal];
        self.btnChangeVoiceState.titleLabel.font = [UIFont systemFontOfSize:12];
        [self.btnChangeVoiceState addTarget:self action:@selector(voiceRecord:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnChangeVoiceState];
        
        //语音录入键
        self.btnVoiceRecord = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnVoiceRecord.frame = CGRectMake(viewHeight/9.529, viewHeight/133.4, Main_Screen_Width-(viewHeight/9.529)*2, viewHeight/22.233);
        self.btnVoiceRecord.hidden = YES;
        [self.btnVoiceRecord setBackgroundImage:[UIImage imageNamed:@"talk_textImage"] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitleColor:[[UIColor lightGrayColor] colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [self.btnVoiceRecord setTitle:@"Hold to Talk" forState:UIControlStateNormal];
        [self.btnVoiceRecord setTitle:@"Release to Send" forState:UIControlStateHighlighted];
        [self.btnVoiceRecord addTarget:self action:@selector(beginRecordVoice:) forControlEvents:UIControlEventTouchDown];
        [self.btnVoiceRecord addTarget:self action:@selector(endRecordVoice:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnVoiceRecord addTarget:self action:@selector(cancelRecordVoice:) forControlEvents:UIControlEventTouchUpOutside | UIControlEventTouchCancel];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self.btnVoiceRecord addTarget:self action:@selector(RemindDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [self addSubview:self.btnVoiceRecord];
        
        //输入框
        self.TextViewInput = [[UITextView alloc]initWithFrame:CGRectMake(viewHeight/14.822, viewHeight/133.4, Main_Screen_Width-3*(viewHeight/14.822), viewHeight/22.233)];
        self.TextViewInput.layer.cornerRadius = 4;
        self.TextViewInput.backgroundColor = [UIColor clearColor];
        self.TextViewInput.textColor = [UIColor whiteColor];
        self.TextViewInput.layer.masksToBounds = YES;
        self.TextViewInput.delegate = self;
        self.TextViewInput.layer.borderWidth = 1;
        self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
        [self addSubview:self.TextViewInput];
        
        //输入框的提示语
        placeHold = [[UILabel alloc]initWithFrame:CGRectMake(viewHeight/33.35, 0, viewHeight/3.335, viewHeight/22.233)];
        placeHold.textAlignment = 1;
        placeHold.font = [UIFont fontWithName:FONT size:viewHeight/44.467
                          ];
        placeHold.text = @"Input the contents here";
        placeHold.textColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.8];
        [self.TextViewInput addSubview:placeHold];
        
        //表情切换按钮
        self.faceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.faceButton.frame = CGRectMake(CGRectGetMaxX(self.TextViewInput.frame)+10, 5, 30, 30);
        [self.faceButton addTarget:self action:@selector(faceButton:) forControlEvents:UIControlEventTouchUpInside];
        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"talk_face"] forState:UIControlStateNormal];
        [self addSubview:self.faceButton];
        
        //表情View
        self.faceView = [[UIView alloc] initWithFrame:CGRectMake(0, 40,Main_Screen_Width , 208)];
        self.faceView.userInteractionEnabled = YES;
        //   self.faceView.backgroundColor = [UIColor grayColor];
        
        
        CellIdentifier = @"cell";
        
        //collectionView布局
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setItemSize:CGSizeMake(30,30)];//设置cell的尺寸
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//设置其布局方向
        flowLayout.minimumInteritemSpacing = 5;
        //   flowLayout.minimumLineSpacing = 5;
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 0, self.faceView.bounds.size.width-30, self.faceView.bounds.size.height) collectionViewLayout:flowLayout];
        [collection registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:CellIdentifier];
        collection.backgroundColor = [UIColor lightGrayColor];
        collection.contentSize = CGSizeMake(self.faceView.bounds.size.width*3, self.faceView.bounds.size.height);
        collection.pagingEnabled = YES;
        // collection.contentSize
        collection.delegate = self;
        collection.dataSource = self;
        [self.faceView addSubview:collection];
        
        
        
        //分割线
        self.layer.borderWidth = 1;
        self.layer.borderColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3].CGColor;
        
        
    }
    return self;
}

-(void)faceButton:(UIButton *)button
{
    QuestionandSport *quest = [QuestionandSport sharedViewControllerManager];
    
    
    
    _isFace = !_isFace;
    if (_isFace) {
        NSLog(@"输入表情");
        
        if (self.lastRowBlock)
        {
            self.lastRowBlock();
        }
        [UIView animateWithDuration:0.3 animations:^{
            [self.faceButton setBackgroundImage:[UIImage imageNamed:@"talk_shuru"] forState:UIControlStateNormal];
            [self.TextViewInput resignFirstResponder];
            NSLog(@"self.faceView %@",self.faceView);
            
            CGRect newFrame = self.frame;
            newFrame.origin.y = 459 - newFrame.size.height-64;
            newFrame.size.height = 40+258;
            self.frame = newFrame;
            
            
            [self addSubview:self.faceView];
            
            
        }];
        
        
        
        
    }
    else{
        NSLog(@"输入汉字");
        CGRect newFrame = self.frame;
        newFrame.size.height = 40;
        self.frame = newFrame;
        [self.faceButton setBackgroundImage:[UIImage imageNamed:@"talk_face"] forState:UIControlStateNormal];
        
        [self.TextViewInput becomeFirstResponder];
        NSLog(@"输入汉字 quest.chatTableView %@",quest.chatTableView);
        [self.faceView removeFromSuperview];
        
        
    }
    
    
    
    
}

#pragma mark -- UICollectionViewdataSouce
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 24;//80  30  30  20
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSString *name = [NSString stringWithFormat:@"gd_%ld",(long)indexPath.section];
    ;
    NSLog(@"name  %@",name);
    imagepath = [[NSBundle mainBundle] pathForResource:name ofType:@"gif"];
    cell.imageView.image = [YLGIFImage imageWithContentsOfFile:imagepath];
       return cell;
}

#pragma mark -- UICollectionViewDelegate
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择%ld ",(long)indexPath.row);
}

#pragma  mark -- UICollectionViewDelegateFloeLayout
//间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30, 6, 5, 7);//上左下右
}
//-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 10;
//}
# pragma mark -- WebSocket
//建立连接
- (void)_reconnect;
{
    _webSocket.delegate = nil;
    [_webSocket close];
    _webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"ws://192.168.1.90:8000/chat?self_id=%@",_uid]]]];
    _webSocket.delegate = self;
    
    
    [_webSocket open];
}
- (void)webSocketDidOpen:(SRWebSocket *)webSocket;
{
    NSLog(@"Websocket Connected");
    // self.title = @"Connected!";
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error;
{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    // self.title = @"Connection Failed! (see logs)";
    _webSocket = nil;
}
//接收或发送消息
- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message;
{
    NSLog(@"所有输出Received \"%@\"", message);
    //json字符串解析成字典
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSString *type = [dict objectForKey:@"type"];
    if ([type isEqualToString:@"sys"]||[type isEqualToString:@"service"])
    {
        NSString  *textString = [dict objectForKey:@"message"];
        NSString *resultStr = [textString stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate UUInputFunctionView:self sendMessage:resultStr type:@"service"];
        
        
    }
}
#pragma mark - 录音touch事件
- (void)beginRecordVoice:(UIButton *)button
{
    [MP3 startRecord];
    playTime = 0;
    playTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countVoiceTime) userInfo:nil repeats:YES];
    [UUProgressHUD show];
}

- (void)endRecordVoice:(UIButton *)button
{
    if (playTimer) {
        [MP3 stopRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
}

- (void)cancelRecordVoice:(UIButton *)button
{
    if (playTimer) {
        [MP3 cancelRecord];
        [playTimer invalidate];
        playTimer = nil;
    }
    [UUProgressHUD dismissWithError:@"Cancel"];
}

- (void)RemindDragExit:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Release to cancel"];
}

- (void)RemindDragEnter:(UIButton *)button
{
    [UUProgressHUD changeSubTitle:@"Slide up to cancel"];
}


- (void)countVoiceTime
{
    playTime ++;
    if (playTime>=60) {
        [self endRecordVoice:nil];
    }
}

#pragma mark - Mp3RecorderDelegate

//回调录音资料
- (void)endConvertWithData:(NSData *)voiceData
{
#warning 未上传
    
    // NSString *_encodedImageStr = [voiceData base64Encoding];
    // [_webSocket send:_encodedImageStr ];
    
    
    [self.delegate UUInputFunctionView:self sendVoice:voiceData time:playTime+1 type:@"me"];
    [UUProgressHUD dismissWithSuccess:@"Success"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

- (void)failRecord
{
    [UUProgressHUD dismissWithSuccess:@"Too short"];
    
    //缓冲消失时间 (最好有block回调消失完成)
    self.btnVoiceRecord.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.btnVoiceRecord.enabled = YES;
    });
}

//改变输入与录音状态
- (void)voiceRecord:(UIButton *)sender
{
    self.btnVoiceRecord.hidden = !self.btnVoiceRecord.hidden;
    self.TextViewInput.hidden  = !self.TextViewInput.hidden;
    isbeginVoiceRecord = !isbeginVoiceRecord;
    if (isbeginVoiceRecord) {
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"talk_shuru"] forState:UIControlStateNormal];
        [self.TextViewInput resignFirstResponder];
    }else{
        [self.btnChangeVoiceState setBackgroundImage:[UIImage imageNamed:@"talk_music"] forState:UIControlStateNormal];
        [self.TextViewInput becomeFirstResponder];
    }
}

//发送消息（文字图片）
- (void)sendMessage:(UIButton *)sender
{
    if (self.isAbleToSendTextMessage) {
        [_webSocket send:self.TextViewInput.text ];
        NSString *resultStr = [self.TextViewInput.text stringByReplacingOccurrencesOfString:@"   " withString:@""];
        [self.delegate UUInputFunctionView:self sendMessage:resultStr type:@"me"];
    }
    else{
        [self.TextViewInput resignFirstResponder];
        UIActionSheet *actionSheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera",@"Images",nil];
        [actionSheet showInView:self.window];
    }
}


#pragma mark - TextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    CGRect newFrame = self.frame;
    newFrame.size.height = 40;
    self.frame = newFrame;
    placeHold.hidden = self.TextViewInput.text.length > 0;
    self.isFace = NO;
    [self.faceButton setBackgroundImage:[UIImage imageNamed:@"talk_face"] forState:UIControlStateNormal];
    [_faceView removeFromSuperview];
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self changeSendBtnWithPhoto:textView.text.length>0?NO:YES];
    placeHold.hidden = textView.text.length>0;
}

- (void)changeSendBtnWithPhoto:(BOOL)isPhoto
{
    self.isAbleToSendTextMessage = !isPhoto;
    [self.btnSendMessage setTitle:isPhoto?@"":@"send" forState:UIControlStateNormal];
    self.btnSendMessage.frame = RECT_CHANGE_width(self.btnSendMessage, isPhoto?30:35);
    UIImage *image = [UIImage imageNamed:isPhoto?@"Chat_take_picture":@"chat_send_message"];
    [self.btnSendMessage setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    placeHold.hidden = self.TextViewInput.text.length > 0;
}


#pragma mark - Add Picture
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self addCarema];
    }else if (buttonIndex == 1){
        [self openPicLibrary];
    }
}
//13810660831  c  13520225690 y
-(void)addCarema{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.superVC presentViewController:picker animated:YES completion:^{}];
    }else{
        //如果没有提示用户
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tip" message:@"Your device don't have camera" delegate:nil cancelButtonTitle:@"Sure" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)openPicLibrary{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.superVC presentViewController:picker animated:YES completion:^{
        }];
    }
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //
    UIImage *editImage = [info objectForKey:UIImagePickerControllerEditedImage];
    NSData *_data = UIImageJPEGRepresentation(editImage, 0.5f);
    NSString *_encodedImageStr = [_data base64Encoding];
    
    NSString *imgStr = [NSString stringWithFormat:@"data_image/jpg_%@",_encodedImageStr];
    
    [_webSocket send:imgStr ];
    [self.superVC dismissViewControllerAnimated:YES completion:^{
        [self.delegate UUInputFunctionView:self sendPicture:editImage type:@"me"];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.superVC dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
