//
//  DataViewController.m
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "AppDelegate.h"
#import "MyDataModel.h"
#import "DataViewController.h"
#import "DataCollectionViewCell.h"
#import "LoginViewController.h"
#import "ImgScrollerView.h"
#import "TapImageView.h"
#import "DataTitleView.h"
#import "DataCompareView.h"


@interface DataViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,assign) int page;
@property (nonatomic) NSInteger row;
@property (nonatomic,retain) UICollectionView *collectionView;
@end

@implementation DataViewController
{
    UIScrollView     *titleScrollView;
    UIScrollView     *dataScrollView;
    NSMutableArray   *dataArray;
    NSMutableArray   *imageArray;
    UIScrollView *myScrollView;
    NSInteger     currentIndex;
    UIView       *markView;
    UIView       *scrollPanel;
    int   tagNumber;
    float   contentOffset_Y;
    float   contentOffset_X;
    UIButton *jtxlButton;
    UILabel *topTitleLabel;
    UIImageView *ringImageView;
    
    DataCompareView *weightView;
    DataCompareView *fatView;
    DataCompareView *bmiView;
    DataCompareView *ytblView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden           = YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    if ([HttpTool judgeWhetherUserLogin]) {
        
        _userName = [_userName isEqual:[NSNull null]] ? _userName : @"我";
        
        NavigationView *navigation = [[NavigationView alloc] initWithtitle:[NSString stringWithFormat:@"%@的数据",_userName] viewController:self];
        [self.view addSubview:navigation];
        [self startRequest];
    } else {
        
        NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"我的数据" viewController:self];
        [self.view addSubview:navigation];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }
    
    
    contentOffset_Y = 0;
    contentOffset_X = 0;
    _page           = 1;
    _row            = 0;
    dataArray       = [NSMutableArray array];
    // [self createUI];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}

