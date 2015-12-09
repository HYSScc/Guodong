//
//  RightVBaseView.m
//  果动
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "RightVBaseView.h"
#import "Commonality.h"
#import "HomeController.h"
@implementation RightVBaseView
{
    BOOL isfirst;
    CGFloat firstLatitude;
    CGFloat firstLongitude;
    MKMapView *_mapView;
    UIView *contentView;
    UILabel *introduceTop;
    UILabel *introduceButtom;
    UILabel *introduceMiddle;
    UIButton *framebutton;
    UIButton *myframebutton;
    CLLocationCoordinate2D myframecoordinate;
}
- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    if (self) {
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    _mapView=[[MKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:_mapView];
    
    
    contentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame) - (viewHeight/13.34), viewWidth, viewHeight/13.34)];
    contentView.backgroundColor = [UIColor blackColor];
    contentView.userInteractionEnabled = YES;
    contentView.alpha = 0.8;
    [_mapView addSubview:contentView];
    
    
    introduceTop = [[UILabel alloc] initWithFrame:CGRectMake(0,viewHeight/66.7,viewWidth,viewHeight/47.643)];
    introduceTop.textAlignment = 1;
    introduceTop.textColor = [UIColor orangeColor];
    introduceTop.text = @"东至大望路-西至日坛路-南至双井-北至团结湖";
    introduceTop.font = [UIFont fontWithName:FONT size:viewHeight/60.636];
    [contentView addSubview:introduceTop];
    
    introduceButtom = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(introduceTop.frame), viewWidth,viewHeight/47.643)];
    introduceButtom.textAlignment = 1;
    introduceButtom.textColor = [UIColor colorWithRed:178.00/255 green:175.00/255 blue:170.00/255 alpha:1];
    introduceButtom.text = @"核心服务范围内，教练会在2小时内准时到达";
    introduceButtom.font = [UIFont fontWithName:FONT size:viewHeight/60.636];
    [contentView addSubview:introduceButtom];
    
    introduceMiddle = [[UILabel alloc] initWithFrame:CGRectMake(0, (contentView.bounds.size.height - viewHeight/47.643)/2, viewWidth,viewHeight/47.643)];
    introduceMiddle.textAlignment = 1;
    introduceMiddle.textColor = [UIColor colorWithRed:178.00/255 green:175.00/255 blue:170.00/255 alpha:1];
    introduceMiddle.text = @"更多实体门店建设中 果动学员敬请期待";
    introduceMiddle.font = [UIFont fontWithName:FONT size:viewHeight/55.583];

    //设置代理
    _mapView.delegate=self;
    //用户位置追踪(用户位置追踪用于标记用户当前位置，此时会调用定位服务)
    _mapView.userTrackingMode=MKUserTrackingModeFollow;
    //设置地图类型
    _mapView.mapType=MKMapTypeStandard;
    //添加范围
    [self addAnnotation];
    
    //
    framebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    framebutton.frame = CGRectMake(viewWidth - viewHeight/26.468 - viewHeight/39.235, viewHeight/66.7, viewHeight/26.468, viewHeight/18.528);
    [framebutton setBackgroundImage:[UIImage imageNamed:@"frame"] forState:UIControlStateNormal];
    //  framebutton.backgroundColor = [UIColor redColor];
    [framebutton addTarget:self action:@selector(frameButton) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:framebutton];
    
    myframebutton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myframebutton.frame = CGRectMake(viewWidth - viewHeight/26.468 - viewHeight/39.235, viewHeight/11.117, viewHeight/26.468, viewHeight/18.528);
    [myframebutton setBackgroundImage:[UIImage imageNamed:@"myframegry"] forState:UIControlStateNormal];
    [myframebutton addTarget:self action:@selector(myframebutton) forControlEvents:UIControlEventTouchUpInside];
    [_mapView addSubview:myframebutton];
    
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    
    MKCoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center= centerCoordinate;
   // NSLog(@" 纬 %f  经 %f",centerCoordinate.latitude,centerCoordinate.longitude);
    if (!isfirst){
        firstLatitude = centerCoordinate.latitude;
        firstLongitude= centerCoordinate.longitude;
        isfirst = !isfirst;
        //  NSLog(@"只进一次");
    }
    
    if(centerCoordinate.latitude == firstLatitude && centerCoordinate.longitude == firstLongitude) {
        //    NSLog(@"hahaha");
        [introduceMiddle removeFromSuperview];
        [framebutton setBackgroundImage:[UIImage imageNamed:@"frame"] forState:UIControlStateNormal];
        [contentView addSubview:introduceTop];
        [contentView addSubview:introduceButtom];
    }else{
        [framebutton setBackgroundImage:[UIImage imageNamed:@"framegry"] forState:UIControlStateNormal];
        [introduceTop removeFromSuperview];
        [introduceButtom removeFromSuperview];
        [contentView addSubview:introduceMiddle];
    }
}
#pragma  mark -- 范围
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    myframecoordinate = userLocation.coordinate;
    
     //NSLog(@"myframecoordinate.latitude %f myframecoordinate.longitude %f",myframecoordinate.latitude,myframecoordinate.longitude);
}
- (void)myframebutton
{
     HomeController *home = [HomeController sharedViewControllerManager];
    [myframebutton setBackgroundImage:[UIImage imageNamed:@"myframe"] forState:UIControlStateNormal];
   
    CLLocationCoordinate2D coord1 = {
        home.latitude,home.longitude
    };
    MKCoordinateSpan span = {.latitudeDelta = 0.04, .longitudeDelta = 0.04};
    MKCoordinateRegion region = {coord1, span};
    [_mapView setRegion:region animated:YES];
    
}
- (void)frameButton
{
    [myframebutton setBackgroundImage:[UIImage imageNamed:@"myframegry"] forState:UIControlStateNormal];
    CLLocationCoordinate2D coord1 = {
        ZIDONGWD,ZIDONGJD
    };
    MKCoordinateSpan span = {.latitudeDelta = 0.05, .longitudeDelta = 0.05};
    MKCoordinateRegion region = {coord1, span};
    [_mapView setRegion:region animated:YES];
    
}
#pragma mark 添加大头针
- (void)addAnnotation{
    
    //纬度  小上大下  经度  小左大右  //果动39.907010203, 116.562446121
    /*
      #define JGMWD  39.914505
      #define JGMJD  116.441689
     */
    //Centering map  自动锁定的位置
    CLLocationCoordinate2D coord1 = {
        ZIDONGWD,ZIDONGJD
    };
    //定位的精度
    MKCoordinateSpan span = {.latitudeDelta = 0.05, .longitudeDelta = 0.05};
    MKCoordinateRegion region = {coord1, span};
    [_mapView setRegion:region animated:YES];
    
    //Adding our overlay to the map
    MapOverlay * mapOverlay = [[MapOverlay alloc] init];
    [_mapView addOverlay:mapOverlay];
    
}
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    
    MapOverlay *mapOverlay = (MapOverlay *)overlay;
    MapOverlayView *mapOverlayView = [[MapOverlayView alloc] initWithOverlay:mapOverlay];
    return mapOverlayView;
}
@end
