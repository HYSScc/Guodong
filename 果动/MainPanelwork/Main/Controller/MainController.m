//
//  MainController.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "MainController.h"
#import "JWNavigationController.h"
#import "Dock.h"
#import "Commonality.h"
#import "HomeController.h"
//#import "StudioController.h"
#import "GBViewController.h"
#import "PersonalCenterController.h"
#import "OrderFormController.h"
#import "AppDelegate.h"
#define kNavH 64

@interface MainController ()<UINavigationControllerDelegate,DockDelegate,UIAlertViewDelegate>
{
    Dock * _dock;
}
@end

@implementation MainController


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"address" object:nil];
   
    [self addAllSubViews];
    [self addDock];
    

    
    self.view.backgroundColor=[UIColor colorWithRed:35.00/255 green:30.00/255 blue:15.00/255 alpha:1];
    //推送评价
    if ([self.type isEqualToString:@"1"]) {
        OrderFormController *order = [OrderFormController new];
      //  order.order_id = self.order_id;
        [self.navigationController pushViewController:order animated:YES];
        self.type = @"2";
    }
    
    NSLog(@"self.status%@",self.status);
    //推送教练是否接单
    if ([self.status isEqualToString:@"accept_order"]) {
        HomeController *homeVC = [HomeController sharedViewControllerManager];
        homeVC.block (self.order_id);
        self.status = @"";
    }
    //推送vip次数
    if ([self.status isEqualToString:@"vip"]) {
        HomeController *homeVC = [HomeController sharedViewControllerManager];
        homeVC.vipblock (self.vip);
    }
    //推送无聊的消息
     if ([self.status isEqualToString:@"else"])
    {
        HomeController *homeVC = [HomeController sharedViewControllerManager];
        homeVC.elseblock (self.elseStr);

    }
    
   

    
}

-(void)tongzhi:(NSNotification *)notification
{
    
    NSLog(@"地址  %@",[notification.userInfo objectForKey:@"address"]);
    PersonalCenterController *person = [PersonalCenterController sharedViewControllerManager];
    person.address = [notification.userInfo objectForKey:@"address"];
   // person.succ = [[notification.userInfo objectForKey:@"succ"] intValue];
}
- (void)addDock {
    
    Dock *dock = [[Dock alloc] init];
    
    dock.delegate=self;
    dock.backgroundColor = [UIColor colorWithRed:35.00/255 green:30.00/255 blue:15.00/255 alpha:1];
    [dock addItemWithTitle:nil Icon:@"tabbar1" selectedIcon:@"tabsoubar1"];
    
    [dock addItemWithTitle:nil Icon:@"tabbar2" selectedIcon:@"tabsoubar2"];
    
    [dock addItemWithTitle:nil Icon:@"tabbar3" selectedIcon:@"tabsoubar3"];
    
    [dock addItemWithTitle:nil Icon:@"tabbar4" selectedIcon:@"tabsoubar4"];
    
    dock.frame = CGRectMake(0, self.view.frame.size.height - (viewHeight/12.352), 0, 0);
    //  dock.backgroundColor = [UIColor redColor];
    [self.view addSubview:dock];
    
    _dock = dock;
    
    
    
}


- (void)addAllSubViews {
    
    
   
    
    HomeController *homeVC = [HomeController sharedViewControllerManager];
    JWNavigationController *nav = [[JWNavigationController alloc] initWithRootViewController:homeVC];
    
    nav.delegate = self;
    
    [self addChildViewController:nav];
    
    OrderFormController *orderVC = [[OrderFormController alloc] init];
    orderVC.citys = self.citys;
    nav = [[JWNavigationController alloc] initWithRootViewController:orderVC];
    
    nav.delegate = self;
    
    [self addChildViewController:nav];
    
    GBViewController *gdVC = [[GBViewController alloc] init];
    nav = [[JWNavigationController alloc] initWithRootViewController:gdVC];
    
    nav.delegate = self;
    
    [self addChildViewController:nav];
    
    PersonalCenterController *perVC = [PersonalCenterController sharedViewControllerManager];
   
    nav = [[JWNavigationController alloc] initWithRootViewController:perVC];
    
    nav.delegate = self;
    
    [self addChildViewController:nav];
    
    
    
}

#pragma mark - Dock代理方法
- (void)dock:(Dock *)dock selectedItemFrom:(NSInteger)from to:(NSInteger)to {
    
    UIViewController *oldVC = self.childViewControllers[from];
    
    [oldVC.view removeFromSuperview];
    NSLog(@"to  %ld",(long)to);
    
    
    UIViewController *newVC = self.childViewControllers[to];
    
    [self.view addSubview:newVC.view];
    
}


#pragma mark --------------------UINavigationController代理方法-----------------------

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIViewController *root = navigationController.viewControllers[0];
    
    if (root != viewController) {
        
        CGRect frame = navigationController.view.frame;
        
        frame.size.height = [UIScreen mainScreen].bounds.size.height;
        
        navigationController.view.frame = frame;
        
        [_dock removeFromSuperview];
        
        CGRect dockFrame = _dock.frame;
        
        dockFrame.origin.y = root.view.frame.size.height - _dock.frame.size.height;
        
        if ([root.view isKindOfClass:[UIScrollView class]]) {
            
            UIScrollView *scroll = (UIScrollView *)root.view;
            
            dockFrame.origin.y += scroll.contentOffset.y;
            
        }
        
        _dock.frame = dockFrame;
        
        [root.view addSubview:_dock];
        
    }
    
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    UIViewController *root = navigationController.viewControllers[0];
    if (viewController == root) {
        
        CGRect frame = navigationController.view.frame;
        
        frame.size.height = [UIScreen mainScreen].bounds.size.height - _dock.frame.size.height;
        
        navigationController.view.frame = frame;
        
        [_dock removeFromSuperview];
        
        
        
        
        CGRect dockFrame = _dock.frame;
        
        dockFrame.origin.y = self.view.frame.size.height - _dock.frame.size.height;
        
        _dock.frame = dockFrame;
        
        [self.view addSubview:_dock];
        
    }
    
}



@end
