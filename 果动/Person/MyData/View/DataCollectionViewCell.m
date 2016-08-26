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
        
        
        UILabel *orangeLine = [UILabel new];
        orangeLine.frame    = CGRectMake(0,
                                         Adaptive(6.5),
                                         selfWidth,
                                         1);
        orangeLine.backgroundColor = ORANGECOLOR;
        [self addSubview:orangeLine];
        
        
        UIImageView *ringImageView = [UIImageView new];
        ringImageView.frame        = CGRectMake((selfWidth - Adaptive(13)) / 2,
                                                0,
                                                Adaptive(13),
                                                Adaptive(13));
        ringImageView.image = [UIImage imageNamed:@"person_data_ring"];
        [self addSubview:ringImageView];
        
        
        dateLabel       = [UILabel new];
        dateLabel.frame = CGRectMake(0,
                                     CGRectGetMaxY(ringImageView.frame) + Adaptive(4.75),
                                     selfWidth,
                                     Adaptive(9));
        dateLabel.textColor = ORANGECOLOR;
        dateLabel.font      = [UIFont fontWithName:FONT size:Adaptive(9)];
        dateLabel.textAlignment = 1;
        [self addSubview:dateLabel];
        
        
        
        CGFloat imageWidth  = Adaptive(56);
        CGFloat imageHeight = Adaptive(115);
        
        _leftImageView = [[TapImageView alloc] initWithFrame:CGRectMake(Adaptive(2),
                                                                        CGRectGetMaxY(dateLabel.frame) + Adaptive(4.75),
                                                                        imageWidth,
                                                                        imageHeight)];
        
        _leftImageView.tag = 10;
        _leftImageView.tap_delegate    = self;
        _leftImageView.backgroundColor = BASEGRYCOLOR;
        [self addSubview:_leftImageView];
        
        _rightImageView       = [[TapImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImageView.frame) + Adaptive(1),
                                                                               CGRectGetMaxY(dateLabel.frame) + Adaptive(4.75),
                                                                               imageWidth,
                                                                               imageHeight)];
        _rightImageView.tag = 11;
        _rightImageView.contentMode = UIViewContentModeScaleAspectFill;
        _rightImageView.tap_delegate    = self;
        _rightImageView.backgroundColor = BASEGRYCOLOR;
        [self addSubview:_rightImageView];
        
        UILabel *photoLine = [UILabel new];
        photoLine.frame    = CGRectMake(0, CGRectGetMaxY(_leftImageView.frame), selfWidth, Adaptive(1));
        photoLine.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
        
        [self addSubview:photoLine];
        
        
        // 循环创建Label
        for (int a = 0; a < 26; a++) {
            UILabel *dataLabel = [UILabel new];
            dataLabel.frame    = CGRectMake(0,
                                            CGRectGetMaxY(photoLine.frame) + (Adaptive(40) * a),
                                            selfWidth,
                                            Adaptive(40));
            dataLabel.tag       = a + 101;
            dataLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
            dataLabel.textAlignment = 1;
            dataLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
            [self addSubview:dataLabel];
            
            UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                      CGRectGetMaxY(dataLabel.frame) - Adaptive(1),
                                                                      selfWidth,
                                                                      Adaptive(1))];
            line.backgroundColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
            
            [self addSubview:line];
            
            
          
            
            
        }
    }
    return self;
}

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
    
    dateLabel.text = dataModel.time;
    
    
    
    [_leftImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.leftImageUrl]];
    
    
    
    [_rightImageView sd_setImageWithURL:[NSURL URLWithString:dataModel.rightImageUrl] ];
    /*
     NSArray* titleArray = @[@"照片",@"身高", @"体重", @"腰围", @"臀围", @"脂肪百分比  ", @"BMI",@"腰臀比例", @"右大腿", @"左大腿", @"右小腿", @"左小腿", @"左上臂(放松)", @"左上臂(屈曲)", @"右上臂(放松)", @"右上臂(屈曲)", @"胸围(放松)", @"胸围(扩张)", @"肱三头肌皮脂", @"髋嵴上缘皮脂", @"肩胛下缘皮脂", @"腹部皮脂", @"大腿皮脂", @"皮脂总和",  @"静态心率", @"血压", @"目标心率" ];
     
     */
    
    [(UILabel *)[self viewWithTag:101] setText:dataModel.height];
    [(UILabel *)[self viewWithTag:102] setText:dataModel.weight];
    [(UILabel *)[self viewWithTag:103] setText:dataModel.waistline];
    [(UILabel *)[self viewWithTag:104] setText:dataModel.hip];
    [(UILabel *)[self viewWithTag:105] setText:dataModel.fat];
    [(UILabel *)[self viewWithTag:106] setText:dataModel.bmi];
    [(UILabel *)[self viewWithTag:107] setText:dataModel.ytbl];
    [(UILabel *)[self viewWithTag:108] setText:dataModel.rham];
    [(UILabel *)[self viewWithTag:109] setText:dataModel.lham];
    [(UILabel *)[self viewWithTag:110] setText:dataModel.rcrus];
    [(UILabel *)[self viewWithTag:111] setText:dataModel.lcrus];
    [(UILabel *)[self viewWithTag:112] setText:dataModel.ltar];
    [(UILabel *)[self viewWithTag:113] setText:dataModel.ltaqj];
    [(UILabel *)[self viewWithTag:114] setText:dataModel.rtar];
    [(UILabel *)[self viewWithTag:115] setText:dataModel.rtaqj];
    [(UILabel *)[self viewWithTag:116] setText:dataModel.bust_relax];
    [(UILabel *)[self viewWithTag:117] setText:dataModel.bust_exp];
    [(UILabel *)[self viewWithTag:118] setText:dataModel.gstj];
    [(UILabel *)[self viewWithTag:119] setText:dataModel.kjsy];
    [(UILabel *)[self viewWithTag:120] setText:dataModel.jjxy];
    [(UILabel *)[self viewWithTag:121] setText:dataModel.abdomen];
    [(UILabel *)[self viewWithTag:122] setText:dataModel.fat_ham];
    [(UILabel *)[self viewWithTag:123] setText:dataModel.total];
    [(UILabel *)[self viewWithTag:124] setText:dataModel.static_heart_rate];
    [(UILabel *)[self viewWithTag:125] setText:dataModel.blood_pressure];
    [(UILabel *)[self viewWithTag:126] setText:dataModel.target_heart_rate];
}

@end
