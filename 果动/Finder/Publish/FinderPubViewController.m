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
    NSInteger  clickNumber;
    BOOL       isFirstFrame;
    NSMutableArray *photoArray;
    UIProgressView* progressView;
    UILabel    *progressLabel;
    UIButton   *removeButton;
    
    UIView   *addView;
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
    
    
    addView = [UIView new];
    addView.frame = CGRectMake(0,
                               CGRectGetMaxY(progressView.frame) + Adaptive(16),
                               viewWidth,
                               viewHeight - Tabbar_Height - CGRectGetMaxY(progressView.frame) + Adaptive(16));
    [self.view addSubview:addView];
    
    
    addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.frame     = CGRectMake(Adaptive(13),
                                     0,
                                     Adaptive(80),
                                     Adaptive(80));
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setBackgroundImage:[UIImage imageNamed:@"find_addImage"] forState:UIControlStateNormal];
    [addView addSubview:addButton];
    
}

- (void)addButtonClick:(UIButton *)button {
    [_textView resignFirstResponder];
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
    
    
    if ([_className isEqualToString:@"发布动态"]) {
        if (![_textView.text isEqualToString:ResultString] && photoArray.count != 0) {
            
            [saveButton setTintColor:UIColorFromRGB(0x2b2b2b)];
            saveButton.userInteractionEnabled = YES;
            
        } else {
            [saveButton setTintColor:UIColorFromRGB(0x7f7f7f)];
            saveButton.userInteractionEnabled = NO;
            
        }
    }
    
   
    
    [self setImageViewFrameWith:info[UIImagePickerControllerEditedImage]];
    
}
#pragma mark - 布置图片显示位置
- (void)setImageViewFrameWith:(UIImage *)image  {
    
    UIImageView *imageView = [UIImageView new];
    imageView.frame        = addButton.frame;
    imageView.image        = image;
    imageView.tag          = photoArray.count + 100;
    imageView.userInteractionEnabled = YES;
    [addView addSubview:imageView];
    UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    [imageView addGestureRecognizer:tapLeftDouble];
    
    if (photoArray.count < 10) {
        CGRect buttonframe = addButton.frame;
        if (photoArray.count %4 == 0 && isFirstFrame == NO) {
            
            buttonframe.origin.x =  Adaptive(13);
            buttonframe.origin.y = CGRectGetMaxY(imageView.frame) + Adaptive(10);
        } else {
            
            buttonframe.origin.x = CGRectGetMaxX(imageView.frame) + Adaptive(10);
            isFirstFrame = NO;
        }
        addButton.frame    = buttonframe;
    }
    
}
#pragma mark - 移除图片 重新布局位置
- (void)removeImageViewFrame{
    
    if (_textView.text.length != 0 && photoArray.count != 0) {
        
        [saveButton setTintColor:UIColorFromRGB(0x2b2b2b)];
        saveButton.userInteractionEnabled = YES;
        
    } else {
        [saveButton setTintColor:UIColorFromRGB(0x7f7f7f)];
        saveButton.userInteractionEnabled = NO;
        
    }
    
    [self.view addSubview:addView];
    
    if (photoArray.count > 0) {
        for (int a = 0; a < photoArray.count ; a++) {
            
            
            UIImageView *imageView = [UIImageView new];
            imageView.frame = CGRectMake(Adaptive(13) + (a % 4) * Adaptive(90),
                                         (a / 4) * Adaptive(90),
                                         Adaptive(80),
                                         Adaptive(80));
            imageView.tag   = a + 101;
            imageView.image = [UIImage imageWithData:[photoArray[a] objectForKey:@"image"]];
            imageView.userInteractionEnabled = YES;
            [addView addSubview:imageView];
            
            
            addButton.frame = CGRectMake(Adaptive(13) + ((a + 1) % 4) * Adaptive(90),
                                         ((a + 1) / 4) * Adaptive(90),
                                         Adaptive(80),
                                         Adaptive(80));
            [addView addSubview:addButton];
            
            UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
            [imageView addGestureRecognizer:tapLeftDouble];
        }
    } else {
        addButton.frame = CGRectMake(Adaptive(13),
                                     0,
                                     Adaptive(80),
                                     Adaptive(80));
        [addView addSubview:addButton];
    }
}

-(void)magnifyImage:(UIGestureRecognizer *)gesture
{
    removeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    removeButton.frame = CGRectMake(gesture.view.bounds.size.width - Adaptive(18),
                                    -3,
                                    Adaptive(18),
                                    Adaptive(18));
    [removeButton setBackgroundImage:[UIImage imageNamed:@"app_remove"] forState:UIControlStateNormal];
    [removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [gesture.view addSubview:removeButton];
}

- (void)removeButtonClick:(UIButton *)button {
    
    [photoArray removeObjectAtIndex:button.superview.tag - 101];
    [addView removeFromSuperview];
    addView = [UIView new];
    addView.frame = CGRectMake(0,
                               CGRectGetMaxY(progressView.frame) + Adaptive(16),
                               viewWidth,
                               viewHeight - Tabbar_Height - CGRectGetMaxY(progressView.frame) + Adaptive(16));
    [self.view addSubview:addView];
    
    [self removeImageViewFrame];
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
    
    if ([_className isEqualToString:@"发布动态"]) {
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
    
    if (![_className isEqualToString:@"答疑"]) {
        if (changedString.length!= 0 && photoArray.count != 0) {
            
            [saveButton setTintColor:UIColorFromRGB(0x2b2b2b)];
            saveButton.userInteractionEnabled = YES;
            
        } else {
            [saveButton setTintColor:UIColorFromRGB(0x7f7f7f)];
            saveButton.userInteractionEnabled = NO;
            
        }
    } else {
        if (changedString.length!= 0) {
            
            [saveButton setTintColor:UIColorFromRGB(0x2b2b2b)];
            saveButton.userInteractionEnabled = YES;
            
        } else {
            [saveButton setTintColor:UIColorFromRGB(0x7f7f7f)];
            saveButton.userInteractionEnabled = NO;
            
        }
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
    [removeButton removeFromSuperview];
}

@end