- (void)startRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.mybody",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        dataArray = [NSMutableArray array];
        _page = 1;
        for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
            MyDataModel *dataModel = [[MyDataModel alloc] initWithDictionary:dict];
            [dataArray addObject:dataModel];
            
            
        }
        [_collectionView reloadData];
    }];
    
    NSString *titleUrl = [NSString stringWithFormat:@"%@api/?method=user.body",BASEURL];
    [HttpTool postWithUrl:titleUrl params:nil body:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        
        
        NSString *text = [[responseObject objectForKey:@"data"] objectForKey:@"text"];
        
        [self createUIWithText:text];
        
        
    }];
    
}
- (void)createUIWithText:(NSString *)text {
    
    
    UIScrollView *baseScrollView = [UIScrollView new];
    baseScrollView.frame         = CGRectMake(0,
                                              NavigationBar_Height,
                                              viewWidth,
                                              viewHeight - NavigationBar_Height);
    baseScrollView.contentSize = CGSizeMake(viewWidth, viewHeight * 2.1);
    [self.view addSubview:baseScrollView];
    
    
    CGFloat MaxTopTitleY;
    
    if (text.length != 0) {
        // 顶部概括语
        
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT_BOLD size:Adaptive(15)]} context:nil].size;
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
        
        str = [[NSMutableAttributedString alloc] initWithData:
               [text dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
        
        topTitleLabel                = [UILabel new];
        topTitleLabel.frame          = CGRectMake(Adaptive(13),
                                                  Adaptive(23),
                                                  viewWidth - Adaptive(26),
                                                  textSize.height);
        topTitleLabel.numberOfLines  = 0;
        topTitleLabel.attributedText = str;
        [topTitleLabel sizeToFit];
        [baseScrollView addSubview:topTitleLabel];

        MaxTopTitleY = CGRectGetMaxY(topTitleLabel.frame) ;
    } else {
        MaxTopTitleY = - Adaptive(15);
    }
    
    
    
    UILabel *orangeLine = [UILabel new];
    orangeLine.frame    = CGRectMake(0,
                                     MaxTopTitleY + Adaptive(36.5),
                                     Adaptive(128),
                                     1);
    orangeLine.backgroundColor = ORANGECOLOR;
    [baseScrollView addSubview:orangeLine];
    
    
    ringImageView       = [UIImageView new];
    ringImageView.frame = CGRectMake(CGRectGetMaxX(orangeLine.frame),
                                     MaxTopTitleY + Adaptive(30),
                                     Adaptive(13),
                                     Adaptive(13));
    ringImageView.image = [UIImage imageNamed:@"person_data_ring"];
    [baseScrollView addSubview:ringImageView];
    
    /******************添加左边的标题*******************/
    NSArray* titleArray = @[@"照片",@"身高", @"体重", @"腰围", @"臀围", @"脂肪百分比", @"BMI",@"腰臀比例", @"右大腿", @"左大腿", @"右小腿", @"左小腿", @"左上臂(放松)", @"左上臂(屈曲)", @"右上臂(放松)", @"右上臂(屈曲)", @"胸围(放松)", @"胸围(扩张)", @"肱三头肌皮脂", @"髋嵴上缘皮脂", @"肩胛下缘皮脂", @"腹部皮脂", @"大腿皮脂", @"皮脂总和",  @"静态心率", @"血压", @"目标心率" ];
    
    for (int a = 0; a < [titleArray count]; a++) {
        
        CGRect   lastFrame;
        NSString *contentName = nil;
        
        if (a == 0) {
            lastFrame = CGRectMake(0,CGRectGetMaxY(orangeLine.frame),Adaptive(128),Adaptive(140));
        } else {
            lastFrame = CGRectMake(0,CGRectGetMaxY(orangeLine.frame) + Adaptive(140) + Adaptive(40) * (a - 1),
                                   Adaptive(128),
                                   Adaptive(40));
        }
        switch (a) {
            case 5:
                contentName = @"(标准:12%-18%)";
                break;
            case 6:
                contentName = @"(标准:18.5-22.9)";
                break;
            case 7:
                contentName = @"(标准: <0.9)";
                break;
            case 24:
                contentName = @"(标准:60-70)";
                break;
            case 25:
                contentName = @"(标准:80-120)";
                break;
                
            default:
                break;
        }
        
        NSString *imageName = [NSString stringWithFormat:@"data_%d",a + 1];
        
        DataTitleView *titleView = [[DataTitleView alloc] initWithFrame:lastFrame titleName:titleArray[a] contentName:contentName imageName:imageName];
        [baseScrollView addSubview:titleView];
        
    }
    
    /******************添加数据************************/
    
    
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//设置横向
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(Adaptive(128), MaxTopTitleY + Adaptive(30) , viewWidth - Adaptive(141), viewHeight*2.1) collectionViewLayout:flowLayout];
    
    // _collectionView.pagingEnabled = YES;
    _collectionView.scrollEnabled = NO;
    _collectionView.delegate      = self;
    _collectionView.dataSource    = self;
    [_collectionView registerClass:[DataCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [baseScrollView addSubview:_collectionView];
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    [baseScrollView addGestureRecognizer:swipeGesture];
    
    UISwipeGestureRecognizer *swipeGesture1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGesture:)];
    swipeGesture1.direction = UISwipeGestureRecognizerDirectionRight;
    [baseScrollView addGestureRecognizer:swipeGesture1];
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)swipeGesture{
    
    if(swipeGesture.direction == UISwipeGestureRecognizerDirectionRight){
        // 右
        
        if (_row > 0) {
            NSLog(@"右   row %ld",(long)_row);
            
            // row减之前先改变字体大小颜色
            DataCollectionViewCell *cell = (DataCollectionViewCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_row inSection:0]];
            
            [self changeFontAndColorWithCell:cell  direction:@"right"];
            
            
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:--_row inSection:0];
            
            NSLog(@"_row-- %ld",(long)indexPath.row);
            [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES ];
            
            
            
            // 移动weightView 位置
            
            [UIView animateWithDuration:.3f animations:^{
                DataCollectionViewCell *dataCell = (DataCollectionViewCell *)[self collectionView:_collectionView cellForItemAtIndexPath:indexPath];
                
                 // 移动weightView的位置 && 改变比较结果
                CGRect  weightFrame   =  weightView.frame;
                weightFrame.origin.x -= dataCell.bounds.size.width;
                NSDictionary *BMIDict = [self calculateResultWithText:[(UILabel *)[dataCell viewWithTag:106] text] type:@"BMI"];
                [self changeWeightViewWithFrame:weightFrame title:BMIDict[@"string"] compare:[BMIDict[@"number"] intValue]];
                 [[(UILabel *)[dataCell viewWithTag:106] text] length] != 0 ? [_collectionView addSubview:weightView] :[weightView removeFromSuperview];
                
                // 移动fatView的位置 && 改变比较结果
                CGRect  fatFrame   =  fatView.frame;
                fatFrame.origin.x -= dataCell.bounds.size.width;
                NSDictionary *fatDict = [self calculateResultWithText:[(UILabel *)[dataCell viewWithTag:105] text] type:@"FAT"];
                [self changeFatViewWithFrame:fatFrame title:fatDict[@"string"] compare:[fatDict[@"number"] intValue]];
                [[(UILabel *)[dataCell viewWithTag:105] text] length] != 0 ? [_collectionView addSubview:fatView] :[fatView removeFromSuperview];
                
                // 移动bmiView的位置 && 改变比较结果
                CGRect  BMIFrame   =  bmiView.frame;
                BMIFrame.origin.x -= dataCell.bounds.size.width;
                [self changeBMIViewWithFrame:BMIFrame title:fatDict[@"string"] compare:[fatDict[@"number"] intValue]];
                [[(UILabel *)[dataCell viewWithTag:106] text] length] != 0 ? [_collectionView addSubview:bmiView] :[bmiView removeFromSuperview];
                
                // 移动fatView的位置 && 改变比较结果
                CGRect  ytblFrame   =  ytblView.frame;
                ytblFrame.origin.x -= dataCell.bounds.size.width;
                NSDictionary *YTBLDict = [self calculateResultWithText:[(UILabel *)[dataCell viewWithTag:107] text] type:@"YTBL"];
                [self changeYTBLViewWithFrame:ytblFrame title:YTBLDict[@"string"] compare:[YTBLDict[@"number"] intValue]];
                [[(UILabel *)[dataCell viewWithTag:107] text] length] != 0 ? [_collectionView addSubview:ytblView] :[ytblView removeFromSuperview];
            }];
        } else {
            // 当row等于0时不让其滑动
            [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
            
        }
        // 滑动小球隐藏
        if (_row < 1) {
            [UIView animateWithDuration:.2f animations:^{
                CGRect ringFrame = ringImageView.frame;
                ringFrame.origin.x = Adaptive(128);
                ringImageView.frame = ringFrame;
            }];
        }
        
        
    }
    if (swipeGesture.direction == UISwipeGestureRecognizerDirectionLeft){
        // 左
        
        if (_row < dataArray.count-2) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:++_row inSection:0];
            [UIView animateWithDuration:.3f animations:^{
                
                DataCollectionViewCell *dataCell = (DataCollectionViewCell *)[_collectionView cellForItemAtIndexPath:indexPath];
                
                // 移动weightView的位置 && 改变比较结果
                CGRect  weightFrame   =  weightView.frame;
                weightFrame.origin.x += dataCell.bounds.size.width;
                NSDictionary *BMIDict = [self calculateResultWithText:[(UILabel *)[dataCell viewWithTag:106] text] type:@"BMI"];
                [self changeWeightViewWithFrame:weightFrame title:BMIDict[@"string"] compare:[BMIDict[@"number"] intValue]];
                [[(UILabel *)[dataCell viewWithTag:106] text] length] != 0 ? [_collectionView addSubview:weightView] :[weightView removeFromSuperview];
                
                // 移动fatView的位置 && 改变比较结果
                CGRect  fatFrame   =  fatView.frame;
                fatFrame.origin.x += dataCell.bounds.size.width;
                NSDictionary *fatDict = [self calculateResultWithText:[(UILabel *)[dataCell viewWithTag:105] text] type:@"FAT"];
                [self changeFatViewWithFrame:fatFrame title:fatDict[@"string"] compare:[fatDict[@"number"] intValue]];
               [[(UILabel *)[dataCell viewWithTag:105] text] length] != 0 ? [_collectionView addSubview:fatView] :[fatView removeFromSuperview];
                
                // 移动bmiView的位置 && 改变比较结果
                CGRect  BMIFrame   =  bmiView.frame;
                BMIFrame.origin.x += dataCell.bounds.size.width;
                [self changeBMIViewWithFrame:BMIFrame title:BMIDict[@"string"] compare:[BMIDict[@"number"] intValue]];
                [[(UILabel *)[dataCell viewWithTag:106] text] length] != 0 ? [_collectionView addSubview:bmiView] :[bmiView removeFromSuperview];
                
                // 移动ytblView的位置 && 改变比较结果
                CGRect  ytblFrame   =  ytblView.frame;
                ytblFrame.origin.x += dataCell.bounds.size.width;
                NSDictionary *YTBLDict = [self calculateResultWithText:[(UILabel *)[dataCell viewWithTag:107] text] type:@"YTBL"];
                [self changeYTBLViewWithFrame:ytblFrame title:YTBLDict[@"string"] compare:[YTBLDict[@"number"] intValue]];
                [[(UILabel *)[dataCell viewWithTag:107] text] length] != 0 ? [_collectionView addSubview:ytblView] :[ytblView removeFromSuperview];
                
                
                [_collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
                // 滑动小球显示
                CGRect ringFrame = ringImageView.frame;
                ringFrame.origin.x = Adaptive(64);
                ringImageView.frame = ringFrame;
                
                [self changeFontAndColorWithCell:dataCell  direction:@"left"];
            }];
        }
    }
}

