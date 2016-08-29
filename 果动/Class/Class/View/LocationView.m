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
    NSString            *again;
    BOOL                firstRequest;
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self createUI];
        [self createLocation]; // 开始定位
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"startLocation" object:nil];
    }
    return self;
}

- (void)tongzhi:(NSNotification *)notification {
    again = @"again";
    [self createLocation];
}

- (void)createUI
{
    
    class = [ClassViewController sharedViewControllerManager];
    
    self.topLocationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-Adaptive(8),Adaptive(5), Adaptive(12), Adaptive(12))];
    self.topLocationImageView.image = [UIImage imageNamed:@"shouye_dingwei1"];
    [self addSubview:self.topLocationImageView];
    
    
    UIImageView* buttomLocationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-Adaptive(7.5), CGRectGetMaxY(self.topLocationImageView.frame) - Adaptive(3), Adaptive(12), Adaptive(5.3334))];
    buttomLocationImageView.image = [UIImage imageNamed:@"shouye_dingwei2"];
    [self addSubview:buttomLocationImageView];
    
    // 显示所在城市
    cityName                         = @"定位中";
    self.locationLabel               = [UILabel new];
    self.locationLabel.frame         = CGRectMake(CGRectGetMaxX(buttomLocationImageView.frame) + Adaptive(3),
                                                  Adaptive(6),
                                                  Adaptive(90),
                                                  Adaptive(15));
    
    self.locationLabel.font          = [UIFont fontWithName:FONT size:Adaptive(14)];
    self.locationLabel.textColor     = BASECOLOR;
    self.locationLabel.text          = cityName;
    [self addSubview:self.locationLabel];
    
    
    self.locationButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.locationButton.frame = CGRectMake(Adaptive(-10), Adaptive(3), Adaptive(90), Adaptive(20));
    [self.locationButton addTarget:self action:@selector(cityView:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.locationButton];
}

- (void)createLocation
{
 
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
         || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
            //定位功能可用，开始定位
            
            
            _locationManager = [[CLLocationManager alloc] init];
            
            //创建并初始化编码器
            _geoCoder = [[CLGeocoder alloc] init];
            
            //设置代理
            _locationManager.delegate = self;
          
            //启动跟踪定位
            [_locationManager startUpdatingLocation];
            
        } else {
            NSLog(@"未开启定位");
            [class removeLocationAnimation];
            self.locationLabel.text = @"未开启定位";
            cityName = @"未开启定位，点击设置";
            _isSet    = @"set";
        }
    
    
}
#pragma mark - CoreLocation
#pragma mark 跟踪定位代理方法，每次位置发生变化即会执行（只要定位到相应位置）
- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations {
    
    //如果不需要实时定位，使用完即使关闭定位服务
    [_locationManager stopUpdatingLocation];
    CLLocation* location = [locations firstObject]; //取出第一个位置
    
    NSDictionary *locationDict = @{ @"lnt" : [NSString stringWithFormat:@"%f", location.coordinate.longitude],@"lat" : [NSString stringWithFormat:@"%f", location.coordinate.latitude]};
    
    if ([locationDict count] != 0 && !firstRequest) {
        [self requestCityAllowedDataWith:locationDict];
    }
}

- (void)requestCityAllowedDataWith:(NSDictionary *)dict {
    
    firstRequest = !firstRequest;
    
    NSString *urlString  = [NSString stringWithFormat:@"%@geocoding/", BASEURL];
    
    [HttpTool postWithUrl:urlString params:dict body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSString *city = [[responseObject objectForKey:@"city"] objectForKey:@"name"];
        if (city) {
            cityName = city;
            self.locationLabel.text = cityName;
            _isSet   = @"";
            
           
            NSString *cityNumber = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"city"] objectForKey:@"city_code"]];
            NSMutableDictionary *cookieProperties = [NSMutableDictionary dictionary];  // 创建cookie属性字典
            [cookieProperties setObject:@"city_code" forKey:NSHTTPCookieName]; // 手动设置cookie的属性
            [cookieProperties setObject:cityNumber forKey:NSHTTPCookieValue];
            [cookieProperties setObject:@"www.guodongwl.com" forKey:NSHTTPCookieDomain];
            [cookieProperties setObject:@"www.guodongwl.com" forKey:NSHTTPCookieOriginURL];
            [cookieProperties setObject:@"/" forKey:NSHTTPCookiePath];
            [cookieProperties setObject:@"0" forKey:NSHTTPCookieVersion];
            
            NSHTTPCookie *cookie = [NSHTTPCookie cookieWithProperties:cookieProperties];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];

            
            if ([[responseObject objectForKey:@"allowd"] containsObject:cityNumber]) {
                
                class.cityAllowed = YES;
            }
            [class removeLocationAnimation];
            
            if ([again isEqualToString:@"again"]) {
                
                NSNotification *notification =[NSNotification notificationWithName:@"again" object:nil userInfo:@{@"name":cityName}];
                
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
            }
        }
    }];

}
#pragma mark - 按钮点击事件
- (void)cityView:(UIButton *)button {
    
    class.pushCityViewController(cityName,_isSet);
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
