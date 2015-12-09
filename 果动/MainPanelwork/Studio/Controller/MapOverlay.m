//
//  MapOverlay.m
//  果动
//
//  Created by mac on 15/7/8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "MapOverlay.h"
#import "Commonality.h"

@implementation MapOverlay

-(CLLocationCoordinate2D)coordinate {
    //Image center point
    return CLLocationCoordinate2DMake(JGMWD,JGMJD);
}

- (MKMapRect)boundingMapRect
{
    //Latitue and longitude for each corner point
    MKMapPoint TJH   = MKMapPointForCoordinate(CLLocationCoordinate2DMake(TJHWD,TJHJD));
    MKMapPoint DWL  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(DWLWD,DWLJD));
    MKMapPoint JGM  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(JGMWD,JGMJD));
    MKMapPoint SJ  = MKMapPointForCoordinate(CLLocationCoordinate2DMake(SJWD,SJJD));
    
    //Building a map rect that represents the image projection on the map
    MKMapRect bounds = MKMapRectMake(JGM.x, TJH.y, fabs(JGM.x - DWL.x), fabs(TJH.y - SJ.y));
    
    return bounds;
}


@end