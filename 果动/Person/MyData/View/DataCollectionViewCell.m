//
//  DataCollectionViewCell.m
//  果动
//
//  Created by mac on 16/6/20.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "AppDelegate.h"
#import "MyDataModel.h"
#import "DataCollectionViewCell.h"


#import "ImgScrollerView.h"
#import "TapImageView.h"
@interface DataCollectionViewCell ()<TapImageViewDelegate,ImgScrollViewDelegate,UIScrollViewDelegate>

@end

@implementation DataCollectionViewCell
{
    CGFloat     selfHeight;
    CGFloat     selfWidth;
    TextFieldView  *textView;
    UILabel     *dateLabel;
    AppDelegate * app;
    
    UIScrollView *myScrollView;
    NSInteger     currentIndex;
    UIView       *markView;
    UIView       *scrollPanel;
    UIButton     *jtxlButton;
    NSString     *data_id;
     UIView            *alphaView;
    CGFloat offset;
    CGFloat textHeight;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
        self.backgroundColor = BASECOLOR;
        
        selfHeight = self.frame.size.height;
        selfWidth  = self.frame.size.width;
        
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
//        
//        
//        
//        alphaView = [UIView new];
//        alphaView.frame = CGRectMake(0,
//                                     0,
//                                     viewWidth,
//                                     viewHeight);
//        alphaView.backgroundColor = BASECOLOR;
//        
//        alphaView.alpha = .6;
//        UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
//        [alphaView addGestureRecognizer:tapLeftDouble];
//       
//        
//        
//        textView = [[TextFieldView alloc] initWithFrame:CGRectMake(0, viewHeight - NavigationBar_Height, viewWidth, Adaptive(42))];
//        [textView.publishButton setTitle:@"确认" forState:UIControlStateNormal];
//        textView.textField.placeholder  = @"输入您的静态心率";
//        textView.textField.keyboardType = UIKeyboardTypePhonePad;
//        [textView.publishButton addTarget:self action:@selector(CommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//        textView.backgroundColor = [UIColor colorWithRed:201/255.0
//                                                   green:205/255.0
//                                                    blue:211/255.0
//                                                   alpha:1];
//        textView.textField.backgroundColor = [UIColor colorWithRed:187/255.0
//                                                             green:194/255.0
//                                                              blue:201/255.0
//                                                             alpha:1];
        
        app = [UIApplication sharedApplication].delegate;
        
        scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        scrollPanel.alpha = 0;
        scrollPanel.backgroundColor = [UIColor clearColor];
        
        [app.window addSubview:scrollPanel];
        
        markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
        
        
        [scrollPanel addSubview:markView];
        
        myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        myScrollView.delegate = self;
        [scrollPanel addSubview:myScrollView];
        myScrollView.pagingEnabled = YES;
        myScrollView.delegate = self;
        
        CGSize contentSize = myScrollView.contentSize;
        contentSize.height = viewHeight;
        contentSize.width  = viewWidth *2;
        myScrollView.contentSize = contentSize;

        
        dateLabel       = [UILabel new];
        dateLabel.frame = CGRectMake(0,
                                     Adaptive(3),
                                     selfWidth,
                                     Adaptive(14));
        dateLabel.textColor = [UIColor lightGrayColor];
        dateLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        dateLabel.textAlignment = 1;
        dateLabel.text      = @"2016/06/29";
        [self addSubview:dateLabel];
        
        UILabel *orangeLine = [UILabel new];
        orangeLine.frame    = CGRectMake(0,
                                          CGRectGetMaxY(dateLabel.frame) + Adaptive(12),
                                          selfWidth,
                                          1);
        orangeLine.backgroundColor = ORANGECOLOR;
        [self addSubview:orangeLine];
        
        
        UIImageView *ringImageView = [UIImageView new];
        ringImageView.frame        = CGRectMake((selfWidth - Adaptive(13)) / 2,
                                                CGRectGetMaxY(dateLabel.frame) + Adaptive(5.5),
                                                Adaptive(13),
                                                Adaptive(13));
        ringImageView.image = [UIImage imageNamed:@"person_data_ring"];
        [self addSubview:ringImageView];
        
        
        CGFloat imageWidth  = (viewWidth - Adaptive(70)) / 4;
        CGFloat imageHeight = imageWidth * (4 / 3);
        
        _leftImageView       = [[TapImageView alloc] initWithFrame:CGRectMake(0,
                                                                             Adaptive(40.5),
                                                                             imageWidth,
                                                                             imageHeight)];
        _leftImageView.tag = 10;
       
        _leftImageView.tap_delegate    = self;
        _leftImageView.backgroundColor = BASEGRYCOLOR;
        [self addSubview:_leftImageView];
        
        _rightImageView       = [[TapImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame),
                                                                              Adaptive(40.5),
                                                                              imageWidth,
                                                                              imageHeight)];
        _rightImageView.tag = 11;
        
        _rightImageView.tap_delegate    = self;
        _rightImageView.backgroundColor = BASEGRYCOLOR;
        [self addSubview:_rightImageView];
        
        UILabel *photoLine = [UILabel new];
        photoLine.frame    = CGRectMake(0, CGRectGetMaxY(_leftImageView.frame), selfWidth, .5);
        photoLine.backgroundColor = [UIColor whiteColor];
        photoLine.alpha    = .8;
        [self addSubview:photoLine];
        
        
        // 循环创建Label
        for (int a = 0; a < 26; a++) {
            UILabel *dataLabel = [UILabel new];
            dataLabel.frame    = CGRectMake(0,
                                            CGRectGetMaxY(photoLine.frame) + (Adaptive(40.5) * a),
                                            selfWidth,
                                            Adaptive(40));
            dataLabel.tag       = a + 101;
            dataLabel.textColor = [UIColor whiteColor];
            dataLabel.textAlignment = 1;
            dataLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
            [self addSubview:dataLabel];
            
            UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(dataLabel.frame) ,
                                                                      selfWidth,
                                                                      0.5)];
            line.backgroundColor = [UIColor whiteColor];
            line.alpha           = .8;
            
            [self addSubview:line];
            
