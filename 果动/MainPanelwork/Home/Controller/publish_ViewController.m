//
//  publish_ViewController.m
//  私练
//
//  Created by mac on 15/1/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "publish_ViewController.h"
#import "Commonality.h"
#import "ELCImagePickerController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImage+JW.h"
#import "NSString+JW.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "HttpTool.h"
#import "UIKit+AFNetworking.h"
#import "GBViewController.h"
#import <SystemConfiguration/SystemConfiguration.h>
#import "AFNetworking.h"



//派生到我的代码片

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define  PROGREESS_WIDTH 80 //圆直径
#define PROGRESS_LINE_WIDTH 4 //弧线的宽度
@interface publish_ViewController ()<UITextViewDelegate,ELCImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate>
{
    UILabel * tip;
    NSMutableArray *_imageList; // 存放图片
    NSMutableArray *_imageDatas; // 存放要上传图片的data
    UIScrollView *_scrollView;//存放图片视图
    UITextView *_textView; // 发表说说的文本域
    UIImageView * _imageView;//获取拍摄视频的imageView和获取拍摄照片的imageView
    NSURL *videoURL;
    NSURL *outURL;
    NSData *videoData;
    int pvtype;
    NSData *image_data;
    UIAlertView *videoalert;
    UILabel *textnumberLabel;
    
    UILabel *numberLabel;
    UIProgressView *progressView;
    CGFloat file;
    NSData *photoData;
    
}
@property (nonatomic,strong) NSURLSession *session;
@property (strong, nonatomic) UIImagePickerController *imagePickerController;
@property (nonatomic,strong)UIImagePickerController * videoPickerController;
@end

@implementation publish_ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self onCreate];
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"发布"];
    BackView *backView = [[BackView alloc] initWithbacktitle:@"返回" viewController:self];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    
    UIButton *amentButton=[UIButton buttonWithType:UIButtonTypeSystem];
    amentButton.frame = CGRectMake(viewHeight/2.0212, viewHeight/24.7037, viewHeight/19.057,viewHeight/26.865);
    //  [amentButton setBackgroundImage:[UIImage imageNamed:@"person_set"] forState:UIControlStateNormal];
    [amentButton setTitle:@"发送" forState:UIControlStateNormal];
    [amentButton addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:amentButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
}

