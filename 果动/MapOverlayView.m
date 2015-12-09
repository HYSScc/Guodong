//
//  MapOverlayView.m
//  果动
//
//  Created by mac on 15/7/8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//
#import "MapOverlayView.h"
#import "MapOverlay.h"

@implementation MapOverlayView

- (void)drawMapRect:(MKMapRect)mapRect zoomScale:(MKZoomScale)zoomScale inContext:(CGContextRef)ctx
{
    
   // NSLog(@" >>>> %f",zoomScale);
    
    UIImage *image          = [UIImage imageNamed:@"覆盖"];
    CGImageRef imageReference = image.CGImage;
    
    //Loading and setting the image
    MKMapRect theMapRect    = [self.overlay boundingMapRect];
   // NSLog(@"theMaprect  %f  %f  %f  %f",theMapRect.origin.x,theMapRect.origin.y,theMapRect.size.height,theMapRect.size.width);
    CGRect theRect           = [self rectForMapRect:theMapRect];
    
    
    // We need to flip and reposition the image here
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGContextTranslateCTM(ctx, 0.0, -theRect.size.height);
    
    //drawing the image to the context
    CGContextDrawImage(ctx, theRect, imageReference);
    
  
}


@end
