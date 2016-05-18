//
//  ClassViewController.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#define  resultCoachNumber  6 // 教练个数

#import "ClassViewController.h"
#import "FinderViewController.h"
#import "CityViewController.h"

#import "LocationView.h"      // 定位视图
#import "SDCycleScrollView.h" // 第三方ScrollView

#import "ClassView.h"         // 课程视图
#import "ShopView.h"          // 体验店

#import "HomeModel.h"

@interface ClassViewController ()<UIScrollViewDelegate>
{
    HomeModel         *homeModel;
    LocationView      *locationView;
    BOOL              isLocationSucceed;
    SDCycleScrollView *bannerScroll;
    UIScrollView      *coachHeaderScroll;
    int               timeCount;
    CGFloat           coachScrollHeight;
    
    UIImageView       *chooseImageView;
    UILabel           *chooseClassLabel;
    UILabel           *chooseShopLabel;
    
    ClassView         *classView;
    ShopView          *shopView;
    
}
@end

@implementation ClassViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if (!isLocationSucceed) {
        CABasicAnimation* basic1 =
        [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        basic1.fromValue = [NSNumber numberWithFloat:0];
        basic1.byValue   = [NSNumber numberWithFloat:M_PI * 2];
        basic1.repeatCount = 10000;
        basic1.duration    = 1.5;
        [locationView.topLocationImageView.layer addAnimation:basic1
                                                       forKey:@"basic1"];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置CGRectZero从导航栏下开始计算
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = BASECOLOR;
    coachScrollHeight         = viewWidth / resultCoachNumber;
    
    // 创建BannerScrollView
    [self createBannerScrollView];
    
    // 创建选择视图
    [self createChooseView];
    
    
    
    // 请求数据
    [self startRequest];
    
    /**
     *  设置Navgation 的titleView
     */
    UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                                0,
                                                                Adaptive(51.6),
                                                                Adaptive(27))];
    UIImageView* titleImage =[[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          titleView.bounds.size.width,
                                                                          titleView.bounds.size.height)];
    titleImage.image  = [UIImage imageNamed:@"shouye_titleImage"];
    
    
    [titleView addSubview:titleImage];
    self.navigationItem.titleView = titleView;
    
    /***********定位视图****************/
    
    locationView       = [LocationView sharedViewManager];
    locationView.frame = CGRectMake(0,
                                    Adaptive(27),
                                    Adaptive(80),
                                    Adaptive(20));
    
    UIBarButtonItem* cityButtonItem       = [[UIBarButtonItem alloc] initWithCustomView:locationView];
    self.navigationItem.leftBarButtonItem = cityButtonItem;
    
    /**************Block函数************************/
    
    __block ClassViewController *class = self;
    
    //跳转到cityViewController
    self.pushCityViewController = ^(NSString* cityName) {
        
        CityViewController *cityVC = [CityViewController new];
        cityVC.cityName            = cityName;
        [class.navigationController pushViewController:cityVC animated:YES];
    };
    /**********************************************/
}

#pragma mark - 请求数据
- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@/api/?method=index.index",BASEURL];
    [HttpTool postWithUrl:url params:nil success:^(id responseObject) {
        
        homeModel = [[HomeModel alloc] initWithDictionary:responseObject];
        
        bannerScroll.imageURLStringsGroup = homeModel.bannerArray;
        // 创建CoachScrollView
        [self createCoachHeaderScrollView];
        // 创建课程和体验店视图
        [self createClassViewAndShopView];
    }];
}

#pragma mark - 创建BannerScrollView
- (void)createBannerScrollView {
    
    bannerScroll = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       viewWidth,
                                                                       Adaptive(125))];
    bannerScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    bannerScroll.pageControlStyle   = SDCycleScrollViewPageContolStyleAnimated;
    bannerScroll.autoScrollTimeInterval = 5.0;
    bannerScroll.userInteractionEnabled = YES;
    [self.view addSubview:bannerScroll];
}
#pragma mark - 创建CoachHeaderScrollView
- (void)createCoachHeaderScrollView {
    
    
    
    coachHeaderScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0,
                                                                       CGRectGetMaxY(bannerScroll.frame),
                                                                       viewWidth,
                                                                       coachScrollHeight)];
    coachHeaderScroll.bounces       = YES;  //是否允许弹性滑动
    coachHeaderScroll.delegate      = self;    //代理
    coachHeaderScroll.contentSize   = CGSizeMake(viewWidth, coachScrollHeight);
    coachHeaderScroll.userInteractionEnabled = YES;  //交互性
    [self.view addSubview:coachHeaderScroll];
    
    NSInteger arrayCount = resultCoachNumber;
    
    if ([homeModel.coach_imgArray count] > 6) {
        
        arrayCount                    = [homeModel.coach_imgArray count];
        coachHeaderScroll.contentSize = CGSizeMake(coachScrollHeight * arrayCount,
                                                   coachScrollHeight);
        
        // 使用NSTimer实现定时触发滚动控件滚动的动作。
        timeCount  = 0;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scrollTimer) userInfo:nil repeats:YES];
    }
    for (int i = 0; i < arrayCount; i ++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame        = CGRectMake(coachScrollHeight * i,
                                            0,
                                            coachScrollHeight - 1,
                                            coachScrollHeight);
        imageView.backgroundColor = [UIColor whiteColor];
        
        if (i < [homeModel.coach_imgArray count]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:homeModel.coach_imgArray[i]]];
        }
        
        [coachHeaderScroll addSubview:imageView];
    }
}
//定时滚动
-(void)scrollTimer{
    timeCount ++;
    if (timeCount == [homeModel.coach_imgArray count]) {
        timeCount = 0;
    }
    
    [coachHeaderScroll scrollRectToVisible:CGRectMake(timeCount * coachScrollHeight,
                                                      0,
                                                      coachScrollHeight,
                                                      coachScrollHeight)
                                  animated:YES];
}