#pragma mark 初始化背景图、按钮控件与名字
-(void)onCreate
{
    _imageList = [NSMutableArray array];
    _imageDatas = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImageView * lineImage1=[UIImageView new];
    lineImage1.image=[UIImage imageNamed:@"home__line1"];
    lineImage1.frame=CGRectMake(0, 0, viewWidth, 1);
    [self.view addSubview:lineImage1];
    
    _textView = [[UITextView alloc] init];
    _textView.frame = CGRectMake(0, 0, viewWidth , viewHeight/4.45);
    _textView.font = [UIFont fontWithName:FONT size:viewHeight/39.235];
    _textView.backgroundColor=[UIColor clearColor];
    _textView.delegate = self;
    _textView.text = @" 说点什么...";
    _textView.textColor = [UIColor colorWithRed:136/255.0 green:136/255.0 blue:136/255.0 alpha:1];
    [self.view addSubview:_textView];
    
    //    UILabel *textlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), viewWidth, .5)];
    //    textlabel.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    //    [self.view addSubview:textlabel];
    
    progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_textView.frame), viewWidth, .5)];
    progressView.progressViewStyle= UIProgressViewStyleDefault;
    progressView.progressTintColor = [UIColor colorWithRed:255/255.0 green:125/255.0 blue:40/255.0 alpha:1];
    progressView.trackTintColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self.view addSubview:progressView];
    
    
    textnumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(_textView.bounds.size.width - viewHeight/22.233 - viewHeight/44.47, _textView.bounds.size.height-viewHeight/55.5833 - viewHeight/133.4, viewHeight/22.233, viewHeight/55.5833)];
    textnumberLabel.textColor = [UIColor colorWithRed:1 green:125/255.0 blue:40/255.0 alpha:1];
    textnumberLabel.font = [UIFont fontWithName:FONT size:viewHeight/55.5833];
    textnumberLabel.text = [NSString stringWithFormat:@"%d字",TextNumber];
    [_textView addSubview:textnumberLabel];
    
    UIView *imgview = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(progressView.frame), viewWidth, viewHeight/3.706)];
    imgview.backgroundColor = [UIColor whiteColor];
    imgview.userInteractionEnabled = YES;
    [self.view addSubview:imgview];
    
    _imageView=[[UIImageView alloc]initWithFrame:CGRectMake(viewHeight/51.308,  viewHeight/66.7, viewHeight/6.67, viewHeight/6.67)];
    [_imageView setImage:[UIImage imageNamed:@"publish_jia"]];
    [imgview addSubview:_imageView];
    
    
    UIButton * button=[UIButton buttonWithType:UIButtonTypeSystem];
    button.frame=_imageView.frame;
    [button addTarget:self action:@selector(imagePick:) forControlEvents:UIControlEventTouchUpInside];
    [imgview addSubview:button];
    
    
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - 150, CGRectGetMaxY(_textView.frame)+15, 150, 14)];
    // numberLabel.text = @"1.12MB/1.57MB";
    numberLabel.textColor = [UIColor lightGrayColor];
    numberLabel.textAlignment = 1;
    numberLabel.font = [UIFont fontWithName:FONT size:14];
    [self.view addSubview:numberLabel];
    
    
}
#pragma mark 分享按钮绑定事件
- (void)share:(UIButton *)sender {
    if ([[_textView.text trimString] isEmptyString] ) {
        
        
        [HeadComment showAlert:nil withMessage:@"说点什么吧~" delegate:nil witchCancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        // 1.回收键盘
        [self.view endEditing:YES];
        
    }else if (pvtype !=1&&pvtype!=2){
        [HeadComment showAlert:nil withMessage:@"来张照片或者来段视频吧" delegate:nil witchCancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
    }
    else
    {
        NSLog(@"pvtype   %d",pvtype);
        
     
        
        NSString *urlString = pvtype == 1 ? [NSString stringWithFormat:@"%@api/?method=gdb.send_talk&type=%d",BASEURL,pvtype] : [NSString stringWithFormat:@"%@api/?method=gdb.send_talk",BASEURL];
        
        NSDictionary *dict = pvtype == 1 ? @{@"content":_textView.text} : @{@"type":[NSString stringWithFormat:@"%d",pvtype],@"content":_textView.text};
        
        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
        NSMutableURLRequest *request = [serializer multipartFormRequestWithMethod:@"POST" URLString:urlString
                                                                       parameters:dict
                                                        constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                                            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                                                            // 设置时间格式
                                                            formatter.dateFormat = @"yyyyMMddHHmmss";
                                                            NSString *str = [formatter stringFromDate:[NSDate date]];
                                                            if (pvtype == 1) {
                                                                NSString *imageName = [NSString stringWithFormat:@"%@.jpg", str];
                                                                [formData appendPartWithFileData:photoData name:@"image" fileName:imageName mimeType:@"jpg"];
                                                            }
                                                            else
                                                            {
                                                                NSString *imageName = [NSString stringWithFormat:@"%@.jpg", str];
                                                                NSString *videoName = [NSString stringWithFormat:@"%@.mp4", str];
                                                                
                                                                [formData appendPartWithFileData:videoData name:@"video" fileName:videoName mimeType:@"mp4"];
                                                                [formData appendPartWithFileData:image_data name:@"image" fileName:imageName mimeType:@"jpg"];
                                                            }
                                                            
                                                            
                                                        }];
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        AFHTTPRequestOperation *operation =
        [manager HTTPRequestOperationWithRequest:request
                                         success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                             NSLog(@"Success %@", responseObject);
                                             [self.navigationController popViewControllerAnimated:YES];
                                             
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             NSLog(@"Failure %@", error.description);
                                         }];
        [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                            long long totalBytesWritten,
                                            long long totalBytesExpectedToWrite) {
            if (pvtype == 1) {
                numberLabel.text = [NSString stringWithFormat:@" %lldKB/%lldKB",totalBytesWritten/1024,totalBytesExpectedToWrite/1024];
                progressView.progress  = (totalBytesWritten/1024)/(totalBytesExpectedToWrite/1024);
                NSLog(@" %lldKB/%lldKB",totalBytesWritten/1024,totalBytesExpectedToWrite/1024);
            }
            else
            {
                numberLabel.text = [NSString stringWithFormat:@" %.2fMB/%.2fMB",totalBytesWritten/1024.0/1024.0,totalBytesExpectedToWrite/1024.0/1024.0];
                progressView.progress  = (totalBytesWritten/1024.0/1024.0)/(totalBytesExpectedToWrite/1024.0/1024.0);
            }
        }];
        [operation start];
        
    }
    
}
#pragma mark 触摸屏幕回收键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - UITextView代理方法
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@" 说点什么..."]) {
        textView.text = @"";
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    //通过内容和字体大小计算出宽度
    CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(textView.bounds.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:viewHeight/44.467]} context:nil].size;
    NSLog(@"width  %f   %f",textSize.width,textSize.height);
    //330.000000   53.685000
}
#pragma mark 添加ImageView
- (void)addImageView:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake((viewHeight/7.411) * index + viewHeight/66.7, viewHeight/66.7, viewHeight/8.3375, viewHeight/8.3375);
    imageView.image = [UIImage imageNamed:@""];
    // 设置图片内容模式
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES; // 切边
    
    [_scrollView addSubview:imageView];
    [_imageList addObject:imageView];
}

