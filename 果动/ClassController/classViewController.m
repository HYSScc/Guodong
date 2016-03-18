//
//  classViewController.m
//  果动
//
//  Created by mac on 15/9/23.
//  Copyright © 2015年 Unique. All rights reserved.
//



#import "FeSpinnerTenDot.h" //加载界面
#import "LoginViewController.h"
#import "MCFireworksButton.h"
#import "Message.h"
#import "TopView.h"
#import "appointViewController.h"
#import "classViewController.h"
#import "image.h"
#import "priceList.h"



#import <CoreText/CoreText.h>
@interface classViewController () <FeSpinnerTenDotDelegate> {
    UIImageView* topimage;
    NSMutableArray* imageArray;
    UIScrollView* classScrollView;
    UIImageView* xinImage;
    UIImageView* noticeImage;
    MCFireworksButton* xinButton;
    UILabel* classnumberLabel;
    NSMutableAttributedString* str;
    UILabel* numberLabel;
    NSString* requestURL;
    NSString* zanUrl;
    NSString* sureUrl;
    BOOL selected;
    int ipraised;
    int personNmuber;
    int classNumber;
    int zanNumber;
    int topImagetype;
    CGFloat firstHeigth;
    CGFloat secondHeigth;
    CGFloat pictureHeight;

    UIView* moneyView;
    UIButton* sureButton;
}
@property (strong, nonatomic) FeSpinnerTenDot* spinner;
@end