#pragma mark --  封装方法修改cellLabel字体大小和颜色
- (void)changeFontAndColorWithCell:(DataCollectionViewCell *)cell direction:(NSString *)direct {
    
    UIColor *color;
    UIFont  *font;
    UIFont  *unitFont;
    
    //  NSLog(@"dataCell %@  label.text %@",cell,[(UILabel *)[cell viewWithTag:101] text]);
    if ([direct isEqualToString:@"left"]) {
        color    = ORANGECOLOR;
        font     = [UIFont fontWithName:FONT_BOLD size:Adaptive(24)];
        unitFont = [UIFont fontWithName:FONT_BOLD size:Adaptive(15)];
        
    } else {
        color    = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
        font     = [UIFont fontWithName:FONT size:Adaptive(12)];
        unitFont = [UIFont fontWithName:FONT size:Adaptive(12)];
    }
    
    for (int a = 101; a < 128; a++) {
        [self changeTextWithLabel:(UILabel *)[cell viewWithTag:a] Color:color font:font unitFont:unitFont];
    }
}

- (void)changeTextWithLabel:(UILabel *)label Color:(UIColor *)color font:(UIFont *)font unitFont:(UIFont *)unitFont
{
    [label setTextColor:color];
    [label setFont:font];
    
    NSCharacterSet *nonDigits    = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString       *remainSecond = [label.text stringByTrimmingCharactersInSet:nonDigits] ;
    
    if (label.text.length != 0) {
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:label.text];
        [str addAttribute:NSFontAttributeName value:unitFont range:NSMakeRange(remainSecond.length,label.text.length - remainSecond.length)];
        label.attributedText = str;
    }
    
    
    
    
}

