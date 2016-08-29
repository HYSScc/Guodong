//
//  ClassViewController.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#define  resultCoachNumber  6 // 教练个数
#import "RefushView.h"
#import "ClassViewController.h"
#import "FinderViewController.h"
#import "CityViewController.h"
#import "activeViewController.h"
#import "LocationView.h"      // 定位视图
#import "SDCycleScrollView.h" // 第三方ScrollView

#import "ClassView.h"         // 课程视图
#import "ShopView.h"          // 体验店
#import "activeModel.h"
#import "HomeModel.h"
#import "AppDelegate.h"
#import "IntroduceViewController.h" // 课程介绍
#import "SetShareViewController.h"
#import "RechargeViewController.h"
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
    RefushView        *refush;
    UIView            *alphaView;
    ClassView         *classView;
    ShopView          *shopView;
    
    
}
@end

@implementation ClassViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden           = NO;
    
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
    
    self.view.backgroundColor = BASECOLOR;
    
   
    

    UIView *navigationView = [UIView new];
    navigationView.frame   = CGRectMake(0, 0, viewWidth, NavigationBar_Height);
    navigationView.backgroundColor = ORANGECOLOR;
    [self.view addSubview:navigationView];
    
    UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake((viewWidth - Adaptive(51.6)) / 2,
                                                                Adaptive(20) + Adaptive((44 - 27)) / 2,
                                                                Adaptive(51.6),
                                                                Adaptive(27))];
    UIImageView* titleImage =[[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          titleView.bounds.size.width,
                                                                          titleView.bounds.size.height)];
    titleImage.image  = [UIImage imageNamed:@"shouye_titleImage"];
    
    
    [titleView addSubview:titleImage];
    [navigationView addSubview:titleView];
    
    /***********定位视图****************/
    
    locationView       = [LocationView sharedViewManager];
    locationView.frame = CGRectMake(Adaptive(13),
                                    Adaptive(20) + Adaptive((44 - 27)) / 2,
                                    Adaptive(80),
                                    Adaptive(20));
    
    [navigationView addSubview:locationView];
    /***************客服****************************/
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoButton.frame     = CGRectMake(viewWidth - Adaptive((13 + 19)),  Adaptive(20) + Adaptive((44 - 27)) / 2, Adaptive(19), Adaptive(19));
    [photoButton setBackgroundImage:[UIImage imageNamed:@"shouye_photo"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(telePhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:photoButton];
    
    /**************Block函数************************/
    
    __weak ClassViewController *class = self;
    
    //跳转到cityViewController
    self.pushCityViewController = ^(NSString* cityName,NSString *isSet) {
        
        class.hidesBottomBarWhenPushed = YES;
        CityViewController *cityVC = [CityViewController new];
        cityVC.cityName            = cityName;
        cityVC.isSet               = isSet;
        [class.navigationController pushViewController:cityVC animated:YES];
        class.hidesBottomBarWhenPushed = NO;
    };
    
    
    //跳转到活动页
    self.pushActiveView = ^(NSString *number) {
        
        activeModel *active = class.activeArray[[number intValue]];
        
        if (active.type == 1) {
            // 1 == iOS界面   2 == 网端
         
            if ([active.name isEqualToString:@"index1"]) {
                
                class.hidesBottomBarWhenPushed = YES;
                RechargeViewController *rechargeVC = [RechargeViewController new];
                [class.navigationController pushViewController:rechargeVC animated:YES];
                class.hidesBottomBarWhenPushed = NO;
                
            } else if ([active.name isEqualToString:@"index3"]) {
                
                class.hidesBottomBarWhenPushed = YES;
                SetShareViewController *setShareView = [SetShareViewController new];
                [class.navigationController pushViewController:setShareView animated:YES];
                class.hidesBottomBarWhenPushed = NO;
                
            } else {
                class.hidesBottomBarWhenPushed          = YES;
                activeViewController *activeVC = [activeViewController new];
                activeVC.name = active.name;
                [class.navigationController pushViewController:activeVC animated:YES];
                class.hidesBottomBarWhenPushed          = NO;
            }
            
        } else {
            class.hidesBottomBarWhenPushed          = YES;
            activeViewController *activeVC = [activeViewController new];
            activeVC.url = active.url;
            [class.navigationController pushViewController:activeVC animated:YES];
            class.hidesBottomBarWhenPushed          = NO;
        }
    };
    
    /********************** 检查版本更新 ****************************/
    refush = [[RefushView alloc] initWithFrame:CGRectMake((viewWidth  - Adaptive(295)) / 2,
                                                          -Adaptive(410),
                                                          Adaptive(295),
                                                          Adaptive(410))];
    [refush.cancelButton addTarget:self action:@selector(cancelButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self onCheckVersion];
    
    coachScrollHeight = viewWidth / resultCoachNumber;
    
    // 创建BannerScrollView
    [self createBannerScrollView];
    
    // 请求数据
    [self startRequest];
    
}
#pragma mark - 请求数据
- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=index.index",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        homeModel = [[HomeModel alloc] initWithDictionary:responseObject];
        
        bannerScroll.imageURLStringsGroup = homeModel.bannerArray;
        
        _activeArray = homeModel.activeArray;
        
        // 创建选择视图
        [self createChooseView];
        // 创建课程和体验店视图
        [self createClassViewAndShopView];
        
        
    }];
    
}