#pragma mark - 创建选择视图
- (void)createChooseView {
    chooseImageView = [[UIImageView alloc]
                       initWithFrame:CGRectMake(0,
                                                CGRectGetMaxY(bannerScroll.frame) +coachScrollHeight+ Adaptive(5),
                                                viewWidth,
                                                Adaptive(30))];
    [chooseImageView setImage:[UIImage imageNamed:@"shouye_classImage"]];
    chooseImageView.userInteractionEnabled = YES;
    [self.view addSubview:chooseImageView];
    
    chooseClassLabel = [[UILabel alloc]
                        initWithFrame:CGRectMake(
                                                 viewWidth / 4 - Adaptive(20),
                                                 (chooseImageView.bounds.size.height - Adaptive(30)) / 2,
                                                 Adaptive(40), Adaptive(30))];
    chooseClassLabel.textColor = [UIColor whiteColor];
    chooseClassLabel.text = @"课程";
    chooseClassLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [chooseImageView addSubview:chooseClassLabel];
    
    chooseShopLabel = [[UILabel alloc]
                       initWithFrame:CGRectMake(
                                                (viewWidth * 3 / 4) - Adaptive(20),
                                                (chooseImageView.bounds.size.height - Adaptive(30)) / 2,
                                                Adaptive(50), Adaptive(30))];
    chooseShopLabel.textColor = [UIColor whiteColor];
    chooseShopLabel.text = @"体验店";
    chooseShopLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    [chooseImageView addSubview:chooseShopLabel];
    
    UIButton* classButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    classButton.frame = CGRectMake(0, 0, viewWidth / 2, Adaptive(50));
    classButton.tag = 11;
    [classButton addTarget:self
                    action:@selector(changeClass:)
          forControlEvents:UIControlEventTouchUpInside];
    [chooseImageView addSubview:classButton];
    
    UIButton* frameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    frameButton.frame = CGRectMake(viewWidth / 2, 0, viewWidth / 2, Adaptive(50));
    frameButton.tag = 22;
    [frameButton addTarget:self
                    action:@selector(changeClass:)
          forControlEvents:UIControlEventTouchUpInside];
    [chooseImageView addSubview:frameButton];
}
- (void)changeClass:(UIButton*)button
{
    if (button.tag == 11) {
        [chooseImageView setImage:[UIImage imageNamed:@"shouye_classImage"]];
        
         [shopView removeFromSuperview];
         [self.view addSubview:classView];
    } else {
        [chooseImageView setImage:[UIImage imageNamed:@"shouye_shopImage"]];
        
         [classView removeFromSuperview];
         [self.view addSubview:shopView];
    }
}

#pragma mark - 创建课程和体验店视图
- (void)createClassViewAndShopView {
    
     CGFloat LeftHeight = LastHeight - CGRectGetMaxY(chooseImageView.frame) - Adaptive(5);
    
    /*************左视图|课程****************/
    classView = [[ClassView alloc] initWithFrame:CGRectMake(0,
                                                            CGRectGetMaxY(chooseImageView.frame) + Adaptive(5),
                                                            viewWidth,
                                                            LeftHeight)];
    classView.home = homeModel;
    [self.view addSubview:classView];
    /*************右视图|体验店****************/
    shopView = [[ShopView alloc] initWithFrame:CGRectMake(0,
                                                            CGRectGetMaxY(chooseImageView.frame) + Adaptive(5),
                                                            viewWidth,
                                                            LeftHeight)];
}

#pragma mark - 移除定位动画
- (void)removeLocationAnimation {
    
    isLocationSucceed = YES;
    [locationView.topLocationImageView.layer removeAllAnimations];
}
#pragma mark - 单例
+ (instancetype)sharedViewControllerManager
{
    static dispatch_once_t onceToken;
    static ClassViewController* viewController;
    
    dispatch_once(&onceToken, ^{
        viewController = [[ClassViewController alloc] init];
    });
    
    return viewController;
}
@end
