//
//  LocationView.m
//  果动
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "LocationView.h"
#import "Commonality.h"
#import "HomeController.h"
@implementation LocationView
{
    NSString * allName;
    int  succ;
    NSTimer *dingweitimer;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:self.frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self createLocation];
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    self.topLocationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-viewHeight/133.4, 0, viewHeight/55.583, viewHeight/37.056)];
    self.topLocationImageView.image = [UIImage imageNamed:@"shouye_dingwei1"];
    [self addSubview:self.topLocationImageView];
    
    UIImageView *buttomLocationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-viewHeight/88.933, CGRectGetMaxY( self.topLocationImageView.frame) - viewHeight/222.333, viewHeight/37.056, viewHeight/83.375)];
    buttomLocationImageView.image = [UIImage imageNamed:@"shouye_dingwei2"];
    [self addSubview:buttomLocationImageView];
    
    self.locationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.locationButton.frame = CGRectMake(0, 0, viewHeight/13.34, viewHeight/33.35);
    self.locationButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
    [self.locationButton addTarget:self action:@selector(cityView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.locationButton];
}
#pragma mark 城市选择view
-(void)cityView:(UIBarButtonItem *)sender
{
    HomeController *home = [HomeController sharedViewControllerManager];
    home.pushCityVCBlock(allName);
}
-(void)createLocation
{
    //定位管理器
    if (!_locationButton) {
         _locationManager=[[CLLocationManager alloc]init];
    }
    if (!_geoCoder) {
        //创建并初始化编码器
        _geoCoder = [[CLGeocoder alloc] init];
    }
    //设置代理
    _locationManager.delegate=self;
    //设置定位精度
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    //多少米定位一次
    _locationManager.distanceFilter=10.0;
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
    NSLog(@"定位启动");
}
#pragma mark - CoreLocation
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    
    //如果不需要实时定位，使用完即使关闭定位服务
     [_locationManager stopUpdatingLocation];
    CLLocation *location=[locations firstObject];//取出第一个位置
    HomeController *home = [HomeController sharedViewControllerManager];
    home.longitude = location.coordinate.longitude;
    home.latitude  = location.coordinate.latitude;
    NSLog(@" home.longitude  %f  home.latitude  %f",home.longitude,home.latitude);

    NSString *urlString = [NSString stringWithFormat:@"%@geocoding/",BASEURL];
    NSDictionary *locationDict  = @{@"lnt":[NSString stringWithFormat:@"%f",location.coordinate.longitude],@"lat":[NSString stringWithFormat:@"%f",location.coordinate.latitude]};
    
    [HttpTool postWithUrl:urlString params:locationDict contentType:CONTENTTYPE success:^(id responseObject) {
        allName = [[responseObject objectForKey:@"city"] objectForKey:@"name"];
        if (!allName) {
            NSLog(@"定位失败");
            home.alertImageView.frame = CGRectMake(0, -viewHeight/13.34 , viewWidth, viewHeight/13.34);
            home.alertImageView.alpha = 1;
            home.alertImageBlock(@"locationStart");
            [self createLocation];
        }
        
        self.dingwei = YES;
        [self.locationButton setTitle:allName forState:UIControlStateNormal];
        NSString *district = [[responseObject objectForKey:@"city"] objectForKey:@"district"];
        NSString *address = [NSString stringWithFormat:@"%@.%@",allName,district];
        succ = 0;
        if (allName.length != 0 && district.length != 0) {
            succ = 1;
            NSLog(@"定位成功");
            home.removeAnimationBlock(self.dingwei);
        }
       
        NSDictionary *dict = @{@"address":address,@"succ":[NSString stringWithFormat:@"%d",succ]};
        NSNotification *notification =[NSNotification notificationWithName:@"address" object:nil userInfo:dict];
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
        CGRect newFrame = self.locationButton.frame;
        CGSize userNameSize = [allName sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:23]}];
        newFrame.size.width = userNameSize.width;
        self.locationButton.frame = newFrame;
        
        if ([[responseObject objectForKey:@"allowd"] indexOfObject:[[responseObject objectForKey:@"city"] objectForKey:@"city_code"]]) {
            NSLog(@"城市已覆盖");
            self.isCitys = YES;
    
        }
    } fail:^(NSError *error) {
        NSLog(@"error %@",error);
    }];
}
+ (instancetype)sharedViewManager {
    static dispatch_once_t onceToken;
    static LocationView* locationView;
    
    dispatch_once(&onceToken, ^{
        locationView = [[LocationView alloc] init];
    });
    
    return locationView;
}
@end
