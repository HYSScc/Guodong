//
//  FinderPubViewController.m
//  果动
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 Unique. All rights reserved.
//
#define ResultString @"说点什么..."
#import "FinderPubViewController.h"

@interface FinderPubViewController ()<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@end

@implementation FinderPubViewController
{
    UIButton   *saveButton;
    UITextView *_textView;
    UIButton   *addButton;
    UILabel    *line;
    NSInteger  imageNumber;
    BOOL       isFirstFrame;
    NSMutableArray *photoArray;
    UIProgressView* progressView;
    UILabel    *progressLabel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    isFirstFrame = YES;                    // 确认是第一次位置
    photoArray   = [NSMutableArray array]; // 初始化照片数组
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
    titleLabel.text      = _className;
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
    
    
    saveButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveButton.frame = CGRectMake(viewWidth - Adaptive(53),  Adaptive(20)+(navigationHight - Adaptive(20)) / 2, Adaptive(40), Adaptive(20));
    [saveButton setTitle:@"发布" forState:UIControlStateNormal];
    [saveButton setTintColor:UIColorFromRGB(0x7f7f7f)];
    [saveButton addTarget:self action:@selector(saveButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    saveButton.userInteractionEnabled = NO;
    saveButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [navigationView addSubview:saveButton];
    
    
    _textView       = [UITextView new];
    _textView.frame = CGRectMake(Adaptive(13),
                                 Adaptive(10) + NavigationBar_Height,
                                 viewWidth - Adaptive(26),
                                 Adaptive(150));
    _textView.textColor = [UIColor grayColor];
    _textView.backgroundColor = BASECOLOR;
    _textView.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    _textView.text      = ResultString;
    _textView.delegate  = self;
    [self.view addSubview:_textView];
    
    
    progressView       = [UIProgressView  new];
    progressView.frame = CGRectMake(0,
                                    CGRectGetMaxY(_textView.frame) + 5,
                                    viewWidth,
                                    1);
    progressView.transform = CGAffineTransformMakeScale(1.f,.5f);
    progressView.trackTintColor    = [UIColor blackColor];
    progressView.progressTintColor = [UIColor orangeColor];
    [self.view addSubview:progressView];
    
    progressLabel       = [UILabel new];
    progressLabel.frame = CGRectMake(Adaptive(13),
                                     CGRectGetMaxY(progressView.frame) + Adaptive(2),
                                     viewWidth - Adaptive(26),
                                     Adaptive(12));
    progressLabel.textAlignment = 2;
    progressLabel.textColor = [UIColor grayColor];
    progressLabel.font      = [UIFont fontWithName:FONT size:Adaptive(10)];
    [self.view addSubview:progressLabel];
    
    addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.frame     = CGRectMake(Adaptive(13),
                                     CGRectGetMaxY(progressView.frame) + Adaptive(16),
                                     Adaptive(80),
                                     Adaptive(80));
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"find_addImage"] forState:UIControlStateNormal];
    [self.view addSubview:addButton];
    
    
}

- (void)addButtonClick:(UIButton *)button {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"照相", nil];
    [actionSheet showInView:self.view];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 2) return;
    
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    
    if (buttonIndex == 0) {
        // 从相册选取
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else {
        // 拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    // 2.允许编辑
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerController代理方法
- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // 添加照片到数组
    
    
    NSData *photoData = UIImageJPEGRepresentation(info[UIImagePickerControllerEditedImage], .7);
    NSDictionary *photoDict = @{@"image":photoData};
    
    [photoArray addObject:photoDict];
    
    [self setImageViewFrameWith:info[UIImagePickerControllerEditedImage]];
    
}
#pragma mark - 布置图片显示位置
- (void)setImageViewFrameWith:(UIImage *)image  {
    
    imageNumber++;
    
    UIImageView *imageView = [UIImageView new];
    imageView.frame        = addButton.frame;
    imageView.image        = image;
    [self.view addSubview:imageView];
    
    if (imageNumber < 9) {
        CGRect buttonframe = addButton.frame;
        if (imageNumber %4 == 0 && isFirstFrame == NO) {
            
            buttonframe.origin.x =  Adaptive(13);
            buttonframe.origin.y = CGRectGetMaxY(imageView.frame) + Adaptive(10);
        } else {
            
            buttonframe.origin.x = CGRectGetMaxX(imageView.frame) + Adaptive(10);
            isFirstFrame = NO;
        }
        addButton.frame    = buttonframe;
    }
    
}

- (void)cancelButtonClick:(UIButton *)button {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)saveButtonClick:(UIButton *)button {
    
    NSString     *url;
    NSDictionary *dict;
    
    if ([_className isEqualToString:@"答疑"]) {
        url  = [NSString stringWithFormat:@"%@api/?method=questions.send_talk",BASEURL];
        dict = @{@"content" : _textView.text};
    }
    
    if ([_className isEqualToString:@"动态"]) {
        url  = [NSString stringWithFormat:@"%@api/?method=gdb.send_talk",BASEURL];
        dict = @{@"content" : _textView.text,
                 @"type" : @"1"
                 };
    }
    
    
    [HttpTool postWithUrl:url params:dict body:photoArray progress:^(NSProgress *progress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //主线程更新UI
            progressView.progress = progress.completedUnitCount / progress.totalUnitCount;
            progressLabel.text    = [NSString stringWithFormat:@"%.1fKB/%.1fKB",progress.completedUnitCount/1024.0,progress.totalUnitCount/1024.0];
        });
        
    } success:^(id responseObject) {
       [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

#pragma mark- UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:ResultString]) {
        textView.text = @"";
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text

{
    NSMutableString * changedString = [[NSMutableString alloc]initWithString:textView.text];
    [changedString replaceCharactersInRange:range withString:text];
    
    if (changedString.length!=0) {
        
        [saveButton setTintColor:UIColorFromRGB(0x2b2b2b)];
        saveButton.userInteractionEnabled = YES;
        
    } else {
        [saveButton setTintColor:UIColorFromRGB(0x7f7f7f)];
        saveButton.userInteractionEnabled = NO;
        
    }
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = ResultString;
    } else {
        
        CGSize textSize = [textView.text boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]} context:nil].size;
        
        CGRect frame = textView.frame;
        if (textSize.height  > Adaptive(150)) {
            frame.size.height = textSize.height + Adaptive(8);
        }
        textView.frame = frame;
        
    }
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
