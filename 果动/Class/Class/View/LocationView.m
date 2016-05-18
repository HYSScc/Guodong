//
//  LogationView.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "LocationView.h"
#import "ClassViewController.h"

@implementation LocationView
{
    ClassViewController *class;
    NSString            *cityName;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        [self createLocation]; // 开始定位
        
    }
    return self;
}
- (void)createUI
{
    
    class = [ClassViewController sharedViewControllerManager];
    
    self.topLocationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-Adaptive(8), 0, Adaptive(18), Adaptive(18))];
    self.topLocationImageView.image = [UIImage imageNamed:@"shouye_dingwei1"];
    [self addSubview:self.topLocationImageView];
    
    
    UIImageView* buttomLocationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-Adaptive(7.5), CGRectGetMaxY(self.topLocationImageView.frame) - Adaptive(3), Adaptive(18), Adaptive(8))];
    buttomLocationImageView.image = [UIImage imageNamed:@"shouye_dingwei2"];
    [self addSubview:buttomLocationImageView];
    
    // 显示所在城市
    cityName                         = @"定位中";
    self.locationLabel               = [UILabel new];
    self.locationLabel.frame         = CGRectMake(CGRectGetMaxX(buttomLocationImageView.frame) + Adaptive(3),
                                                  CGRectGetMinY(_topLocationImageView.frame) + Adaptive(3),
                                                  Adaptive(90),
                                                  Adaptive(20));
    
    self.locationLabel.font          = [UIFont fontWithName:FONT size:Adaptive(14)];
    self.locationLabel.textColor     = [UIColor blackColor];
    self.locationLabel.text          = cityName;
    [self addSubview:self.locationLabel];
    
    
    self.locationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.locationButton.frame = CGRectMake(Adaptive(-10), Adaptive(3), Adaptive(90), Adaptive(20));
    [self.locationButton addTarget:self action:@selector(cityView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.locationButton];
}

- (void)createLocation
{
    //定位管理器
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    if (!_geoCoder) {
        //创建并初始化编码器
        _geoCoder = [[CLGeocoder alloc] init];
    }
    //设置代理
    _locationManager.delegate = self;
    //设置定位精度
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //定位频率,每隔多少米定位一次
    //多少米定位一次
    _locationManager.distanceFilter = 10.0;
    //启动跟踪定位
    [_locationManager startUpdatingLocation];
    
}
#pragma mark - CoreLocation
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations {
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
    CLLocation* location = [locations firstObject]; //取出第一个位置
    
    NSString *urlString  = [NSString stringWithFormat:@"%@geocoding/", BASEURL];
    NSDictionary *locationDict = @{ @"lnt" : [NSString stringWithFormat:@"%f", location.coordinate.longitude],@"lat" : [NSString stringWithFormat:@"%f", location.coordinate.latitude]};
    
    
    [HttpTool postWithUrl:urlString params:locationDict success:^(id responseObject) {
        
      NSString *city = [[responseObject objectForKey:@"city"] objectForKey:@"name"];
        if (city) {
            cityName = city;
            self.locationLabel.text = cityName;
            
            [class removeLocationAnimation];
        }
    }];
    
}



#pragma mark - 按钮点击事件
- (void)cityView:(UIButton *)button {
    
    class.pushCityViewController(cityName);
}

+ (instancetype)sharedViewManager
{
    static dispatch_once_t onceToken;
    static LocationView* locationView;
    
    dispatch_once(&onceToken, ^{
        locationView = [[LocationView alloc] init];
    });
    
    return locationView;
}

@end
