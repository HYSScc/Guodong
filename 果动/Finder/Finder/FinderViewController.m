//
//  FinderViewController.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "LoginViewController.h"
#import "PublishViewController.h"
#import "FinderViewController.h"
#import "FinderPubViewController.h"
#import "NewsDetailsViewController.h"
#import "WebViewController.h"
#import "ContentDetails.h"


#import "NewViewController.h"
#import "QuestionViewController.h"
#import "PictureViewController.h"
@interface FinderViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain) NSMutableArray *viewArray;
@property (nonatomic,retain) NSMutableArray *titleArray;

@property (nonatomic,retain) NewViewController      *newsVC;
@property (nonatomic,retain) PictureViewController  *pictureVC;
@property (nonatomic,retain) QuestionViewController *quesVC;

@end

@implementation FinderViewController
{
    UIScrollView *_tableScroll;  // 中间的scroller
    UIScrollView *_scrollView;   // 移动Scroller
    UIImageView  *moveImageView; // 移动三角
    BOOL         ischoose[3];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

#pragma mark - 三个ViewContrller的懒加载

- (UIViewController *)newsVC {
    
    if (!_newsVC) {
       _newsVC = [NewViewController new];
        _newsVC.view.frame = CGRectMake(viewWidth, 0, viewWidth,_tableScroll.frame.size.height);
        [self addChildViewController:_newsVC];
        [_tableScroll addSubview:_newsVC.view];
    }
    
    return _newsVC;
}
- (UIViewController *)pictureVC {
    
    if (!_pictureVC) {
        _pictureVC = [PictureViewController new];
        _pictureVC.view.frame = CGRectMake(0, 0, viewWidth,_tableScroll.frame.size.height);
        [self addChildViewController:_pictureVC];
        [_tableScroll addSubview:_pictureVC.view];
    }
    
    return _pictureVC;
}
- (UIViewController *)quesVC {
    
    if (!_quesVC) {
        _quesVC = [QuestionViewController new];
        _quesVC.view.frame = CGRectMake(viewWidth * 2, 0, viewWidth,_tableScroll.frame.size.height);
        [self addChildViewController:_quesVC];
        [_tableScroll addSubview:_quesVC.view];
    }
    
    return _quesVC;
}

- (void)addchooseViewControllerWithNumber:(NSInteger )number {
    
    if      (number == 1) [self pictureVC];
    else if (number == 2) [self newsVC];
    else                  [self quesVC];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    self.titleArray  = [NSMutableArray array];
    [self.titleArray addObject:@"图文"];
    [self.titleArray addObject:@"动态"];
    [self.titleArray addObject:@"答疑"];
    
    self.automaticallyAdjustsScrollViewInsets = NO; //必要的一步
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushUserPublick:) name:@"questionContentPushUser" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushLoginView) name:@"pushLoginView" object:nil];
    
    //   添加item 标题Scroller
    [self setUpScrollView];
    //  添加内容容器c
    [self addtableScroll];
    //    添加内容
    [self addContentView];
}

- (void)pushLoginView {
    
    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
}

// 答疑点击头像push到我的发布
- (void)pushUserPublick:(NSNotification *)notification {
    
    PublishViewController *publish = [PublishViewController new];
    publish.user_id = [notification.userInfo objectForKey:@"user_id"];
    [self.navigationController pushViewController:publish animated:YES];
    
}