#pragma mark -- 封装方法改变比较视图的位置

// 传入label.text 计算偏胖还是正常
- (NSDictionary *)calculateResultWithText:(NSString *)text type:(NSString *)type{
    
    NSCharacterSet *nonDigits    = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSString       *remainSecond = [text stringByTrimmingCharactersInSet:nonDigits];
    
    
    NSString *compareString;
    NSInteger compareNumber;
    if ([type isEqualToString:@"BMI"]) {
        
        if ([remainSecond floatValue] < 18.5) {
            compareString = @"偏瘦";
            compareNumber = 0;
        } else if ([remainSecond floatValue] > 22.9) {
            compareString = @"偏胖";
            compareNumber = 2;
        } else {
            compareString = @"标准";
            compareNumber = 1;
        }
        
    } else if ([type isEqualToString:@"FAT"]) {
        if ([remainSecond floatValue] < 12) {
            compareString = @"偏低";
            compareNumber = 0;
        } else if ([remainSecond floatValue] > 18) {
            compareString = @"偏高";
            compareNumber = 2;
        } else {
            compareString = @"标准";
            compareNumber = 1;
        }
    } else {
        if ([remainSecond floatValue] < 0.9) {
            compareString = @"标准";
            compareNumber = 1;
        } else {
            compareString = @"偏高";
            compareNumber = 2;
        }
    }
    return @{@"string":compareString,@"number":[NSNumber numberWithInteger:compareNumber]};
    
}