//            if (a == 23) {
//                // 创建静态心率按钮
//                jtxlButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//                jtxlButton.frame     = CGRectMake(0,
//                                                  CGRectGetMaxY(photoLine.frame) + Adaptive(40.5)*a,
//                                                  selfWidth,
//                                                  Adaptive(40));
//               // jtxlButton.backgroundColor = ORANGECOLOR;
//                [jtxlButton addTarget:self action:@selector(jtxlButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//                [self addSubview:jtxlButton];
//            }
            
        }
    }
    return self;
}

////表随键盘高度变化
//-(void)keyboardShow:(NSNotification *)note
//{
//    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat deltaY = keyBoardRect.size.height;
//    
//    textView.frame = CGRectMake(0, viewHeight - deltaY - Adaptive(42), viewWidth, Adaptive(42));
//    
//}
//-(void)keyboardHide:(NSNotification *)note
//{
//    [self removeKey];
//}
//-(void)magnifyImage:(UIGestureRecognizer *)gesture
//{
//    [self removeKey];
//}
//- (void)jtxlButtonClick:(UIButton *)button {
//    
//   [app.window addSubview:alphaView];
//    [textView.textField becomeFirstResponder];
//    [app.window addSubview:textView];
//}
//
//- (void)CommentButtonClick:(UIButton *)button {
//    
//    NSString *url = [NSString stringWithFormat:@"%@api/?method=body.modifydata&key=static_heart_rate",BASEURL];
//    NSDictionary *dict = @{@"value":textView.textField.text,
//                           @"id":data_id};
//    [HttpTool postWithUrl:url params:dict body:nil progress:^(NSProgress *progress) {
//        
//    } success:^(id responseObject) {
//        [self removeKey];
//        [(UILabel *)[self viewWithTag:124] setText:dataModel.static_heart_rate];
//        [(UILabel *)[self viewWithTag:126] setText:dataModel.target_heart_rate];
//    }];
//    
//}
//
//- (void)removeKey {
//    [alphaView removeFromSuperview];
//    [textView.textField resignFirstResponder];
//    textView.frame = CGRectMake(0, viewHeight - NavigationBar_Height, viewWidth, Adaptive(42));
//    [textView removeFromSuperview];
//    
//}

#pragma mark -
#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < 2; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        
        TapImageView *tmpView = (TapImageView *)[self viewWithTag: 10+i];
        
        //  NSLog(@"tmpView %@",tmpView);
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:app.window];
        
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark - custom delegate
- (void)tappendWithObject:(id)sender
{
    
    markView.alpha = 0.0;
    markView.backgroundColor = [UIColor blackColor];
    
    [self bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = sender;
    currentIndex = tmpView.tag - 10;
    // NSLog(@"tmpView %@",tmpView);
    
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:app.window];
    
    
    
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex * viewWidth;
    myScrollView.contentOffset = contentOffset;
    
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

- (void) tapImageViewTappedWithObject:(id)sender
{
    
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
    
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
}



- (void)setDataModel:(MyDataModel *)dataModel {
    
  //  data_id = dataModel.data_id;
    
   
    
    dateLabel.text = dataModel.time;
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.leftImageUrl] ];
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.rightImageUrl] ];
    
    [(UILabel *)[self viewWithTag:101] setText:dataModel.height];
    [(UILabel *)[self viewWithTag:102] setText:dataModel.weight];
    [(UILabel *)[self viewWithTag:103] setText:dataModel.waistline];
    [(UILabel *)[self viewWithTag:104] setText:dataModel.hip];
    [(UILabel *)[self viewWithTag:105] setText:dataModel.rham];
    [(UILabel *)[self viewWithTag:106] setText:dataModel.lham];
    [(UILabel *)[self viewWithTag:107] setText:dataModel.rcrus];
    [(UILabel *)[self viewWithTag:108] setText:dataModel.lcrus];
    [(UILabel *)[self viewWithTag:109] setText:dataModel.rtar];
    [(UILabel *)[self viewWithTag:110] setText:dataModel.rtaqj];
    [(UILabel *)[self viewWithTag:111] setText:dataModel.ltar];
    [(UILabel *)[self viewWithTag:112] setText:dataModel.ltaqj];
    [(UILabel *)[self viewWithTag:113] setText:dataModel.bust_relax];
    [(UILabel *)[self viewWithTag:114] setText:dataModel.bust_exp];
    [(UILabel *)[self viewWithTag:115] setText:dataModel.gstj];
    [(UILabel *)[self viewWithTag:116] setText:dataModel.kjsy];
    [(UILabel *)[self viewWithTag:117] setText:dataModel.jjxy];
    [(UILabel *)[self viewWithTag:118] setText:dataModel.abdomen];
    [(UILabel *)[self viewWithTag:119] setText:dataModel.fat_ham];
    [(UILabel *)[self viewWithTag:120] setText:dataModel.total];
    [(UILabel *)[self viewWithTag:121] setText:dataModel.fat];
    [(UILabel *)[self viewWithTag:122] setText:dataModel.ytbl];
    [(UILabel *)[self viewWithTag:123] setText:dataModel.bmi];
    [(UILabel *)[self viewWithTag:124] setText:dataModel.static_heart_rate];
    [(UILabel *)[self viewWithTag:125] setText:dataModel.blood_pressure];
    [(UILabel *)[self viewWithTag:126] setText:dataModel.target_heart_rate];
}

@end
