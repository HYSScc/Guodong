//
//  LogationView.h
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationView : UIView <CLLocationManagerDelegate>


+ (instancetype)sharedViewManager;

@property (nonatomic, retain) UIImageView       *topLocationImageView;
@property (nonatomic, retain) UIButton          *locationButton;
@property (nonatomic, retain) UILabel           *locationLabel;
@property (strong, nonatomic) CLLocationManager *locationManager; // 位置管理器
@property (strong, nonatomic) CLGeocoder        *geoCoder;        // 地理编码器

@property (nonatomic,retain) NSString            *isSet;
@end