// 添加item 标题Scroller
- (void)setUpScrollView {
    
    _scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, viewWidth, NavigationBar_Height)];
    _scrollView.backgroundColor = ORANGECOLOR;
    //设置滑动范围
    _scrollView.contentSize     = CGSizeMake(viewWidth, NavigationBar_Height);
    _scrollView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_scrollView];
    
    // 添加点击按钮
    for (int i = 0; i < [_titleArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame     = CGRectMake(viewWidth / _titleArray.count * i,
                                      25,
                                      viewWidth/[_titleArray count],
                                      39);
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        
        //设定按钮文字颜色
        [button setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
        
        // 默认选中第1个
        if (i == 1) [button setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
        
        //设置点击事件
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = i+1;
        //文字大小
        button.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(14)];
        [_scrollView addSubview:button];
    }
    
    _scrollView.bounces = NO;
    //设置提示条目
    moveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth / 2 - 6,56, 12, 8)];
    moveImageView.image = [UIImage imageNamed:@"find_movetrain"];
    [_scrollView addSubview:moveImageView];
    
}

// 添加内容容器
-(void)addtableScroll{
    //添加滑动视图
    _tableScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame), viewWidth, LastHeight )];
    
    _tableScroll.contentSize = CGSizeMake(viewWidth*[_titleArray count],LastHeight);
    
    //设置整页滑动
    _tableScroll.pagingEnabled = YES;
    _tableScroll.delegate      = self;
    _tableScroll.showsVerticalScrollIndicator = NO;
    _tableScroll.contentOffset = CGPointMake(viewWidth, 0);
    _tableScroll.scrollEnabled = YES; //不允许滑动
    [self.view addSubview:_tableScroll];
    
}
//添加内容
-(void)addContentView{

    [self newsVC];
    
}

- (void)titleClick:(UIButton *)button {
    
    UIButton *button1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *button3 = (UIButton *)[self.view viewWithTag:3];
    
    [button1 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
    [button2 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
    [button3 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
    [button  setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
    
    /**
     *  根据button.tag值添加不同的视图
     */
    [self addchooseViewControllerWithNumber:button.tag];
    
    //设定文字颜色
    [UIView animateWithDuration:.2f animations:^{
        
        // 移动滑块
        NSInteger OriginX = button.frame.origin.x + button.bounds.size.width / 2 - 7.5;
        
        moveImageView.frame = CGRectMake(OriginX,56,12,8);
        // 移动主视图
        _tableScroll.contentOffset=CGPointMake((button.tag-1) * viewWidth, 0);
        
    }];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint offset = scrollView.contentOffset;
   
    [UIView animateWithDuration:.2f animations:^{
        
        // 移动滑块
        NSInteger OriginX =  offset.x / 3 + viewWidth / 6 - 7.5;
        
        moveImageView.frame = CGRectMake(OriginX,56,12,8);
        // 移动主视图
        _tableScroll.contentOffset=CGPointMake(offset.x, 0);
        
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    CGPoint offset    = scrollView.contentOffset;
    UIButton *button  = (UIButton *)[self.view viewWithTag:offset.x / viewWidth + 1];
    
    UIButton *button1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *button3 = (UIButton *)[self.view viewWithTag:3];
    
    [button1 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
    [button2 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
    [button3 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
    [button  setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
    
    /**
     *  根据偏移量添加不同的视图
     */
    [self addchooseViewControllerWithNumber:offset.x / viewWidth + 1];
    
}
#pragma mark - 跳转页面方法
- (void)pushNewsDetailsViewWithindex:(NSInteger )index {
    
    NewsDetailsViewController *detailsView = [NewsDetailsViewController new];
    NSString *talk_id   = [NSString stringWithFormat:@"%ld",(long)index];
    detailsView.talk_id = talk_id;
    [self.navigationController pushViewController:detailsView animated:YES];
    
}

- (void)pushWebViewWithName:(NSString *)content_id title:(NSString *)title {
    
    WebViewController *webView = [WebViewController new];
    webView.content_id = content_id;
    webView.sharetitle = title;
    [self.navigationController pushViewController:webView animated:YES];
}

#pragma mark - 单例
+ (instancetype)sharedViewControllerManager
{
    static dispatch_once_t onceToken;
    static FinderViewController* viewController;
    
    dispatch_once(&onceToken, ^{
        viewController = [[FinderViewController alloc] init];
    });
    
    return viewController;
}

@end