// 改变weightView的位置
// 体重
- (void)changeWeightViewWithFrame:(CGRect)frame title:(NSString *)title compare:(NSInteger)compare {
    
    NSString *imageName = compare != 2 ? @"data_green" : @"data_red";
    
    if (weightView == nil) {
        weightView = [[DataCompareView alloc] initWithFrame:frame];
        [_collectionView addSubview:weightView];
    } else {
        weightView.frame = frame;
    }
    weightView.baseImageView.image = [UIImage imageNamed:imageName];
    weightView.compareLabel.text   = title;
}
// 脂肪百分比
- (void)changeFatViewWithFrame:(CGRect)frame title:(NSString *)title compare:(NSInteger)compare {
    
    NSString *imageName = compare != 2 ? @"data_green" : @"data_red";
    
    if (fatView == nil) {
        fatView = [[DataCompareView alloc] initWithFrame:frame];
        
    } else {
        fatView.frame = frame;
    }
    fatView.baseImageView.image = [UIImage imageNamed:imageName];
    fatView.compareLabel.text   = title;
}
// BMI
- (void)changeBMIViewWithFrame:(CGRect)frame title:(NSString *)title compare:(NSInteger)compare {
    
    NSString *imageName = compare != 2 ? @"data_green" : @"data_red";
    
    if (bmiView == nil) {
        bmiView = [[DataCompareView alloc] initWithFrame:frame];
        
    } else {
        bmiView.frame = frame;
    }
    bmiView.baseImageView.image = [UIImage imageNamed:imageName];
    bmiView.compareLabel.text   = title;
}
// 腰臀比例
- (void)changeYTBLViewWithFrame:(CGRect)frame title:(NSString *)title compare:(NSInteger)compare {
    
    NSString *imageName = compare != 2 ? @"data_green" : @"data_red";
    
    if (ytblView == nil) {
        ytblView = [[DataCompareView alloc] initWithFrame:frame];
        
    } else {
        ytblView.frame = frame;
    }
    ytblView.baseImageView.image = [UIImage imageNamed:imageName];
    ytblView.compareLabel.text   = title;
}
#pragma mark -- UICollectionViewDataSource
//定义展示UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"dataArray.count %lu",(unsigned long)dataArray.count);
    return dataArray.count;
}
//定义展示section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionViewCell的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UICollectionViewCell";
    DataCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    MyDataModel *dataModel = dataArray[indexPath.row];
    cell.dataModel = dataModel;
    
    // 当行数等于0并且没有创建weightView的时候创建 以后移动位置
    if (indexPath.row == 0 && weightView == nil) {
        // 体重
        CGRect  weightFrame = CGRectMake(Adaptive(100),
                                         CGRectGetMinY([(UILabel *)[cell viewWithTag:102] frame]) + Adaptive(10) ,
                                         Adaptive(33.5),
                                         Adaptive(17.5));
        NSDictionary *BMIDict = [self calculateResultWithText:[(UILabel *)[cell viewWithTag:106] text] type:@"BMI"];
        [self changeWeightViewWithFrame:weightFrame title:BMIDict[@"string"] compare:[BMIDict[@"number"] intValue]];
        
        if ([[(UILabel *)[cell viewWithTag:102] text] length] != 0) {
            [_collectionView addSubview:weightView];
        }
        
        
    }
    // 脂肪百分比
    if (indexPath.row == 0 && fatView == nil ) {
        CGRect  fatFrame = CGRectMake(Adaptive(100),
                                      CGRectGetMinY([(UILabel *)[cell viewWithTag:105] frame]) + Adaptive(10) ,
                                      Adaptive(33.5),
                                      Adaptive(17.5));
        NSDictionary *fatDict = [self calculateResultWithText:[(UILabel *)[cell viewWithTag:105] text] type:@"FAT"];
        [self changeFatViewWithFrame:fatFrame title:fatDict[@"string"] compare:[fatDict[@"number"] intValue]];
        if ([[(UILabel *)[cell viewWithTag:105] text] length] != 0) {
            [_collectionView addSubview:fatView];
        }
    }
    // BMI
    if (indexPath.row == 0 && bmiView == nil ) {
        CGRect  BMIFrame = CGRectMake(Adaptive(100),
                                      CGRectGetMinY([(UILabel *)[cell viewWithTag:106] frame]) + Adaptive(10) ,
                                      Adaptive(33.5),
                                      Adaptive(17.5));
        
        NSDictionary *BMIDict = [self calculateResultWithText:[(UILabel *)[cell viewWithTag:106] text] type:@"BMI"];
        [self changeBMIViewWithFrame:BMIFrame title:BMIDict[@"string"] compare:[BMIDict[@"number"] intValue]];
        if ([[(UILabel *)[cell viewWithTag:106] text] length] != 0) {
            [_collectionView addSubview:bmiView];
        }
    }
    // 腰臀比例
    if (indexPath.row == 0 && ytblView == nil ) {
        CGRect  ytblFrame = CGRectMake(Adaptive(100),
                                      CGRectGetMinY([(UILabel *)[cell viewWithTag:107] frame]) + Adaptive(10) ,
                                      Adaptive(33.5),
                                      Adaptive(17.5));
        
        NSDictionary *YTBLDict = [self calculateResultWithText:[(UILabel *)[cell viewWithTag:107] text] type:@"YTBL"];
        [self changeYTBLViewWithFrame:ytblFrame title:YTBLDict[@"string"] compare:[YTBLDict[@"number"] intValue]];
        if ([[(UILabel *)[cell viewWithTag:107] text] length] != 0) {
            [_collectionView addSubview:ytblView];
        }
    }
    
    if (indexPath.row == _row) {
        
        [self changeFontAndColorWithCell:cell  direction:@"left"];
    }
    else {
        [self changeFontAndColorWithCell:cell  direction:@"right"];
    }
    
    return cell;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake(Adaptive(117),viewHeight * 2.1);  //设置cell宽高
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 只要偏移量有改变  就会调用
    CGPoint point = scrollView.contentOffset;
    
    
    CGFloat collectWidth = Adaptive(234) * 2;
    
    if (point.x >= collectWidth * _page) {
        
        NSString *url = [NSString stringWithFormat:@"%@api/?method=user.mybody&pages=%d",BASEURL,_page];
        _page++;
        [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
            
        } success:^(id responseObject) {
            
            NSArray *array = [responseObject objectForKey:@"data"];
            if (array.count > 0) {
                for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
                    MyDataModel *dataModel = [[MyDataModel alloc] initWithDictionary:dict];
                    
                    [dataArray addObject:dataModel];
                    
                    
                }
                [_collectionView reloadData];
            }
        }];
    }
}


@end
