//
//  classViewController.m
//  果动
//
//  Created by mac on 15/9/23.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "classViewController.h"
#import "Commonality.h"
#import "MCFireworksButton.h"
#import "image.h"
#import "appointViewController.h"
#import "Message.h"
#import "LoginViewController.h"
#import "FeSpinnerTenDot.h"//加载界面
#import <CoreText/CoreText.h>
#import "BackView.h"
@interface classViewController ()<FeSpinnerTenDotDelegate>
{
    UIImageView *topimage;
    NSMutableArray *imageArray;
    UIScrollView *classScrollView;
    UIImageView *xinImage;
    UIImageView *noticeImage;
    MCFireworksButton *xinButton;
    UILabel *classnumberLabel;
    NSMutableAttributedString *str;
    UILabel *numberLabel;
    
    BOOL selected;
    int ipraised;
    int personNmuber;
    int classNumber;
    int zanNumber;
    CGFloat firstHeigth;
    CGFloat secondHeigth;
    CGFloat pictureHeight;
    
    UIView *moneyView;
    UIButton *sureButton;
}
@property (strong, nonatomic) FeSpinnerTenDot *spinner;
@end

@implementation classViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    BackView *backView = [[BackView alloc] initWithbacktitle:@"首页" viewController:self];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _spinner = [[FeSpinnerTenDot alloc] initWithView:self.view withBlur:NO];
    _spinner.titleLabelText = @"LOADING";
    _spinner.delegate = self;
    _spinner.fontTitleLabel = [UIFont fontWithName:@"Neou-Thin" size:36];
    [self.view addSubview:_spinner];
    [_spinner show];
    
    
    [imageArray removeAllObjects];
    [classScrollView removeFromSuperview];
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdcourse.introduce&class_id=%@",BASEURL,self.class_id];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        NSLog(@"res  %@",responseObject);
        imageArray = [[NSMutableArray alloc] initWithCapacity:0];
        if ([[responseObject objectForKey:@"rc"] intValue] == 0) {
            [_spinner dismiss];
            NSDictionary *data = [responseObject objectForKey:@"data"];
            personNmuber = [[data objectForKey:@"courseTotal"] intValue];
            classNumber = [[data objectForKey:@"price"] intValue];
            zanNumber = [[data objectForKey:@"praiseTotal"] intValue];
            ipraised = [[data objectForKey:@"ipraised"] intValue];
            for (NSDictionary *dict in [data objectForKey:@"imgUrl"]) {
                image *imageModel = [[image alloc] initWithDictionary:dict];
                [imageArray addObject:imageModel];
            }
            
            [self setTopImage];
        }
        else if ([[responseObject objectForKey:@"rc"] intValue] == NotLogin_RC_Number)
        {
            [HeadComment showAlert:@"温馨提示" withMessage:@"您还没有登录呢！" delegate:self witchCancelButtonTitle:@"暂不" otherButtonTitles:@"去登录", nil];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[responseObject objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alert show];
        }
        
    } fail:^(NSError *error) {
        NSLog(@"error %@",error);
        
    }];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    self.navigationItem.titleView = [HeadComment titleLabeltext:self.titleString];
  //
   
    [self setTopImage];
    
    
}
-(void)setTopImage
{
    NSArray *topImageArray   = @[@"fitness_topImage",@"yoga_topImage",@"fat_topImage",@"core_topImage"];
    NSArray *smallImageArray = @[@"fitness_image1"  ,@"yoga_image1"  ,@"fat_image1",  @"core_image1"  ];
    NSArray *bigImageArray   = @[@"fitness_image2"  ,@"yoga_image2"  ,@"fat_image2"  ,@"core_image2"  ];
    
    classScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    classScrollView.backgroundColor = [UIColor blackColor];
    if ([self.class_id intValue] == 2 || [self.class_id intValue] == 4) {
        
        classScrollView.backgroundColor = [UIColor whiteColor];
    }
    classScrollView.bounces = NO; //不允许弹性滑动
    [self.view addSubview:classScrollView];
    
    NSLog(@"self.type  %d",self.type);
    
    
    topimage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/3.032)];
    [topimage setImage:[UIImage imageNamed:topImageArray[self.type - 1]]];
    [classScrollView addSubview:topimage];
    
    UIImageView *smallImage = [[UIImageView alloc] init];
    switch (self.type) {
        case 1:
            smallImage.frame = CGRectMake((topimage.bounds.size.width - viewHeight/17.37)/2 , viewHeight/17.5526, viewHeight/17.37, viewHeight/16.51);
            break;
        case 2:
            smallImage.frame = CGRectMake((topimage.bounds.size.width - viewHeight/12.83)/2 , viewHeight/17.5526, viewHeight/12.83, viewHeight/18.53);
            break;
        case 3:
            smallImage.frame = CGRectMake((topimage.bounds.size.width - viewHeight/14.5)/2 , viewHeight/17.5526, viewHeight/14.5, viewHeight/15.2982);
            break;
        case 4:
            smallImage.frame = CGRectMake((topimage.bounds.size.width - viewHeight/14.5)/2 , viewHeight/17.5526, viewHeight/14.5, viewHeight/15.2982);
            break;
            
        default:
            break;
    }
    
    [smallImage setImage:[UIImage imageNamed:smallImageArray[self.type - 1]]];
    [classScrollView addSubview:smallImage];
    
    UIImageView *bigImage = [[UIImageView alloc] initWithFrame:CGRectMake((topimage.bounds.size.width - viewHeight/4.94)/2 , CGRectGetMaxY(smallImage.frame)+viewHeight/55.58333, viewHeight/4.94, viewHeight/15.694)];
    [bigImage setImage:[UIImage imageNamed:bigImageArray[self.type - 1]]];
    [classScrollView addSubview:bigImage];
    
    UILabel *introduceLabel = [[UILabel alloc] initWithFrame:CGRectMake((topimage.bounds.size.width - viewHeight/5.558)/2, CGRectGetMaxY(bigImage.frame)+viewHeight/39.2353, viewHeight/5.558, viewHeight/31.762)];
    introduceLabel.textColor = [UIColor orangeColor];
    introduceLabel.textAlignment = 1;
    introduceLabel.text = @"课程介绍";
    introduceLabel.font = [UIFont fontWithName:FONT size:viewHeight/31.762];
    [classScrollView addSubview:introduceLabel];
    
    classnumberLabel = [[UILabel alloc] initWithFrame:CGRectMake((topimage.bounds.size.width - viewHeight/5.558)/2, CGRectGetMaxY(introduceLabel.frame) + viewHeight/88.9333, viewHeight/5.558, viewHeight/74.111)];
    classnumberLabel.textColor = [UIColor whiteColor];
    classnumberLabel.textAlignment = 1;
    classnumberLabel.text = [NSString stringWithFormat:@"已有%d人下单",personNmuber];
    classnumberLabel.font = [UIFont fontWithName:FONT size:viewHeight/66.7];
    [classScrollView addSubview:classnumberLabel];
    
    
    /*
     计算宽高比
     宽度一定
     高度根据 屏幕宽度 与 图片宽度的比例算出
     */
    
    for (int a = 0; a < imageArray.count; a++) {
        image *imageModel = [imageArray objectAtIndex:a];
        UIImageView *classImage = [[UIImageView alloc] init];
        CGFloat interval = viewHeight/44.467;
        CGFloat proportion =  ([imageModel.height floatValue]/2)/([imageModel.width floatValue]/2);
        
        NSLog(@"高度  %d",[imageModel.height intValue]/2);
        NSLog(@"宽度  %d",[imageModel.width intValue]/2);
        NSLog(@"proportion  %.2f",proportion);
        
        
        if (self.type == 1) {
            classImage.frame = CGRectMake(0,CGRectGetMaxY(topimage.frame)+a*(viewWidth * proportion), viewWidth, viewWidth * proportion);
        } else if (self.type == 3) {
            
            if (a == 0) {
                classImage.frame = CGRectMake(0,CGRectGetMaxY(topimage.frame)+a*viewWidth, viewWidth , viewWidth*proportion);
                firstHeigth = classImage.bounds.size.height;
            } else if (a == 1) {
                classImage.frame = CGRectMake(0,CGRectGetMaxY(topimage.frame)+a*firstHeigth, viewWidth, viewWidth* proportion);
                secondHeigth = CGRectGetMaxY(classImage.frame);
            } else {
                classImage.frame = CGRectMake(0,secondHeigth,viewWidth,viewWidth * proportion);
            }
        } else {
            if (a == 0) {
                classImage.frame = CGRectMake(interval,interval + CGRectGetMaxY(topimage.frame)+a*((viewWidth - interval*2) * proportion), viewWidth - interval*2, (viewWidth - interval*2) * proportion);
                firstHeigth = classImage.bounds.size.height;
            } else if (a == 1) {
                classImage.frame = CGRectMake(interval,interval +CGRectGetMaxY(topimage.frame)+a*(firstHeigth + interval), viewWidth - interval*2, (viewWidth - interval*2) * proportion);
                secondHeigth = CGRectGetMaxY(classImage.frame);
            } else {
                classImage.frame = CGRectMake(interval,secondHeigth + interval, viewWidth - interval*2, (viewWidth - interval*2) * proportion);
            }
        }
        [classImage setImageWithURL:[NSURL URLWithString:imageModel.imageURL]];
        classImage.tag = a+1;
        [classScrollView addSubview:classImage];
        pictureHeight = CGRectGetMaxY(classImage.frame);
    }
    noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake(viewHeight/133.4,pictureHeight + viewHeight/66.7, viewWidth - viewHeight/66.7, viewHeight/7.847)];
    [noticeImage setImage:[UIImage imageNamed:@"class_notice"]];
    [classScrollView addSubview:noticeImage];
    
    UIImageView *buttomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noticeImage.frame) + viewHeight/33.35, viewWidth, viewHeight/4.764)];
    [buttomImage setImage:[UIImage imageNamed:@"class_buttomImage"]];
    if (self.type == 2) {
        [buttomImage setImage:[UIImage imageNamed:@"yoga_buttomImage"]];
    }
    buttomImage.userInteractionEnabled = YES;
    [classScrollView addSubview:buttomImage];
    
    
    xinButton = [MCFireworksButton buttonWithType:UIButtonTypeRoundedRect];
    xinButton.particleImage = [UIImage imageNamed:@"Sparkle1"];
    xinButton.particleScale = 0.05;
    xinButton.particleScaleRange = 0.02;
    xinButton.frame = CGRectMake((viewWidth - viewHeight/10.5873)/2, viewHeight/33.35, viewHeight/23.8214, viewHeight/27.792);
    if (ipraised == 0) {
        [xinButton setBackgroundImage:[UIImage imageNamed:@"class_grayxin"] forState:UIControlStateNormal];
    } else {
        [xinButton setBackgroundImage:[UIImage imageNamed:@"class_orangexin"] forState:UIControlStateNormal];
    }
    
    [xinButton addTarget:self action:@selector(xinButton) forControlEvents:UIControlEventTouchUpInside];
    [buttomImage addSubview:xinButton];
    
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(xinButton.frame)+viewHeight/133.4, CGRectGetMinY(xinButton.frame), viewHeight/6.67, viewHeight/27.792)];
    numberLabel.textColor = [UIColor orangeColor];
    numberLabel.font = [UIFont fontWithName:FONT size:viewHeight/27.792];
    numberLabel.text = [NSString stringWithFormat:@"%d",zanNumber];
    [buttomImage addSubview:numberLabel];
    
    UILabel *likeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth - viewHeight/6.67)/2, CGRectGetMaxY(xinButton.frame)+viewHeight/133.1, viewHeight/6.67, viewHeight/33.35)];
    likeTextLabel.textColor = [UIColor lightGrayColor];
    likeTextLabel.text = @"喜欢课程请点赞";
    likeTextLabel.font = [UIFont italicSystemFontOfSize:viewHeight/51.308];
    [buttomImage addSubview:likeTextLabel];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/133.4, buttomImage.bounds.size.height - viewHeight/22.233, viewWidth/2, viewHeight/83.375)];
    photoLabel.text = @"热线:010-65460058";
    photoLabel.textColor = [UIColor lightGrayColor];
    photoLabel.font = [UIFont fontWithName:FONT size:viewHeight/55.5833];
    [buttomImage addSubview:photoLabel];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth/2 - viewHeight/133.4, buttomImage.bounds.size.height - viewHeight/22.233, viewWidth/2, viewHeight/83.375)];
    nameLabel.text = @"果动(北京)网络科技有限公司";
    nameLabel.textAlignment = 2;
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.font = [UIFont fontWithName:FONT size:viewHeight/55.583];
    [buttomImage addSubview:nameLabel];
    
    moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - NavigationBar_Height - viewHeight/11.117, viewWidth, viewHeight/11.117)];
    moneyView.userInteractionEnabled = YES;
    moneyView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:moneyView];
    
    
    sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake(viewWidth/2+(viewWidth/2 - viewHeight/4.4467)/2, (moneyView.bounds.size.height - viewHeight/17.78667)/2, viewHeight/4.4467, viewHeight/17.78667);
    [sureButton addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"class_xiadan"] forState:UIControlStateNormal];
    
    
    NSString *attriStr = [NSString stringWithFormat:@"%d 元/课时",classNumber];
    if (classNumber) {
        str = [[NSMutableAttributedString alloc] initWithString:attriStr];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight/33.35] range:NSMakeRange(0,3)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight/51.308] range:NSMakeRange(3,5)];
        
        [moneyView addSubview:sureButton];
    }
    
    UILabel *classMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, viewHeight/33.35, viewWidth/2, viewHeight/33.35)];
    classMoneyLabel.textAlignment = 1;
    classMoneyLabel.textColor = [UIColor orangeColor];
    classMoneyLabel.attributedText = str;
    [moneyView addSubview:classMoneyLabel];
    
    classScrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(buttomImage.frame)+NavigationBar_Height + moneyView.bounds.size.height);
    
}
-(void)xinButton
{
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdcourse.praise&class_id=%@",BASEURL,self.class_id];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if ([[responseObject objectForKey:@"rc"] intValue] == 0) {
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"result"] intValue] == 1) {
                [xinButton popOutsideWithDuration:0.5];
                [xinButton setBackgroundImage:[UIImage imageNamed:@"class_orangexin"] forState:UIControlStateNormal];
                [xinButton animate];
            }
            else
            {
                [xinButton popInsideWithDuration:0.4];
                [xinButton setBackgroundImage:[UIImage imageNamed:@"class_grayxin"] forState:UIControlStateNormal];
            }
            
            numberLabel.text = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"total"]];
        }
    } fail:^(NSError *error) {
        NSLog(@"error  %@",error);
    }];
}
-(void)sureButton
{
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdcourse.course&class_id=%@",BASEURL,self.class_id];
    NSLog(@"url  %@",url);
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        NSLog(@"res  %@",responseObject);
        if ([[responseObject objectForKey:@"rc"] intValue] == 0) {
            appointViewController *appoint = [appointViewController new];
            appoint.course = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"course"]) {
                Message *message = [[Message alloc] initWithDictionary:dict];
                [appoint.course addObject:message];
                
            }
            appoint.dateArray = [[responseObject objectForKey:@"data"] objectForKey:@"pre_times"];
            appoint.isFirst = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"isfirst"]] ;
            appoint.type = self.type;
            appoint.youhuijuan = [[responseObject objectForKey:@"data"] objectForKey:@"money"];
            appoint.alertString = [[responseObject objectForKey:@"data"] objectForKey:@"alert"];
            appoint.class_id = self.class_id;
            appoint.personNumber = [[[responseObject objectForKey:@"data"] objectForKey:@"courseTotal"] intValue];
           
            appoint.discont = [[responseObject objectForKey:@"data"] objectForKey:@"discont"];
            appoint.vip_cards = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"vip_cards"]];
            if ([appoint.isFirst intValue] == 0) {
                appoint.userinfo_name = [[[responseObject objectForKey:@"data"] objectForKey:@"userInfo"] objectForKey:@"name"];
                appoint.userinfo_number = [[[responseObject objectForKey:@"data"] objectForKey:@"userInfo"] objectForKey:@"phone"];
                appoint.userinfo_address = [[[responseObject objectForKey:@"data"] objectForKey:@"userInfo"] objectForKey:@"address"];
                NSLog(@"appoint.userinfo_name %@",appoint.userinfo_name);
            }
            
            [self.navigationController pushViewController:appoint animated:YES];
        }
    } fail:^(NSError *error) {
        NSLog(@"error  %@",error);
    }];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
    
}
@end
