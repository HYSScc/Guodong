//
//  TopView.m
//  果动
//
//  Created by mac on 15/12/21.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "TopView.h"
#import "Commonality.h"
@implementation TopView
{
    NSArray *topImageArray;
    NSArray *smallImageArray;
    NSArray *bigImageArray;
    int classNumber;
    int imageType;
    BOOL isShow;
}
- (id)initWithFrame:(CGRect)frame imageTypeWith:(int)type ClassNumberWith:(int)number showClassNumberWith:(BOOL)show{
    
    self = [super initWithFrame:frame];// 先调用父类的initWithFrame方法
    
    if (self) {
        
        topImageArray   = @[@"fitness_topImage",@"yoga_topImage",@"fat_topImage",@"core_topImage",@"shop_topImage"];
        smallImageArray = @[@"fitness_image1"  ,@"yoga_image1"  ,@"fat_image1",  @"core_image1"  ,@"shop_image1"];
        bigImageArray   = @[@"fitness_image2"  ,@"yoga_image2"  ,@"fat_image2"  ,@"core_image2"  ,@"shop_image2"];
        imageType = type;
        classNumber = number;
        isShow = show;
        [self createUI];
    }
    
    return self;
    
}
-(void)createUI
{
    /*顶部背景图*/
   UIImageView *topImageView = [[UIImageView alloc] initWithFrame:self.frame];
    
    NSString *string = isShow ? @"o" : @"t";
    
    [topImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_%@",topImageArray[imageType - 1],string]]];
   [self addSubview:topImageView];
    
    /*顶部小图标*/
    UIImageView *smallImage = [[UIImageView alloc] init];
    switch (imageType) {
        case 1:
            smallImage.frame = CGRectMake((topImageView.bounds.size.width - viewHeight/17.37)/2 , viewHeight/17.5526, viewHeight/17.37, viewHeight/16.51);
            break;
        case 2:
            smallImage.frame = CGRectMake((topImageView.bounds.size.width - viewHeight/12.83)/2 , viewHeight/17.5526, viewHeight/12.83, viewHeight/18.53);
            break;
        case 3:
            smallImage.frame = CGRectMake((topImageView.bounds.size.width - viewHeight/14.5)/2 , viewHeight/17.5526, viewHeight/14.5, viewHeight/15.2982);
            break;
        case 4:
            smallImage.frame = CGRectMake((topImageView.bounds.size.width - viewHeight/14.5)/2 , viewHeight/17.5526, viewHeight/14.5, viewHeight/15.2982);
            break;
        case 5:
            smallImage.frame = CGRectMake((topImageView.bounds.size.width - viewHeight/14.5)/2 , viewHeight/17.5526, viewHeight/14.5, viewHeight/15.2982);
            break;
            
        default:
            break;
    }
    
    [smallImage setImage:[UIImage imageNamed:smallImageArray[imageType - 1]]];
    [self addSubview:smallImage];
    
    /*顶部大图标*/
    UIImageView *bigImage = [[UIImageView alloc] initWithFrame:CGRectMake((topImageView.bounds.size.width - viewHeight/4.94)/2 , CGRectGetMaxY(smallImage.frame)+viewHeight/55.58333, viewHeight/4.94, viewHeight/15.694)];
    [bigImage setImage:[UIImage imageNamed:bigImageArray[imageType - 1]]];
    [self addSubview:bigImage];
    if (isShow) {
        //课程介绍
        UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake((topImageView.bounds.size.width - viewHeight/5.558)/2, CGRectGetMaxY(bigImage.frame)+viewHeight/39.2353, viewHeight/5.558, viewHeight/31.762)];
        introduceLabel.textColor = [UIColor orangeColor];
        introduceLabel.textAlignment = 1;
        introduceLabel.text = @"课程介绍";
        introduceLabel.font = [UIFont fontWithName:FONT size:viewHeight/31.762];
        [self addSubview:introduceLabel];
        
        //上课次数
        _classnumberLabel = [[UILabel alloc] initWithFrame:CGRectMake((topImageView.bounds.size.width - viewHeight/5.558)/2, CGRectGetMaxY(introduceLabel.frame) + viewHeight/88.9333, viewHeight/5.558, viewHeight/74.111)];
        _classnumberLabel.textColor = [UIColor whiteColor];
        _classnumberLabel.textAlignment = 1;
        _classnumberLabel.text = [NSString stringWithFormat:@"已有%d人下单",classNumber];
        _classnumberLabel.font = [UIFont fontWithName:FONT size:viewHeight/66.7];
        [self addSubview:_classnumberLabel];
    }
    

    
}

@end
