//
//  QuestionContentCell.m
//  果动
//
//  Created by mac on 16/6/6.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "QuestionContentCell.h"
#import "QuestionContent.h"

#import "ImgScrollerView.h"
#import "TapImageView.h"
#import "AppDelegate.h"
@interface QuestionContentCell ()<TapImageViewDelegate,ImgScrollViewDelegate,UIScrollViewDelegate>
{
    UIScrollView *myScrollView;
    NSInteger     currentIndex;
    UIView       *markView;
    UIView       *scrollPanel;
    NSMutableArray *imageArray;
    AppDelegate *app;
}
@end

@implementation QuestionContentCell
{
    UIImageView *headImageView;
    UILabel     *nickNameLabel;
    UILabel     *timeLabel;
    UILabel     *contentLabel;
    TapImageView *contentImageView;
    UILabel     *line;
    NSString    *user_id;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        [contentImageView removeFromSuperview];
        
        
        self.backgroundColor = [UIColor colorWithRed:55/255.0
                                               green:55/255.0
                                                blue:55/255.0
                                               alpha:1];
        
        imageArray = [NSMutableArray array];
        
        UILabel *gryLabel = [UILabel new];
        gryLabel.frame    = CGRectMake(0, 0, viewWidth, Adaptive(10));
        gryLabel.backgroundColor = BASECOLOR;
        [self addSubview:gryLabel];
        
        
        headImageView       = [UIImageView new];
        headImageView.frame = CGRectMake(Adaptive(13),CGRectGetMaxY(gryLabel.frame) + Adaptive(10), Adaptive(37), Adaptive(37));
        headImageView.layer.cornerRadius  = headImageView.bounds.size.width / 2;
        headImageView.layer.masksToBounds = YES;
        headImageView.userInteractionEnabled = YES;
        [self addSubview:headImageView];
        
        UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserPublick:)];
        [headImageView addGestureRecognizer:tapLeftDouble];
        
        
        nickNameLabel       = [UILabel new];
        nickNameLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(5),
                                         Adaptive((10 + 19 )),
                                         Adaptive(100),
                                         Adaptive(16));
        nickNameLabel.font  = [UIFont fontWithName:FONT size:Adaptive(13)];
        nickNameLabel.textColor = [UIColor whiteColor];
        [self addSubview:nickNameLabel];
        
        timeLabel       = [UILabel new];
        timeLabel.frame = CGRectMake(viewWidth - Adaptive((13 + 100)),
                                     Adaptive((10 + 19)),
                                     Adaptive(100),
                                     Adaptive(12));
        timeLabel.font  = [UIFont fontWithName:FONT size:Adaptive(11)];
        timeLabel.textColor = [UIColor grayColor];
        timeLabel.textAlignment = 2;
        [self addSubview:timeLabel];
        
        contentLabel           = [UILabel new];
        contentLabel.textColor = [UIColor whiteColor];
      //  contentLabel.backgroundColor = [UIColor orangeColor];
        contentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        contentLabel.numberOfLines = 0;
        [self addSubview:contentLabel];
        
        line                 = [UILabel new];
        line.backgroundColor = BASECOLOR;
        [self addSubview:line];
        
        
        
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
        
        TapImageView *tmpView = (TapImageView *)[self viewWithTag: 10+i];
        
      //  NSLog(@"tmpView %@",tmpView);
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:app.window];
       
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
       //  NSLog(@".......... %@",tmpView.image);
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
    
    TapImageView *tmp = sender;
    TapImageView *tmpView = (TapImageView *)[self viewWithTag:tmp.tag];
   
    currentIndex = tmpView.tag - 10;
   
    
    
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


- (void)pushUserPublick:(UIGestureRecognizer *)gesture {
    
    NSNotification *notification = [[NSNotification alloc] initWithName:@"questionContentPushUser" object:nil userInfo:@{@"user_id":user_id}];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)setContentModel:(QuestionContent *)contentModel {
    
    user_id    = contentModel.user_id;
    // 图片放大
    imageArray = contentModel.photoArray;
    
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = viewHeight;
    contentSize.width  = viewWidth *contentModel.photoArray.count;
    myScrollView.contentSize = contentSize;

    [headImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.headImgString] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    nickNameLabel.text = contentModel.nickName;
    timeLabel.text     = contentModel.timeString;
    
    CGSize contentTextSize = [contentModel.content boundingRectWithSize:CGSizeMake(viewWidth - Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(14)]} context:nil].size;
    
    
    contentLabel.frame = CGRectMake(Adaptive(13),
                                    CGRectGetMaxY(headImageView.frame) +Adaptive(10),
                                    viewWidth - Adaptive(26),
                                    contentTextSize.height);
    
    
    // 调整行间距
    contentLabel.attributedText = [HttpTool setLinespacingWith:contentModel.content space:4];
    [contentLabel sizeToFit];
    
    
    CGFloat imageWidth    = (viewWidth - Adaptive(36)) / 3;
    CGRect  CellFrame     = self.frame;
    CGFloat imageViewMaxY = 0;
    
    for (int a = 0; a < 9; a++) {
        
        TapImageView * imageView = [TapImageView new];
        
        
        imageView.frame = CGRectMake(Adaptive(13) + (a%3)*(imageWidth + Adaptive(5)),
                                     CGRectGetMaxY(contentLabel.frame) +Adaptive(10)+(a/3)*(imageWidth + Adaptive(5)),
                                     imageWidth,
                                     imageWidth);
        imageView.tap_delegate = self;
        imageView.tag = 10 + a;
       
        [self addSubview:imageView];
    }
    
        for (int a = 0; a < 9; a++) {
            TapImageView *tapImageView = (TapImageView*)[self viewWithTag:10 + a];
           
            if (a < contentModel.photoArray.count) {
                
               
                tapImageView.hidden = NO;
                
                [tapImageView sd_setImageWithURL:[NSURL URLWithString:contentModel.photoArray[a]]];
           //     NSLog(@"tapImageView.image %@",tapImageView.image);
                
            } else {
                tapImageView.hidden = YES;
            }
        }
        
        
        if (contentModel.photoArray.count % 3 == 0) {
            imageViewMaxY  = (imageWidth + Adaptive(5)) *((contentModel.photoArray.count/3));
        } else {
            imageViewMaxY  = (imageWidth + Adaptive(5)) *((contentModel.photoArray.count/3) + 1);
        }
//    }
    
    line.frame = CGRectMake(0, CGRectGetMaxY(contentLabel.frame) + Adaptive(10) + imageViewMaxY, viewWidth, .5);
  
    CellFrame.size.height =  CGRectGetMaxY(line.frame);
    self.frame            = CellFrame;
}

@end