#pragma mark - 按钮绑定事件

#pragma mark 选择图片按钮绑定事件
- (void)imagePick:(UIButton *)sender
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册",@"视频", nil];
    [sheet showInView:self.view];
}

//UIActionSheet代理方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    _imagePickerController = [[UIImagePickerController alloc] init];
    _imagePickerController.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    
    // 1.设置照片源
    
    if (buttonIndex == 0)
    { // 拍照
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else if (buttonIndex == 1)
    { // 从照片库选择
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    else if (buttonIndex == 2)
    {
        if (!self.videoPickerController) {
            self.videoPickerController = [UIImagePickerController new];
            self.videoPickerController.delegate = self;
        }
        //设定照相机可以获取那些类型的媒体（图片选取器的mediaTypes属性kUTTypeMovie或者kUTTypeImage）
        self.videoPickerController.mediaTypes = @[(NSString *)kUTTypeMovie];
        //设定图片的来源为摄像头（图片选取器的sourceType属性UIImagePickerControllerSourceTypeCamera）
        self.videoPickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设定图片选取器的摄像头捕获模式（图片选取器的cameraCaptureMode属性UIImagePickerControllerCameraCaptureModePhoto或者UIImagePickerControllerCameraCaptureModeVideo）
        self.videoPickerController.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        //设置摄像图像品质
        self.videoPickerController.videoQuality = UIImagePickerControllerQualityTypeMedium;
        [self.videoPickerController setVideoMaximumDuration:60.0f];
        //打开图片选取器视图控制器（模态视图方式）
        [self presentViewController:self.videoPickerController animated:YES completion:nil];
    }
    else
    {
        NSLog(@"取消");
        return;
    }
    
    
    // 2.允许编辑
    _imagePickerController.allowsEditing = YES;
    // 3.设置代理
    _imagePickerController.delegate = self;
    // 4.显示照片选择控制器
    [self presentViewController:_imagePickerController animated:YES completion:nil];
    
    
}

- (void) lowQuailtyWithInputURL:(NSURL*)inputURL outputURL:(NSURL*)outputURL blockHandler:(void (^)(AVAssetExportSession*))handler
{
    // AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL opti*****:nil];
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputURL options:nil];
    AVAssetExportSession *session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
    session.outputURL = outputURL;
    session.outputFileType = AVFileTypeQuickTimeMovie;
    [session exportAsynchronouslyWithCompletionHandler:^(void){
        handler(session);
    }];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if (picker==_imagePickerController)
    {
        _imageDatas = [[NSMutableArray alloc] initWithCapacity:0];
        //  _imageView.contentMode = UIViewContentModeScaleAspectFit;
        //设置图片是否可以截取
        _imageView.image=info[UIImagePickerControllerEditedImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        // 显示图片
        
        
        //     设置图片大小
        CGSize imageSize = _imageView.image.size;
        imageSize.width = viewHeight/1.6675;
        imageSize.height = viewHeight/1.6675;
        //  对图片大小进行压缩  获取图片的data
        
        photoData = UIImageJPEGRepresentation(_imageView.image, .7);
        //            NSLog(@"压缩后：data：%lu", data.length);
        // 封装字典
        
        NSString *key = @"picture";
        NSDictionary *dict = @{key: photoData};
        [_imageDatas addObject:dict];
        numberLabel.text = [NSString stringWithFormat:@"文件大小:%luKB",[photoData length]/1024];
        pvtype =1;
    }
    
    if (picker==self.videoPickerController)
    {
        NSLog(@"发视频了");
        
        
        [self dismissViewControllerAnimated:NO completion:nil];
        NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
        
        if ([type isEqualToString:(NSString *)kUTTypeVideo] || [type isEqualToString:(NSString *)kUTTypeMovie])
        {
            videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
            
            
            // 重命名然后保存至本地沙箱目录
            videoData = [NSData dataWithContentsOfURL:videoURL];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd-MM-yyyy||HH:mm:SS"];
            NSDate *now = [[NSDate alloc] init];
            NSString *theDate = [dateFormat stringFromDate:now];
            
            NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"Default Album"];
            
            if (![[NSFileManager defaultManager] fileExistsAtPath:dataPath])
                [[NSFileManager defaultManager] createDirectoryAtPath:dataPath withIntermediateDirectories:NO attributes:nil error:nil];
            
            NSString *videopath= [[NSString alloc] initWithString:[NSString stringWithFormat:@"%@/%@.mp4",documentsDirectory,theDate]];
            
            BOOL success = [videoData writeToFile:videopath atomically:NO];
            
            NSLog(@"Successs:::: %@", success ? @"YES" : @"NO");
            NSLog(@"video path --> %@",videopath);
            
            
            file = [self getFileSize:videopath];
            numberLabel.text = [NSString stringWithFormat:@"文件大小:%.2fMB",file];
            
            MPMoviePlayerController *player = [[MPMoviePlayerController alloc]initWithContentURL:videoURL];
            player.shouldAutoplay = NO;
            //获取缩略图
            UIImage  *thumbnail = [player thumbnailImageAtTime:1.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
            _scrollView.hidden=NO;
            _imageView.image =thumbnail;
            // NSData *data = UIImageJPEGRepresentation(_imageView.image, 0.01);
            image_data = UIImageJPEGRepresentation(thumbnail,0.000001);
            
        }
        
        pvtype = 2;
        
        
    }
}
-(CGFloat)getFileSize:(NSString *)path
{
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:nil];
        unsigned long long size = [[fileDict objectForKey:NSFileSize] longLongValue];
        filesize = 1.0*size /1024/1024;
    }
    return filesize;
}
/*
 推荐的视频压缩格式是 H.264、10-12Mbps 的比率、30fps，视频最大 500MB，长度在 15 到 30 秒之间，对应的音频格式是 256kbps AAC，44.1kHZ 采样率（但经过实测，这些指标应该只是建议指标，哪怕有点出入 Apple 也是接受的）。另外大家自己上 App Store 也能发现用户实际播放的是已经经过比较厉害压缩的版本。
 */
