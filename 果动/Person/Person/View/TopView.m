//
//  TopView.m
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "AppDelegate.h"
#import "TopView.h"
#import "PersonViewController.h"

@interface TopView ()

@end



@implementation TopView
{
    NSString     *headImgUrl;
    UIScrollView *myScrollView;
    NSInteger     currentIndex;
    UIView       *markView;
    UIView       *scrollPanel;
    AppDelegate *app;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ORANGECOLOR;
        [self createUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markTopView:) name:@"Top" object:nil];
    }
    return self;
}

- (void)markTopView:(NSNotification *)notification {
    headImgUrl = [notification.userInfo objectForKey:@"headImageUrl"];
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:headImgUrl]
                      placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    _nameLabel.text = [notification.userInfo objectForKey:@"nickName"];
}

- (void)createUI {
    
    app = [UIApplication sharedApplication].delegate;
    
    scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    scrollPanel.backgroundColor = [UIColor clearColor];
    scrollPanel.alpha = 0;
    [app.window addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    markView.backgroundColor = [UIColor blackColor];
    markView.alpha = 0.0;
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = viewHeight;
    contentSize.width  = viewWidth;
    myScrollView.contentSize = contentSize;
    
    
    
    
    UIImageView *baseImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               viewWidth,
                                                                               Adaptive(155))];
    baseImageView.image = [UIImage imageNamed:@"person_topImage"];
    baseImageView.userInteractionEnabled = YES;
    [self addSubview:baseImageView];
    
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setButton.frame     = CGRectMake(viewWidth - Adaptive(13) - Adaptive(17),
                                     Adaptive(25),
                                     Adaptive(20),
                                     Adaptive(20));
    [setButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [setButton setBackgroundImage:[UIImage imageNamed:@"person_setImage"] forState:UIControlStateNormal];
    [self addSubview:setButton];
    
    // 背景图不居中  手动设置高度
    _headImageView = [[TapImageView alloc] init];
    _headImageView.frame = CGRectMake(Adaptive(156),
                                      Adaptive(41),
                                      Adaptive(65),
                                      Adaptive(65));
    _headImageView.tap_delegate = self;
    _headImageView.tag = 10;
    _headImageView.layer.cornerRadius  = _headImageView.bounds.size.width / 2;
    _headImageView.layer.masksToBounds = YES;
    _headImageView.image               = [UIImage imageNamed:@"person_nohead"];
    [self addSubview:_headImageView];
    
    
    _nameLabel       = [UILabel new];
    _nameLabel.frame = CGRectMake(0,
                                  self.bounds.size.height - Adaptive(20) - Adaptive(13),
                                  viewWidth,
                                  Adaptive(20));
    _nameLabel.textAlignment = 1;
    _nameLabel.font          = [UIFont fontWithName:FONT size:Adaptive(12)];
    _nameLabel.text          = @"果动";
    [self addSubview:_nameLabel];
    
    /*********************************************/
    
    
}
#pragma mark -
#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    
    for (int i = 0; i < 1; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        
        TapImageView *tmpView = (TapImageView *)[self viewWithTag:10 + i];
        
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
    [self bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = sender;
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
#pragma mark - 设置按钮点击事件
- (void)setButtonClick:(UIButton *)button {
    
    PersonViewController *person = [PersonViewController sharedViewControllerManager];
    person.pushSetVCBlock(headImgUrl);
}

@end