@implementation classViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    BackView* backView = [[BackView alloc] initWithbacktitle:@"首页" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;

    _spinner = [[FeSpinnerTenDot alloc] initWithView:self.view withBlur:NO];
    _spinner.titleLabelText = @"LOADING";
    _spinner.delegate = self;
    _spinner.fontTitleLabel = [UIFont fontWithName:@"Neou-Thin" size:Adaptive(36)];
    [self.view addSubview:_spinner];
    [_spinner show];

    [imageArray removeAllObjects];
    [classScrollView removeFromSuperview];
    //成立则表示从体验店进入
    if (self.isShop) {
        requestURL = [NSString stringWithFormat:@"%@api/?method=gdcourse.gdstore_inc&id=%@", BASEURL, self.shop_id];
    } else {
        //从订课界面进入
        requestURL = [NSString stringWithFormat:@"%@api/?method=gdcourse.introduce&class_id=%d", BASEURL, self.class_id];
    }
    [HttpTool postWithUrl:requestURL params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            imageArray = [NSMutableArray array];
            [_spinner dismiss];
            NSDictionary* data = [responseObject objectForKey:@"data"];
            personNmuber = [[data objectForKey:@"courseTotal"] intValue];

            if (!self.isShop) {
                classNumber = [[data objectForKey:@"price"] intValue];
            }
            zanNumber = [[data objectForKey:@"praiseTotal"] intValue];
            ipraised = [[data objectForKey:@"ipraised"] intValue];

            for (NSDictionary* dict in [data objectForKey:@"imgUrl"]) {
                image* imageModel = [[image alloc] initWithDictionary:dict];
                [imageArray addObject:imageModel];
            }
            [self setTopImage];
        } else if (ResponseObject_RC == NotLogin_RC_Number) {
            [HeadComment message:@"您还没有登录呢！" delegate:self witchCancelButtonTitle:@"暂不" otherButtonTitles:@"去登录", nil];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
        fail:^(NSError* error){
        }];
}
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.titleView = [HeadComment titleLabeltext:self.titleString];
   
}
- (void)setTopImage
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
    TopView* topView = [[TopView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(220)) imageTypeWith:topImagetype ClassNumberWith:personNmuber showClassNumberWith:YES];
    [classScrollView addSubview:topView];

    /*
     计算宽高比
     宽度一定
     高度根据 屏幕宽度 与 图片宽度的比例算出
     */
    NSLog(@"imageArray %@", imageArray);

    for (int a = 0; a < imageArray.count; a++) {
        image* imageModel = [imageArray objectAtIndex:a];

        UIImageView* classImage = [[UIImageView alloc] init];
        CGFloat interval = Adaptive(15);
        CGFloat proportion = ([imageModel.height floatValue] / 2) / ([imageModel.width floatValue] / 2);

        if (self.class_id == 3) {
            if (a == 0) {
                classImage.frame = CGRectMake(0, CGRectGetMaxY(topView.frame) + a * viewWidth, viewWidth, viewWidth * proportion);
                firstHeigth = classImage.bounds.size.height;
            } else {
                classImage.frame = CGRectMake(0, secondHeigth, viewWidth, viewWidth * proportion);
            }
            secondHeigth = CGRectGetMaxY(classImage.frame);
        } else {
            if (a == 0) {
                classImage.frame = CGRectMake(interval, interval + CGRectGetMaxY(topView.frame) + a * ((viewWidth - interval * 2) * proportion), viewWidth - interval * 2, (viewWidth - interval * 2) * proportion);
            } else {
                classImage.frame = CGRectMake(interval, firstHeigth + interval, viewWidth - interval * 2, (viewWidth - interval * 2) * proportion);
            }
            firstHeigth = CGRectGetMaxY(classImage.frame);
        }
        [classImage setImageWithURL:[NSURL URLWithString:imageModel.imageURL]];
        classImage.tag = a + 1;
        [classScrollView addSubview:classImage];
        pictureHeight = CGRectGetMaxY(classImage.frame);
    }
    noticeImage = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(5), pictureHeight + Adaptive(10), viewWidth - Adaptive(10), Adaptive(85))];
    [noticeImage setImage:[UIImage imageNamed:@"class_notice"]];
    [classScrollView addSubview:noticeImage];

    UIImageView* buttomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noticeImage.frame) + Adaptive(20), viewWidth, Adaptive(140))];
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
    xinButton.frame = CGRectMake((viewWidth - Adaptive(63)) / 2, Adaptive(20), Adaptive(28), Adaptive(24));
    if (ipraised == 0) {
        [xinButton setBackgroundImage:[UIImage imageNamed:@"class_grayxin"] forState:UIControlStateNormal];
    } else {
        [xinButton setBackgroundImage:[UIImage imageNamed:@"class_orangexin"] forState:UIControlStateNormal];
    }

    [xinButton addTarget:self action:@selector(xinButton) forControlEvents:UIControlEventTouchUpInside];
    [buttomImage addSubview:xinButton];

    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(xinButton.frame) + Adaptive(5), CGRectGetMinY(xinButton.frame), Adaptive(100), Adaptive(24))];
    numberLabel.textColor = [UIColor orangeColor];
    numberLabel.font = [UIFont fontWithName:FONT size:Adaptive(24)];
    numberLabel.text = [NSString stringWithFormat:@"%d", zanNumber];
    [buttomImage addSubview:numberLabel];

    UILabel* likeTextLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(100)) / 2, CGRectGetMaxY(xinButton.frame) + Adaptive(5), Adaptive(100), Adaptive(20))];
    likeTextLabel.textColor = [UIColor lightGrayColor];
    likeTextLabel.text = @"喜欢课程请点赞";
    likeTextLabel.font = [UIFont italicSystemFontOfSize:Adaptive(13)];
    [buttomImage addSubview:likeTextLabel];

    UILabel* photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(5), buttomImage.bounds.size.height - Adaptive(30), viewWidth / 2, Adaptive(8))];
    photoLabel.text = @"热线:010-65460058";
    photoLabel.textColor = [UIColor lightGrayColor];
    photoLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    [buttomImage addSubview:photoLabel];

    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth / 2 - Adaptive(5), buttomImage.bounds.size.height - Adaptive(30), viewWidth / 2, Adaptive(8))];
    nameLabel.text = @"果动(北京)网络科技有限公司";
    nameLabel.textAlignment = 2;
    nameLabel.textColor = [UIColor lightGrayColor];
    nameLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    [buttomImage addSubview:nameLabel];

    moneyView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight - NavigationBar_Height   - Adaptive(60), viewWidth, Adaptive(60))];
    moneyView.userInteractionEnabled = YES;
    moneyView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:moneyView];

    sureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    sureButton.frame = CGRectMake(viewWidth / 2 + (viewWidth / 2 - Adaptive(150)) / 2, (moneyView.bounds.size.height - Adaptive(37.5)) / 2, Adaptive(150), Adaptive(37.5));
    [sureButton addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
    [sureButton setBackgroundImage:[UIImage imageNamed:@"class_xiadan"] forState:UIControlStateNormal];

    if (self.isShop) {

        UIButton* shopSureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        shopSureButton.frame = CGRectMake(0, viewHeight - NavigationBar_Height - Adaptive(60), viewWidth, Adaptive(60));
        shopSureButton.backgroundColor = [UIColor orangeColor];
        [shopSureButton setTitle:@"订课" forState:UIControlStateNormal];
        [shopSureButton addTarget:self action:@selector(sureButton) forControlEvents:UIControlEventTouchUpInside];
        [shopSureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        shopSureButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(18)];
        [self.view addSubview:shopSureButton];
    }

    NSString* attriStr = [NSString stringWithFormat:@"%d 元/课时", classNumber];
    if (classNumber) {
        str = [[NSMutableAttributedString alloc] initWithString:attriStr];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(20)] range:NSMakeRange(0, 3)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:Adaptive(13)] range:NSMakeRange(3, 5)];

        [moneyView addSubview:sureButton];
    }

    UILabel* classMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, Adaptive(20), viewWidth / 2, Adaptive(20))];
    classMoneyLabel.textAlignment = 1;
    classMoneyLabel.textColor = [UIColor orangeColor];
    classMoneyLabel.attributedText = str;
    [moneyView addSubview:classMoneyLabel];

    classScrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(buttomImage.frame) + NavigationBar_Height + moneyView.bounds.size.height);
}
- (void)xinButton
{
    if (self.isShop) {
        zanUrl = [NSString stringWithFormat:@"%@api/?method=gdcourse.praise&class_id=%@&types=2", BASEURL, self.shop_id];
    } else {
        zanUrl = [NSString stringWithFormat:@"%@api/?method=gdcourse.praise&class_id=%d", BASEURL, self.class_id];
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
            numberLabel.text = [NSString stringWithFormat:@"%@", [[responseObject objectForKey:@"data"] objectForKey:@"total"]];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }fail:^(NSError* error){}];
}
- (void)sureButton
{
    //[self.navigationController pushViewController:[payViewController new] animated:YES];
    appointViewController *appoint  = [appointViewController new];
    appoint.packageArray = [NSMutableArray array];
    if (self.isShop) {
        sureUrl = [NSString stringWithFormat:@"%@api/?method=gdcourse.course&class_id=%@&types=2", BASEURL, self.shop_id];
        
    } else {
        sureUrl = [NSString stringWithFormat:@"%@api/?method=gdcourse.course&class_id=%d", BASEURL, self.class_id];
        
    }
    [HttpTool postWithUrl:sureUrl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            
            NSDictionary          *dataDict = [responseObject objectForKey:@"data"];
            appoint.course = [NSMutableArray array];
            for (NSDictionary* dict in [dataDict objectForKey:@"course"]) {
                Message* message = [[Message alloc] initWithDictionary:dict];
                [appoint.course addObject:message];

                appoint.price_list = [NSMutableArray array];
                for (NSDictionary* priceDict in [dict objectForKey:@"price_list"]) {
                    priceList* price = [[priceList alloc] initWithDictionary:priceDict];
                    [appoint.price_list addObject:price];
                }
                
                
            }
            
            
        //    appoint.packageArray = [dataDict objectForKey:@"package"];
            appoint.class_id = self.class_id;
            
            appoint.isShop = self.isShop;
            appoint.dateArray = [dataDict objectForKey:@"pre_times"];
            appoint.isFirst = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"isfirst"]];

            appoint.youhuijuan = [dataDict objectForKey:@"money"];
            appoint.alertString = [dataDict objectForKey:@"alert"];
           
            appoint.personNumber = [[dataDict objectForKey:@"courseTotal"] intValue];

            appoint.discont = [dataDict objectForKey:@"discont"];
            appoint.vip_cards = [NSString stringWithFormat:@"%@", [dataDict objectForKey:@"vip_cards"]];
            if ([appoint.isFirst intValue] == 0) {
                appoint.userinfo_name = [[dataDict objectForKey:@"userInfo"] objectForKey:@"name"];
                appoint.userinfo_number = [[dataDict objectForKey:@"userInfo"] objectForKey:@"phone"];
                appoint.userinfo_address = [[dataDict objectForKey:@"userInfo"] objectForKey:@"address"];
            }
            [self.navigationController pushViewController:appoint animated:YES];
          
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError* error){}];
}

@end