#pragma mark 分享按钮绑定事件

#pragma mark ELCImagePickerControllerDelegate方法

#pragma mark 完成图片选择
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    // 1.先把先前选中的图片清空
    [self.view addSubview:_scrollView];
    for (UIImageView *imageView in _imageList) {
        imageView.image = [UIImage imageNamed:@""];
    }
    _imageView.hidden=NO;
    // 2.模态视图消失
    [self dismissViewControllerAnimated:YES completion:nil];
    // 3.重新设置图片
    for (int i = 0; i < info.count; i ++) {
        UIImageView *imageView = _imageList[i];
        NSDictionary *dict = info[i];
        if (dict[UIImagePickerControllerOriginalImage]) {
            // 显示图片
            imageView.image = dict[UIImagePickerControllerOriginalImage];
            //            NSLog(@"压缩前：data：%lu", UIImagePNGRepresentation(imageView.image).length);
            // 设置图片大小
            CGSize imageSize = imageView.image.size;
            imageSize.width = viewHeight/1.6675;
            imageSize.height = viewHeight/1.6675;
            // 对图片大小进行压缩
            imageView.image = [UIImage zipImage:imageView.image scaledToSize:imageSize];
            // 获取图片的data
            NSData *data = UIImageJPEGRepresentation(imageView.image, 0.3);
            //            NSLog(@"压缩后：data：%lu", data.length);
            // 封装字典
            NSString *key = [NSString stringWithFormat:@"sharedPic%d", i + 1];
            NSDictionary *dict = @{key: data};
            [_imageDatas addObject:dict];
        }
    }
}

#pragma mark 取消图片选择
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//限制输入字数
- (void)textViewDidChange:(UITextView *)textView
{
    if(_textView.text.length <= TextNumber){
        NSLog(@"进了if");
        textnumberLabel.text = [NSString stringWithFormat:@"%lu字",TextNumber - _textView.text.length];
        
    }
    
    //该判断用于联想输入
    if (textView.text.length > TextNumber)
    {
        textView.text = [textView.text substringToIndex:TextNumber];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    GBViewController *gdVC = [GBViewController new];
    gdVC.SLTImage = _imageView.image;
    
    [self.navigationController popViewControllerAnimated: YES];
}



@end
