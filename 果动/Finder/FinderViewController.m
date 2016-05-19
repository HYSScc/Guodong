//
//  FinderViewController.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "FinderViewController.h"

@interface FinderViewController ()<UIScrollViewDelegate>

@property (nonatomic,retain) NSMutableArray *viewArray;
@property (nonatomic,retain) NSMutableArray *titleArray;

@end

@implementation FinderViewController
{
    UIScrollView *_tableScroll;  // 中间的scroller
    UIScrollView *_scrollView;   // 移动Scroller
    UIImageView  *moveImageView; // 移动三角
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    self.viewArray       = [NSMutableArray array];
    [self.viewArray addObject:@"PictureTextView"];
    [self.viewArray addObject:@"NewsView"];
    [self.viewArray addObject:@"QuestionView"];
    
    self.titleArray      = [NSMutableArray array];
    [self.titleArray addObject:@"图文"];
    [self.titleArray addObject:@"动态"];
    [self.titleArray addObject:@"答疑"];
    
    self.automaticallyAdjustsScrollViewInsets = NO; //必要的一步
    
    // 添加item 标题Scroller
    [self setUpScrollView];
    // 添加内容容器
    [self addtableScroll];
    // 添加内容
    [self addContentView];
}
// 添加item 标题Scroller
- (void)setUpScrollView {
    
    _scrollView =[[UIScrollView alloc]initWithFrame:CGRectMake(0,0, viewWidth, Adaptive(84))];
    _scrollView.backgroundColor = ORANGECOLOR;
    //设置滑动范围
    _scrollView.contentSize     = CGSizeMake(viewWidth, Adaptive(84));
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    
    // 添加点击按钮
    for (int i = 0; i < [_titleArray count]; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame     = CGRectMake(viewWidth / _titleArray.count * i,
                                      Adaptive(15),
                                      viewWidth/[_titleArray count],
                                      Adaptive(84));
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        
        //设定按钮文字颜色
        [button setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];

        // 默认选中第1个
        if (i == 1) {
            
            [button setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
        }
        
        //设置点击事件
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag =i+1;
        //文字大小
        button.titleLabel.font = [UIFont systemFontOfSize:Adaptive(16)];
        [_scrollView addSubview:button];
    }
    
    _scrollView.bounces = NO;
    //设置提示条目
    moveImageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewWidth / 2 - Adaptive(7.5), Adaptive(74), Adaptive(15), Adaptive(10))];
    moveImageView.image = [UIImage imageNamed:@"find_movetrain"];
    [_scrollView addSubview:moveImageView];
    
}

// 添加内容容器
-(void)addtableScroll{
    //添加滑动视图
    _tableScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollView.frame) + Adaptive(10), viewWidth, viewHeight-CGRectGetMaxY(_scrollView.frame))];
    
    _tableScroll.contentSize = CGSizeMake(viewWidth*[_titleArray count],viewHeight-CGRectGetMaxY(_scrollView.frame) );
    
    //设置整页滑动
    _tableScroll.pagingEnabled = YES;
    _tableScroll.delegate      = self;
    _tableScroll.showsVerticalScrollIndicator = NO;
    _tableScroll.contentOffset = CGPointMake(viewWidth, 0);
    _tableScroll.scrollEnabled = NO; //不允许滑动
    [self.view addSubview:_tableScroll];
    
}
//添加内容
-(void)addContentView{
    
    for (int i = 0; i < [_viewArray count]; i++) {
        
        Class someClass = NSClassFromString(_viewArray[i]);
        UIView * contentView = [[someClass alloc] init];
        [contentView setFrame:CGRectMake(i * viewWidth, 0, viewWidth,_tableScroll.frame.size.height)];
        [_tableScroll addSubview:contentView];
        
    }
}

- (void)titleClick:(UIButton *)button {
    
    UIButton *button1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *button3 = (UIButton *)[self.view viewWithTag:3];
    
    switch (button.tag) {
        case 1:
        {
            [button1 setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
            [button2 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
            [button3 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
        }
            
            break;
        case 2:
        {
            [button1 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
            [button2 setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
            [button3 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
        }
            
            break;
        case 3:
        {
            [button1 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
            [button2 setTitleColor:UIColorFromRGB(0x3f3f3f) forState:UIControlStateNormal];
            [button3 setTitleColor:UIColorFromRGB(0x2b2b2b) forState:UIControlStateNormal];
        }
            
            break;
            
        default:
            break;
    }
    
    //设定文字颜色
   
    
    [UIView animateWithDuration:.2f animations:^{
        
        // 移动滑块
        NSInteger OriginX = button.frame.origin.x + button.bounds.size.width / 2 - Adaptive(7.5);
        
        moveImageView.frame = CGRectMake(OriginX,
                                         Adaptive(74),
                                         Adaptive(15),
                                         Adaptive(10));
        // 移动主视图
        _tableScroll.contentOffset=CGPointMake((button.tag-1)*viewWidth, 0);
        
    }];
}



@end
