//
//  contentSportViewController.h
//  私练
//
//  Created by z on 15/1/23.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface contentSportViewController : UIViewController
@property (retain, nonatomic)  UILabel *dateLabel;
@property (retain, nonatomic)  UILabel *peopleLabel;
@property (retain, nonatomic)  UILabel *numbelLabel;
@property (retain, nonatomic)  UILabel *placeLabel;
@property (retain, nonatomic)  UILabel *supportLabel;
@property (retain, nonatomic)  UILabel *amoutLabel;
@property (retain, nonatomic)  UILabel *gatherPlaceLabel;
@property (retain, nonatomic)  UILabel *contentLabel;
@property (retain, nonatomic)  UILabel *themeLabel;

@property (nonatomic,retain)NSString *idstr;
@property (retain, nonatomic)  UIImageView *image;
@property (nonatomic,retain)NSString *total;
@property (nonatomic,retain)NSString *where;
@end
