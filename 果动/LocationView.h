//
//  LocationView.h
//  果动
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
@interface LocationView : UIView<CLLocationManagerDelegate>
+ (instancetype)sharedViewManager;
@property (nonatomic,retain) UIImageView *topLocationImageView;
@property (nonatomic,retain) UIButton    *locationButton;
@property (strong,nonatomic) CLLocationManager* locationManager; //位置管理器
@property (strong,nonatomic) CLGeocoder* geoCoder; //地理编码器
//@property (nonatomic,retain) NSArray *citysArray;
@property (nonatomic,assign) BOOL isCitys,dingwei;
@end
