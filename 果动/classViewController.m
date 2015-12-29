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
#import "TopView.h"
#import "priceList.h"
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
    NSString *requestURL;
    NSString *zanUrl;
    NSString *sureUrl;
    BOOL selected;
    int ipraised;
    int personNmuber;
    int classNumber;
    int zanNumber;
    int topImagetype;
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
    //成立则表示从体验店进入
    if (self.isShop) {
        requestURL = [NSString stringWithFormat:@"%@api/?method=gdcourse.gdstore_inc&id=%@",BASEURL,self.shop_id];
            } else {
        //从订课界面进入
        requestURL = [NSString stringWithFormat:@"%@api/?method=gdcourse.introduce&class_id=%d",BASEURL,self.class_id];
        
    }
    [HttpTool postWithUrl:requestURL params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            imageArray = [NSMutableArray array];
            [_spinner dismiss];
            NSDictionary *data = [responseObject objectForKey:@"data"];
            personNmuber = [[data objectForKey:@"courseTotal"] intValue];
            
            if (!self.isShop) {
                classNumber = [[data objectForKey:@"price"] intValue];
            }
            zanNumber = [[data objectForKey:@"praiseTotal"] intValue];
            ipraised = [[data objectForKey:@"ipraised"] intValue];
            
            for (NSDictionary *dict in [data objectForKey:@"imgUrl"]) {
                image *imageModel = [[image alloc] initWithDictionary:dict];
                [imageArray addObject:imageModel];
            }
            [self setTopImage];
        } else if (ResponseObject_RC == NotLogin_RC_Number) {
            [HeadComment message:@"您还没有登录呢！" delegate:self witchCancelButtonTitle:@"暂不" otherButtonTitles:@"去登录", nil];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError *error) {}];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.titleView = [HeadComment titleLabeltext:self.titleString];
}
-(void)setTopImage
{
    classScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    classScrollView.backgroundColor = [UIColor blackColor];
   
    if (self.class_id == 2 || self.class_id == 4) {
        classScrollView.backgroundColor = [UIColor whiteColor];
    }
    classScrollView.bounces = NO; //不允许弹性滑动
    
    [self.view addSubview:classScrollView];
    
    //顶部视图
    topImagetype = self.isShop ? 5 : self.class_id;
    TopView *topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/3.032) imageTypeWith:topImagetype ClassNumberWith:personNmuber showClassNumberWith:YES];
    [classScrollView addSubview:topView];
    
    /*
     计算宽高比
     宽度一定
     高度根据 屏幕宽度 与 图片宽度的比例算出
     */
   NSLog(@"imageArray %@",imageArray);
    
    
    for (int a = 0; a < imageArray.count; a++) {
        image *imageModel = [imageArray objectAtIndex:a];
        
        UIImageView *classImage = [[UIImageView alloc] init];
        CGFloat interval = viewHeight/44.467;
        CGFloat proportion =  ([imageModel.height floatValue]/2)/([imageModel.width floatValue]/2);
        
        if (self.class_id == 3) {
            if (a == 0) {
                classImage.frame = CGRectMake(0,CGRectGetMaxY(topView.frame)+a*viewWidth, viewWidth , viewWidth*proportion);
                firstHeigth = classImage.bounds.size.height;
            } else {
                classImage.frame = CGRectMake(0,secondHeigth,viewWidth,viewWidth * proportion);
            }
            secondHeigth = CGRectGetMaxY(classImage.frame);
        } else {
           if (a == 0) {
                classImage.frame = CGRectMake(interval,interval + CGRectGetMaxY(topView.frame)+a*((viewWidth - interval*2) * proportion), viewWidth - interval*2, (viewWidth - interval*2) * proportion);
            } else {
                classImage.frame = CGRectMake(interval,firstHeigth + interval, viewWidth - interval*2, (viewWidth - interval*2) * proportion);
            }
                firstHeigth = CGRectGetMaxY(classImage.frame);
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
    if (self.class_id == 2) {
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
    
    if (self.isShop) {
        
        UIButton *shopSureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shopSureButton.frame = CGRectMake(0, viewHeight - NavigationBar_Height - viewHeight/11.117, viewWidth, viewHeight/11.117);
        shopSureButton.backgroundColor = [UIColor orangeColor];
        [shopSureButton setTitle:@"订课" forState:UIControlStateNormal];
        [shopSureButton addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
        [shopSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopSureButton.titleLabel.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
        [self.view addSubview:shopSureButton];
    }
    
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
    if (self.isShop) {
         zanUrl = [NSString stringWithFormat:@"%@api/?method=gdcourse.praise&class_id=%@&types=2",BASEURL,self.shop_id];
    } else {
         zanUrl = [NSString stringWithFormat:@"%@api/?method=gdcourse.praise&class_id=%d",BASEURL,self.class_id];
    }
   
    [HttpTool postWithUrl:zanUrl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
       
        if (ResponseObject_RC == 0) {
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"result"] intValue] == 1) {
                [xinButton popOutsideWithDuration:0.5];
                [xinButton setBackgroundImage:[UIImage imageNamed:@"class_orangexin"] forState:UIControlStateNormal];
                [xinButton animate];
            } else {
                [xinButton popInsideWithDuration:0.4];
                [xinButton setBackgroundImage:[UIImage imageNamed:@"class_grayxin"] forState:UIControlStateNormal];
            }
            numberLabel.text = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"total"]];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError *error) {}];
}
-(void)sureButton
{
    if (self.isShop) {
      sureUrl = [NSString stringWithFormat:@"%@api/?method=gdcourse.course&class_id=%@&types=2",BASEURL,self.shop_id];
    } else {
      sureUrl = [NSString stringWithFormat:@"%@api/?method=gdcourse.course&class_id=%d",BASEURL,self.class_id];
    }
    [HttpTool postWithUrl:sureUrl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            appointViewController *appoint = [appointViewController new];
            appoint.course = [NSMutableArray array];
            for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"course"]) {
                Message *message = [[Message alloc] initWithDictionary:dict];
                [appoint.course addObject:message];
                
                appoint.price_list = [NSMutableArray array];
                for (NSDictionary *priceDict in [dict objectForKey:@"price_list"]) {
                    priceList *price = [[priceList alloc] initWithDictionary:priceDict];
                    [appoint.price_list addObject:price];
                }
            }
            appoint.isShop = self.isShop;
            appoint.dateArray = [[responseObject objectForKey:@"data"] objectForKey:@"pre_times"];
            appoint.isFirst = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"isfirst"]] ;
            
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
            }
            [self.navigationController pushViewController:appoint animated:YES];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError *error) {}];
}

@end
