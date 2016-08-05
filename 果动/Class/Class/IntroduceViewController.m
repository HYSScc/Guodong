//
//  IntroduceViewController.m
//  果动
//
//  Created by mac on 16/6/2.
//  Copyright © 2016年 Unique. All rights reserved.
//
#include "LoginViewController.h"
#import "addMessageModel.h"
#import "IntroduceViewController.h"
#import "InroduceModel.h"
#import "textFrameView.h"
#import "IntroduceCommentCell.h"
#import "AddMessageViewController.h"
#import "AllCommentTableViewController.h"
@interface IntroduceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView  *_scrollView;
    UIImageView   *topBackgroundImageView;
    UIImageView   *topIconImageView;
    InroduceModel *introduce;
    UITableView   *_tableView;
    CGFloat       tableHeight;
    CGFloat       introduceImageOriginY;
}
@end

@implementation IntroduceViewController

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
    
   
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:_className viewController:self];
    [self.view addSubview:navigation];
    
    _scrollView       = [UIScrollView new];
    _scrollView.frame = CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight - NavigationBar_Height - Adaptive(50));
    [self.view addSubview:_scrollView];
    
    
    [self startRequest];
}

- (void)startRequest {
    NSString *url;
    if ([_classOrShip isEqualToString:@"class"]) {
        url = [NSString stringWithFormat:@"%@api/?method=gdcourse.introduce&class_id=%@",BASEURL,_class_id];
    } else {
        url = [NSString stringWithFormat:@"%@api/?method=gdcourse.gdstore_inc&id=%@",BASEURL,_class_id];
    }
    
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        introduce          = [[InroduceModel alloc] initWithDictionary:data];
        [self createUI];
        if ([_classOrShip isEqualToString:@"class"]) {
            [self createClassSureView];
        } else {
            [self createShopSureView];
        }
        
    }];
    
}
- (void)createShopSureView {
    
    UIButton *shopButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shopButton.frame     = CGRectMake(0,
                                      viewHeight - Adaptive(50),
                                      viewWidth,
                                      Adaptive(50));
    
    [shopButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shopButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if (_cityAllowed == YES) {
        [shopButton setTitle:@"预 约" forState:UIControlStateNormal];
        [shopButton setTitleColor:BASECOLOR forState:UIControlStateNormal];
        shopButton.titleLabel.font = [UIFont fontWithName: FONT_BOLD size:Adaptive(15)];
        shopButton.backgroundColor = ORANGECOLOR;
        shopButton.userInteractionEnabled = YES;
        
    } else {
        [shopButton setTitle:@"当前所在城市暂未覆盖" forState:UIControlStateNormal];
        shopButton.backgroundColor = BASEGRYCOLOR;
        shopButton.userInteractionEnabled = NO;
    }
    
    [self.view addSubview:shopButton];
    
    
}

- (void)createClassSureView {
    UIView *sureView = [UIView new];
    sureView.frame   = CGRectMake(0,
                                  viewHeight  - Adaptive(55),
                                  viewWidth,
                                  Adaptive(55));
    sureView.backgroundColor = BASECOLOR;
    [self.view addSubview:sureView];
    
    
    if (_cityAllowed == YES) {
        
        UILabel *muchLabel = [UILabel new];
        muchLabel.frame    = CGRectMake(0,
                                        (sureView.bounds.size.height - Adaptive(20)) / 2,
                                        viewWidth / 2,
                                        Adaptive(20));
        muchLabel.textAlignment = 1;
        muchLabel.textColor     = ORANGECOLOR;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 元/课时",introduce.price]];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:18] range:NSMakeRange(0,introduce.price.length)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:14] range:NSMakeRange(introduce.price.length,5)];
        muchLabel.attributedText = str;
        [sureView addSubview:muchLabel];
        
        
        UIButton *sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        sureButton.frame     = CGRectMake(viewWidth - Adaptive((13 + 115)),
                                          (sureView.bounds.size.height - Adaptive(34)) / 2,
                                          Adaptive(115),
                                          Adaptive(34));
        [sureButton setBackgroundColor:ORANGECOLOR];
        [sureButton setTitleColor:BASECOLOR forState:UIControlStateNormal];
        [sureButton setTitle:@"预 约" forState:UIControlStateNormal];
        sureButton.titleLabel.font = [UIFont fontWithName: FONT_BOLD size:Adaptive(15)];
        [sureButton addTarget:self action:@selector(sureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [sureView addSubview:sureButton];
        
        
    } else {
        
        UILabel *notAllowedLabel = [UILabel new];
        notAllowedLabel.frame    = CGRectMake(0, 0, sureView.bounds.size.width, sureView.bounds.size.height);
        notAllowedLabel.backgroundColor = BASEGRYCOLOR;
        notAllowedLabel.font = [UIFont fontWithName:FONT size:Adaptive(14)];
        notAllowedLabel.textColor = [UIColor whiteColor];
        notAllowedLabel.textAlignment = 1;
        notAllowedLabel.text = @"当前所在城市暂未覆盖";
        [sureView addSubview:notAllowedLabel];
    }
}

- (void)createUI {
    
    NSDictionary *topImageDict = introduce.imageArray[0];
    
    topBackgroundImageView       = [UIImageView new];
    topBackgroundImageView.frame = CGRectMake(0,
                                              0,
                                              viewWidth,
                                              [[topImageDict objectForKey:@"height"] intValue] / 2);
    topBackgroundImageView.backgroundColor = BASEGRYCOLOR;
    [topBackgroundImageView sd_setImageWithURL:[NSURL URLWithString:[topImageDict objectForKey:@"imgurl"]]];
    [_scrollView addSubview:topBackgroundImageView];
    
    topIconImageView = [UIImageView new];
    topIconImageView.frame  = CGRectMake((topBackgroundImageView.bounds.size.width  - (introduce.iconWidth / 2)) / 2,
                                         (topBackgroundImageView.bounds.size.height - (introduce.iconHeight / 2)) / 3,
                                         introduce.iconWidth / 2,
                                         introduce.iconHeight / 2);
    [topIconImageView sd_setImageWithURL:[NSURL URLWithString:introduce.iconImageURL]];
    [_scrollView addSubview:topIconImageView];
    
    UILabel *classIntroLabel = [UILabel new];
    classIntroLabel.frame    = CGRectMake(0,
                                          CGRectGetMaxY(topIconImageView.frame) + Adaptive(15),
                                          viewWidth,
                                          Adaptive(20));
    classIntroLabel.textColor     = ORANGECOLOR;
    classIntroLabel.textAlignment = 1;
    if ([_classOrShip isEqualToString:@"class"]) {
        classIntroLabel.text = @"课程介绍";
    } else {
        classIntroLabel.text = @"店铺介绍";
    }
    classIntroLabel.font      = [UIFont fontWithName:FONT size:Adaptive(18)];
    [_scrollView addSubview:classIntroLabel];
    
    
    introduceImageOriginY = CGRectGetMaxY(topBackgroundImageView.frame);
    CGFloat imageMaxY = 0;
    
    for (int a = 0; a < [introduce.imageArray count] - 1; a++) {
        NSDictionary *imageMessageDict = [introduce.imageArray objectAtIndex:a+1];
        CGFloat  getHeight = [[imageMessageDict objectForKey:@"height"] floatValue] / 2;
        CGFloat  getWidth  = [[imageMessageDict objectForKey:@"width"] floatValue] / 2;
        UIImageView *imageView = [UIImageView new];
        imageView.frame        = CGRectMake(0,
                                            introduceImageOriginY + Adaptive(10) + imageMaxY,
                                            viewWidth,
                                            (viewWidth * getHeight) / getWidth);
        imageView.tag = a + 1;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[imageMessageDict objectForKey:@"imgurl"]]];
        [_scrollView addSubview:imageView];
        imageMaxY = ((viewWidth * getHeight) / getWidth) + imageMaxY + Adaptive(10);
    }
    UIImageView *lastImageView = (UIImageView *)[_scrollView viewWithTag:introduce.imageArray.count - 1];
    
    
    textFrameView *moreIntroduceView =[[textFrameView alloc] initWithFrame:CGRectMake(Adaptive(5),
                                                                                      CGRectGetMaxY(lastImageView.frame) + Adaptive(10),
                                                                                      viewWidth - Adaptive(10),
                                                                                      Adaptive(100))];
    [_scrollView addSubview:moreIntroduceView];
    
    NSArray *moreIntroduceArray = @[@"约课时间:",@"健身所需器材，由教练提供",@"健身所需的空间，一张瑜伽垫大小即可"];
    for (int a = 0; a < 3; a++) {
        UILabel *label = [UILabel new];
        label.frame    = CGRectMake(Adaptive(5),
                                    Adaptive(13) + Adaptive(25)*a,
                                    moreIntroduceView.textSmallBlackView.bounds.size.width - Adaptive(10),
                                    Adaptive(15));
        label.text = moreIntroduceArray[a];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:FONT size:Adaptive(14)];
        [moreIntroduceView.textSmallBlackView addSubview:label];
    }
    
    UILabel *course_timeLabel = [UILabel new];
    course_timeLabel.frame    = CGRectMake(Adaptive(80), Adaptive(13), Adaptive(150), Adaptive(15));
    course_timeLabel.textColor = [UIColor whiteColor];
    course_timeLabel.text  = introduce.course_time;
    course_timeLabel.font  = [UIFont fontWithName:FONT size:Adaptive(14)];
    [moreIntroduceView.textSmallBlackView addSubview:course_timeLabel];
    
    
    
    if ([_classOrShip isEqualToString:@"class"]) {
        
        UIView *tableHeadView = [UIView new];
        tableHeadView.frame   = CGRectMake(0, 0, viewWidth, Adaptive(44));
        tableHeadView.backgroundColor = BASEGRYCOLOR;
        
        /*** 表头 ***/
        UILabel *commentNumberLabel = [UILabel new];
        commentNumberLabel.frame    = CGRectMake(Adaptive(13),
                                                 (tableHeadView.bounds.size.height - Adaptive(20)) / 2,
                                                 viewWidth,
                                                 Adaptive(20));
        commentNumberLabel.textColor = [UIColor whiteColor];
        commentNumberLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        commentNumberLabel.text      = [NSString stringWithFormat:@"%@评价",introduce.coments_num];
        [tableHeadView addSubview:commentNumberLabel];
        
        UILabel *line = [UILabel new];
        line.frame    = CGRectMake(0, Adaptive(34), viewWidth, Adaptive(10));
        line.backgroundColor = BASECOLOR;
        [tableHeadView addSubview:line];
        /*** 表头 ***/
        
        /*** 表尾 ***/
        UIView *footView = [UIView new];
        footView.frame   = CGRectMake(0, 0, viewWidth, Adaptive(35));
        footView.backgroundColor = BASEGRYCOLOR;
        
        UIButton *footButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        footButton.frame     = CGRectMake(0, 0, footView.bounds.size.width, footView.bounds.size.height);
        footButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
        [footButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [footButton setTitle:@"查看所有评价" forState:UIControlStateNormal];
        [footButton addTarget:self action:@selector(footButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:footButton];
        
        UILabel *footLine = [UILabel new];
        footLine.frame    = CGRectMake((viewWidth - Adaptive(100)) / 2,
                                       Adaptive(30), Adaptive(100), .5);
        footLine.backgroundColor = BASECOLOR;
        [footView addSubview:footLine];
        /*** 表尾 ***/
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(moreIntroduceView.frame) +Adaptive(10),
                                                                   viewWidth,
                                                                   0)
                                                  style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.bounces    = NO;
        _tableView.tableHeaderView = tableHeadView;
        _tableView.tableFooterView = footView;
        _tableView.separatorStyle  = UITableViewCellSelectionStyleNone;
        _tableView.backgroundColor = BASECOLOR;
        [_scrollView addSubview:_tableView];
        
        
        if ([introduce.coments_num isEqualToString:@"0"]) {
            _scrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(_tableView.frame));
        } else {
            _scrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(_tableView.frame) + footView.bounds.size.height);
        }
    } else {
        
        _scrollView.contentSize = CGSizeMake(viewWidth, CGRectGetMaxY(moreIntroduceView.frame) + Adaptive(5));
    }
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGRect tableFrame      = _tableView.frame;
    tableFrame.size.height  = tableHeight / 4 + Adaptive(44)  ;
    _tableView.frame        = tableFrame;
    return introduce.commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    IntroduceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[IntroduceCommentCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    IntroduceComment *comment = introduce.commentArray[indexPath.row];
    cell.comment = comment;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntroduceCommentCell *cell = (IntroduceCommentCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    tableHeight = tableHeight + cell.frame.size.height;
    return cell.frame.size.height;
}

- (void)sureButtonClick:(UIButton *)button {
    
    if ([HttpTool judgeWhetherUserLogin]) {
        self.hidesBottomBarWhenPushed          = YES;
        AddMessageViewController *addMessageVC = [AddMessageViewController new];
        addMessageVC.class_id    = _class_id;
        addMessageVC.className   = _className;
        addMessageVC.classOrShip = _classOrShip;
        [self.navigationController pushViewController:addMessageVC animated:YES];

    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
    
}

- (void)footButtonClick:(UIButton *)button {
    self.hidesBottomBarWhenPushed          = YES;
    AllCommentTableViewController *allComment = [AllCommentTableViewController new];
    
    allComment.class_id = _class_id;
    
    [self.navigationController pushViewController:allComment animated:YES];
}
@end
