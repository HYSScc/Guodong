//
//  MyDairyPhotoCell.m
//  果动
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "ImgScrollerView.h"
#import "TapImageView.h"
#import "AppDelegate.h"

#import "MyDairyModel.h"
#import "MyDairyPhotoCell.h"

@interface MyDairyPhotoCell ()<TapImageViewDelegate,ImgScrollViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    NSInteger     currentIndex;
    UIView       *markView;
    UIView       *scrollPanel;
    NSMutableArray *imageArray;
    AppDelegate *app;
}

@end

@implementation MyDairyPhotoCell
{
    UILabel     *verticalLine;
    UIImageView *photoImageView;
    UILabel     *photoLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = BASECOLOR;
        
        verticalLine = [UILabel new];
        verticalLine.backgroundColor = ORANGECOLOR;
        [self addSubview:verticalLine];
        
        app = [UIApplication sharedApplication].delegate;
        
        scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        scrollPanel.alpha = 0;
        scrollPanel.backgroundColor = [UIColor clearColor];
        
        [app.window addSubview:scrollPanel];
        
        markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
        
        
        [scrollPanel addSubview:markView];
        
        myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        [scrollPanel addSubview:myScrollView];
        myScrollView.pagingEnabled = YES;
        myScrollView.delegate = self;

    }
    return self;
}


- (void)setDairy:(MyDairyModel *)dairy {
    
    CGFloat allWidth   = viewWidth - Adaptive(65.5);
    CGFloat imageWidth = (allWidth - Adaptive(20)) / 3;
    
    [photoLine removeFromSuperview];
    
    imageArray = (NSMutableArray *)dairy.photoArray;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = viewHeight;
    contentSize.width  = viewWidth *dairy.photoArray.count;
    myScrollView.contentSize = contentSize;

    
    
    if (dairy.photoArray.count % 3 == 0) {
        for (int a = 1; a < 5 * ((dairy.photoArray.count / 3)); a++) {
            
            photoLine = [UILabel new];
            photoLine.frame    = CGRectMake(Adaptive(31),
                                            a * (imageWidth / 4 + Adaptive(1)),
                                            viewWidth - Adaptive(65.5),
                                            .5);
            photoLine.tag      = a + 2;
            photoLine.backgroundColor = BASEGRYCOLOR;
            [self addSubview:photoLine];
            
        }
    } else {
        for (int a = 1; a < 5 * ((dairy.photoArray.count / 3) + 1); a++) {
            
            photoLine = [UILabel new];
            photoLine.frame    = CGRectMake(Adaptive(31),
                                            a * (imageWidth / 4 + Adaptive(1)),
                                            viewWidth - Adaptive(65.5),
                                            .5);
            photoLine.tag      = a + 2;
            photoLine.backgroundColor = BASEGRYCOLOR;
            [self addSubview:photoLine];
            
        }
    }
    
   
    
    for (int a = 0; a < 9; a++) {
        
        TapImageView * imageView = [TapImageView new];
        imageView.frame = CGRectMake(Adaptive(31) + (imageWidth + Adaptive(10)) * (a % 3),
                                     Adaptive(5) + (imageWidth + Adaptive(6)) * (a / 3),
                                     imageWidth,
                                     imageWidth);
        imageView.tap_delegate = self;
        imageView.tag = 100 + a;
        [self addSubview:imageView];
    }

    
    for (int a = 0; a < 9; a++) {
        TapImageView *tapImageView = (TapImageView*)[self viewWithTag:100 + a];
        if (a < dairy.photoArray.count) {
            tapImageView.hidden = NO;
             NSDictionary *imageDict = dairy.photoArray[a];
            [tapImageView sd_setImageWithURL:[NSURL URLWithString:[imageDict objectForKey:@"img"]]];
        } else {
            tapImageView.hidden = YES;
        }
    }

    
    UILabel *line;
    if (dairy.photoArray.count % 3 == 0) {
       line = (UILabel *)[self viewWithTag:5 * ((dairy.photoArray.count / 3))];
    } else {
       line = (UILabel *)[self viewWithTag:5 * ((dairy.photoArray.count / 3) + 1)];
    }
    
    
    
    UILabel *moreLine = [UILabel new];
    moreLine.frame    = CGRectMake(Adaptive(31),
                                   CGRectGetMaxY(line.frame) + Adaptive(23.5) + (imageWidth / 4),
                                   viewWidth - Adaptive(65.5),
                                   .5);
    moreLine.backgroundColor = BASEGRYCOLOR;
    [self addSubview:moreLine];
    
    if (dairy.userContent.length == 0) {
        _addUserButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addUserButton.frame = CGRectMake(viewWidth - Adaptive(27.5),
                                          CGRectGetMaxY(moreLine.frame) - Adaptive(17.5),
                                          Adaptive(14.5),
                                          Adaptive(17.5));
        [_addUserButton setBackgroundImage:[UIImage imageNamed:@"MyDairy_add"] forState:UIControlStateNormal];
        [self addSubview:_addUserButton];
        
    }
   
    
    
    CGRect Frame       = self.frame;
    verticalLine.frame = CGRectMake(Adaptive(18.5),
                                    0,
                                    1,
                                    CGRectGetMaxY(moreLine.frame));
    
    Frame.size.height  = CGRectGetMaxY(verticalLine.frame);
    self.frame         = Frame;
    
}
#pragma mark -
#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < imageArray.count; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        
        TapImageView *tmpView = (TapImageView *)[self viewWithTag: 100+i];
        
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
    currentIndex = tmpView.tag - 100;
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

@end
