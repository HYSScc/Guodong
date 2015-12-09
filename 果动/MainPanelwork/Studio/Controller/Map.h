//
//  Map.h
//  果动
//
//  Created by mac on 15/7/2.
//  Copyright (c) 2015年 Unique. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
@interface Map : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@end