- (void)telePhoneClick:(UIButton *)button {
    NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"tel:%@",KEFU];
    UIWebView* callWebview = [[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
}

- (void)cancelButtonClick:(UIButton *)button {
    refush.frame = CGRectMake((viewWidth  - Adaptive(295)) / 2,
                              -Adaptive(410),
                              Adaptive(295),
                              Adaptive(410));
    [refush removeFromSuperview];
    [alphaView removeFromSuperview];
}
-(void)onCheckVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appVersion = [infoDic objectForKey:@"CFBundleVersion"];
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=index.version",BASEURL];
    
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        
        
        NSString *version = [[responseObject objectForKey:@"data"] objectForKey:@"version"];
        
        if ([appVersion intValue] < [version intValue]) {
            
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            alphaView = [UIView new];
            alphaView.frame = CGRectMake(0,
                                         0,
                                         viewWidth,
                                         viewHeight);
            alphaView.backgroundColor = BASECOLOR;
            alphaView.alpha = .6;
            
            
            [UIView animateWithDuration:.5 animations:^{
                [app.window addSubview:alphaView];
                CGRect Frame   = refush.frame;
                Frame.origin.y = (viewHeight - Adaptive(410)) / 2 ;
                refush.frame   = Frame;
                [app.window addSubview:refush];
                
            }];
        }
    }];
}



#pragma mark - 创建BannerScrollView
- (void)createBannerScrollView {
    
    bannerScroll = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0,
                                                                       NavigationBar_Height,
                                                                       viewWidth,
                                                                       Adaptive(125))];
    bannerScroll.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    bannerScroll.pageControlStyle   = SDCycleScrollViewPageContolStyleAnimated;
    bannerScroll.autoScrollTimeInterval = 5.0;
    bannerScroll.userInteractionEnabled = YES;
    [self.view addSubview:bannerScroll];
}

#pragma mark - 创建选择视图
- (void)createChooseView {
    chooseImageView = [[UIImageView alloc]
                       initWithFrame:CGRectMake(0,
                                                CGRectGetMaxY(bannerScroll.frame) + Adaptive(5),
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
    
    CGFloat LeftHeight = viewHeight - Tabbar_Height - CGRectGetMaxY(chooseImageView.frame) ;
    
    /*************左视图|课程****************/
    classView = [[ClassView alloc] initWithFrame:CGRectMake(0,
                                                            CGRectGetMaxY(chooseImageView.frame),
                                                            viewWidth,
                                                            LeftHeight) viewController:self];
    classView.home = homeModel;
    [self.view addSubview:classView];
    /*************右视图|体验店****************/
    shopView = [[ShopView alloc] initWithFrame:CGRectMake(0,
                                                          CGRectGetMaxY(chooseImageView.frame),
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

- (void)pushClassIntroduceView:(NSString *)class className:(NSString *)name classOrShip:(NSString *)type{
    
    IntroduceViewController *introduce     = [IntroduceViewController new];
    introduce.class_id    = class;
    introduce.className   = name;
    introduce.classOrShip = type;
    introduce.cityAllowed = _cityAllowed;
    [self.navigationController pushViewController:introduce animated:YES];
   
}

@end
