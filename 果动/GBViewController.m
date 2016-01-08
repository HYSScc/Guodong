//
//  GBViewController.m
//  果动
//
//  Created by mac on 15/9/7.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "AppDelegate.h"
#import "AsynImageView.h"
#import "Commonality.h"
#import "GBViewController.h"
#import "GDComment.h"
#import "LoginViewController.h"
#import "MCFireworksButton.h"
#import "MJRefresh.h"
#import "NewsViewController.h"
#import "ReportActionSheet.h"
#import "ReportActionSheet.h"
#import "SJAvatarBrowser.h"
#import "publish_ViewController.h"
@interface GBViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate, UIAlertViewDelegate, UIActionSheetDelegate> {
    UITableView* _tableView;
    UIImageView* imageView;
    UIImageView* image2;
    NSString* url;
    NSMutableArray* allstatus;
    GBTableViewCell* picturecell;
    GBTextFieldCell* textcell;
    GBMovieCell* moviecell;
    ReportActionSheet* reportActionSheet;
    NSString* report_typeid;
    BOOL isopen[100];
    NSString *refreshSection;
    CGFloat openSection;
    UIImageView* headImageView;
    UILabel* noMoneyLabelTop;
    UILabel* noMoneyLabel;
    UIButton* shareButton;
    UIView* headView;
    NSString* removeCellNumber;
    CGRect rootpoint;
    NSString* liuyanType;
    NSString* rid;
    NSString* comment_id;
    int page;
    BOOL haveRelayCell;
    NSString* keyName;
    CGFloat cellOriginY;
    UIView* secondTFView;
    UITextField* secondTF;
    UIButton* secondButton;
    UIButton* messageButton;
}
@end

@implementation GBViewController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setupRefresh];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    page = 1;
    //默认为回复说说的type
    liuyanType = @"3";
    self.replay_id = @"0";
    //默认使用textCell的输入框
    keyName = @"First";
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - NavigationBar_Height) style:UITableViewStylePlain];
    if ([self.isNews isEqual:@"news"]) {
        BackView* backView = [[BackView alloc] initWithbacktitle:@"消息" viewController:self];
        UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
        self.navigationItem.leftBarButtonItem = backItem;
        self.navigationItem.titleView = [HeadComment titleLabeltext:@"详情"];
    }
    else {
        if ([self.isMy intValue] == 999) {
            BackView* backView = [[BackView alloc] initWithbacktitle:@"返回" viewController:self];
            UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
            self.navigationItem.leftBarButtonItem = backItem;
        }
        else {
            //左边消息列表
            messageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            messageButton.frame = CGRectMake(13, Adaptive(27), Adaptive(18), Adaptive(21));
            [messageButton addTarget:self action:@selector(messageButton) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:messageButton];
            self.navigationItem.leftBarButtonItem = leftButtonItem;
            
            _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - NavigationBar_Height - Tabbar_Height) style:UITableViewStylePlain];
        }
        
        self.navigationItem.titleView = [self.isMy intValue] == 999 ? [HeadComment titleLabeltext:@"我的发布"] : [HeadComment titleLabeltext:@"果吧"];
        UIImageView* lineImage1 = [UIImageView new];
        lineImage1.image = [UIImage imageNamed:@"home__line1"];
        lineImage1.frame = CGRectMake(0, 0, viewWidth, 0.5);
        [self.view addSubview:lineImage1];
        
        //右边发送按钮
        UIButton* amentButton = [UIButton buttonWithType:UIButtonTypeSystem];
        amentButton.frame = CGRectMake(Adaptive(330), Adaptive(27), Adaptive(24.5), Adaptive(17.5));
        [amentButton setBackgroundImage:[UIImage imageNamed:@"GD_fabu"] forState:UIControlStateNormal];
        [amentButton addTarget:self action:@selector(goTosenderView:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem* releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:amentButton];
        self.navigationItem.rightBarButtonItem = releaseButtonItem;
    }
    
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    //  给_tableView添加一个手势监测；
    //点击手势
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleFrom)]; //
    singleRecognizer.numberOfTapsRequired = 1;
    [_tableView addGestureRecognizer:singleRecognizer];
    
    image2 = [[UIImageView alloc] init];
    image2.frame = CGRectMake((viewWidth - Adaptive(94)) / 2, Adaptive(142.5), Adaptive(94), Adaptive(68.5));
    image2.image = [UIImage imageNamed:@"fabu_nobody"];
    
    noMoneyLabelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetMaxY(image2.frame) + Adaptive(20)), viewWidth, Adaptive(20))];
    noMoneyLabelTop.textColor = [UIColor whiteColor];
    noMoneyLabelTop.text = @"这里太空了...";
    noMoneyLabelTop.textAlignment = 1;
    noMoneyLabelTop.font = [UIFont fontWithName:FONT size:Adaptive(20)];
    
    noMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noMoneyLabelTop.frame) + Adaptive(10), viewWidth, Adaptive(15))];
    noMoneyLabel.textColor = [UIColor colorWithRed:94 / 255.0 green:94 / 255.0 blue:94 / 255.0 alpha:1];
    noMoneyLabel.text = @"快点来发表个心情呗~";
    noMoneyLabel.textAlignment = 1;
    noMoneyLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame = CGRectMake((viewWidth - Adaptive(99)) / 2, CGRectGetMaxY(noMoneyLabel.frame) + Adaptive(25), Adaptive(99), Adaptive(30));
    [shareButton setBackgroundImage:[UIImage imageNamed:@"fabu_fabu"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];
    
    allstatus = [[NSMutableArray alloc] initWithCapacity:0];
    //动态获取键盘高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //当textCell未创建时点击单元格弹出自定义输入框
    secondTFView = [[UIView alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, Adaptive(44))];
    secondTFView.userInteractionEnabled = YES;
    secondTFView.backgroundColor = [UIColor colorWithRed:113 / 255.0 green:113 / 255.0 blue:113 / 255.0 alpha:1];
    
    secondTF = [[UITextField alloc] initWithFrame:CGRectMake(Adaptive(15), (secondTFView.bounds.size.height - Adaptive(30)) / 2, viewWidth - Adaptive(70), Adaptive(30))];
    secondTF.borderStyle = UITextBorderStyleNone;
    secondTF.layer.cornerRadius = 3;
    secondTF.layer.masksToBounds = YES;
    secondTF.backgroundColor = [UIColor colorWithRed:131 / 255.0 green:131 / 255.0 blue:131 / 255.0 alpha:1];
    secondTF.delegate = self;
    secondTF.textColor = [UIColor whiteColor];
    secondTF.font = [UIFont fontWithName:FONT size:Adaptive(14)];
    [secondTFView addSubview:secondTF];
    //当texCell未创建的时候点击单元格弹出自定义输入框
    secondButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    secondButton.frame = CGRectMake(CGRectGetMaxX(secondTF.frame) + Adaptive(5), (secondTFView.bounds.size.height - Adaptive(25)) / 2, Adaptive(50), Adaptive(25));
    [secondButton addTarget:self action:@selector(liuyan:) forControlEvents:UIControlEventTouchUpInside];
    [secondButton setTitle:@"留言" forState:UIControlStateNormal];
    [secondButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [secondTFView addSubview:secondButton];
    
   
}
- (void)messageButton
{
    NewsViewController* new = [ NewsViewController new ];
    [self.navigationController pushViewController:new animated:YES];
}
- (void)shareButton
{
    [self.navigationController pushViewController:[publish_ViewController new] animated:YES];
}
- (void)setupRefresh
{
    //下拉刷新
    
    if (![self.isNews isEqualToString:@"news"]) {
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    }
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = HEADERPULLTOREFRESH;
    _tableView.headerReleaseToRefreshText = HEADERRELEASETOREFRESH;
    _tableView.headerRefreshingText = HEADERREFRESHING;
    _tableView.footerPullToRefreshText = FOOTERPULLTOREFRESH;
    _tableView.footerReleaseToRefreshText = FOOTERRELEASETOREFRESH;
    _tableView.footerRefreshingText = FOOTERREFRESHING;
}
- (void)headerRereshing
{
    if ([self.isNews isEqual:@"news"]) {
        url = [NSString stringWithFormat:@"%@api/?method=gdb.talk&talkid=%@", BASEURL, self.news_talkid];
    }
    else {
        if ([self.isMy intValue] == 999) {
            url = [NSString stringWithFormat:@"%@api/?method=gdb.personal_center", BASEURL];
        }
        else {
            url = [NSString stringWithFormat:@"%@api/?method=gdb.index", BASEURL];
        }
    }
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            
            if ([self.isNews isEqualToString:@"news"]) {
                [allstatus removeAllObjects];
                GDComment* gdc = [GDComment statusWithDictionary:[responseObject objectForKey:@"data"]];
                [allstatus addObject:gdc];
            } else {
                NSArray* array = responseObject[@"data"][@"data_list"];
                if (array.count == 0) {
                    [allstatus removeAllObjects];
                    [_tableView addSubview:image2];
                    [_tableView addSubview:noMoneyLabelTop];
                    [_tableView addSubview:noMoneyLabel];
                    [_tableView addSubview:shareButton];
                } else {
                    [image2 removeFromSuperview];
                    [noMoneyLabelTop removeFromSuperview];
                    [noMoneyLabel removeFromSuperview];
                    [shareButton removeFromSuperview];
                    [allstatus removeAllObjects];
                    
                    NSString* newsNumber = [[[responseObject objectForKey:@"data"] objectForKey:@"sys"] objectForKey:@"dynamic"];
                    if ([newsNumber intValue] != 0) {
                        [messageButton setBackgroundImage:[UIImage imageNamed:@"news_have"] forState:UIControlStateNormal];
                    } else {
                        [messageButton setBackgroundImage:[UIImage imageNamed:@"news_nohave"] forState:UIControlStateNormal];
                    }
                    for (NSDictionary* dict in array) {
                        GDComment* gdc = [GDComment statusWithDictionary:dict];
                        [allstatus addObject:gdc];
                    }
                }
            }
            
            if (refreshSection) {
                // 创建一个索引集合把你需要重新加载的   区号   放到   集合   中
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:[refreshSection integerValue]];
                // 重新加载某个区   (刷新区)
                [_tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            } else {
                 [_tableView reloadData];
            }
            refreshSection = nil;
            [_tableView headerEndRefreshing];
        } else if (ResponseObject_RC == NotLogin_RC_Number) {
            [HeadComment message:@"您还没有登录呢！" delegate:self witchCancelButtonTitle:@"暂不" otherButtonTitles:@"去登录", nil];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }fail:^(NSError* error){}];
}

- (void)footerRereshing
{
    page++;
    if ([self.isMy intValue] == 999) {
        url = [NSString stringWithFormat:@"%@api/?method=gdb.personal_center&page=%d", BASEURL, page];
    }
    else {
        url = [NSString stringWithFormat:@"%@api/?method=gdb.index&page=%d", BASEURL, page];
    }
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            NSArray* array = responseObject[@"data"][@"data_list"];
            if (array.count == 0) {
                _tableView.footerRefreshingText = @"已经是最后一条了";
            }
            else {
                [image2 removeFromSuperview];
                [noMoneyLabelTop removeFromSuperview];
                [noMoneyLabel removeFromSuperview];
                [shareButton removeFromSuperview];
                
                for (NSDictionary* dict in array) {
                    GDComment* gdc = [GDComment statusWithDictionary:dict];
                    [allstatus addObject:gdc];
                }
                
               

                [_tableView reloadData];
            }
            
            [_tableView footerEndRefreshing];
        }
        else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }
                     fail:^(NSError* error){
                     }];
}
//自定义区头
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    
    GDComment* gdcomment = [allstatus objectAtIndex:section];
    
    headView = [[UIView alloc] init];
    headView.alpha = 0.8;
    headView.frame = CGRectMake(0, 0, viewWidth, Adaptive(60));
    headView.backgroundColor = [UIColor blackColor];
    
    headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, (headView.bounds.size.height - Adaptive(35)) / 2, Adaptive(35), Adaptive(35))];
    headImageView.userInteractionEnabled = YES;
    headImageView.layer.masksToBounds = YES;
    headImageView.tag = section * 100;
    headImageView.layer.cornerRadius = headImageView.bounds.size.width / 2;
    [headImageView setImageWithURL:[NSURL URLWithString:gdcomment.headimg] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    [headView addSubview:headImageView];
    
    //添加点击手势
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyHead:)];
    [headImageView addGestureRecognizer:tap];
    
    UILabel* headLabel = [[UILabel alloc] init];
    headLabel.text = gdcomment.nickname;
    CGSize userNameSize = [headLabel.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(18)] }];
    headLabel.frame = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(5), (headView.bounds.size.height - userNameSize.height) / 2, userNameSize.width, userNameSize.height);
    headLabel.textAlignment = 1;
    headLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
    headLabel.textColor = [UIColor orangeColor];
    [headView addSubview:headLabel];
    
    UILabel* dateLabel = [[UILabel alloc] init];
    dateLabel.text = gdcomment.hour;
    dateLabel.frame = CGRectMake(viewWidth - Adaptive(110) - Adaptive(13), (headView.bounds.size.height - Adaptive(17)) / 2, Adaptive(110), Adaptive(17));
    dateLabel.textAlignment = 2;
    dateLabel.font = [UIFont fontWithName:FONT size:Adaptive(11)];
    dateLabel.textColor = [UIColor lightGrayColor];
    [headView addSubview:dateLabel];
    
    return headView;
}
//区头高度
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return Adaptive(60);
}
- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return allstatus.count;
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    GDComment* gdc = [allstatus objectAtIndex:section];
    if (isopen[section]) {
        return 3 + gdc.comments_list.count + gdc.replay_listArray.count;
    } else {
        return 1;
    }
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GDComment* gdc = [allstatus objectAtIndex:indexPath.section];
    
    secondButton.tag = [gdc.talkid intValue];
    if (indexPath.row == 0) {
        //第一行的cell处理
        if ([gdc.type intValue] == 2) {
            //图片
            __weak GBTableViewCell* picture = picturecell;
            __weak GBViewController* gbView = self;
            picturecell = [tableView dequeueReusableCellWithIdentifier:@"pictureCell"];
            
            if (!picturecell) {
                picturecell = [[GBTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pictureCell"];
            }
            
            _talkid = gdc.talkid;
        
            [picturecell.photoImageView setImageWithURL:gdc.photos[0] placeholderImage:[UIImage imageNamed:@"base_logo"] success:^(UIImage* image, BOOL cached) {
                //添加点击手势
                UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:gbView action:@selector(magnifyHead:)];
                [picture.photoImageView addGestureRecognizer:tap];
            } failure:^(NSError* error){}];
            
            picturecell.photocommentLabel.text = gdc.content;
            CGSize textSize = [gdc.content boundingRectWithSize:CGSizeMake(viewWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(15)] } context:nil].size;
            picturecell.photocommentLabel.frame = CGRectMake(Adaptive(15), (Adaptive(50)- textSize.height) / 2, textSize.width, textSize.height);
            picturecell.cnumberLabel.text = gdc.comments;
            CGSize cnumberSize = [picturecell.cnumberLabel.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(18)] }];
            picturecell.cnumberLabel.frame = CGRectMake(CGRectGetMaxX(picturecell.pImage.frame) + Adaptive(3), CGRectGetMinY(picturecell.pImage.frame), cnumberSize.width, cnumberSize.height);
            
            if ([gdc.ipraises intValue] == 1) {
                [picturecell.likeButton setBackgroundImage:[UIImage imageNamed:@"GD_yizan"] forState:UIControlStateNormal];
            } else {
                [picturecell.likeButton setBackgroundImage:[UIImage imageNamed:@"GD_zan"] forState:UIControlStateNormal];
            }
            picturecell.likeButton.tag = [gdc.talkid intValue];
            [picturecell.likeButton addTarget:self action:@selector(zan:) forControlEvents:UIControlEventTouchUpInside];
            picturecell.likeButton.frame = CGRectMake(CGRectGetMaxX(picturecell.cnumberLabel.frame) + Adaptive(10), CGRectGetMinY(picturecell.pImage.frame), Adaptive(24.5), Adaptive(20));
            
            picturecell.znumberLabel.text = gdc.praises;
            CGSize znumberSize = [picturecell.znumberLabel.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(18)] }];
            picturecell.znumberLabel.frame = CGRectMake(CGRectGetMaxX(picturecell.likeButton.frame) + Adaptive(3), CGRectGetMinY(picturecell.likeButton.frame), znumberSize.width, znumberSize.height);
            
            if ([self.isMy intValue] == 999) {
                picturecell.removeButton.frame = CGRectMake(CGRectGetMaxX(picturecell.znumberLabel.frame) + Adaptive(15), CGRectGetMinY(picturecell.pImage.frame), Adaptive(16.5), Adaptive(18.75));
                picturecell.removeButton.tag = [gdc.talkid intValue] * 2;
                [picturecell.removeButton addTarget:self action:@selector(removeCell:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            picturecell.openButton.tag = [gdc.talkid intValue] * 10;
            [picturecell.openButton addTarget:self action:@selector(opencontent:) forControlEvents:UIControlEventTouchUpInside];
            return picturecell;
        } else {
            //视频
            moviecell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
            if (!moviecell) {
                moviecell = [[GBMovieCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"movieCell"];
                moviecell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            if (gdc.video.count > 1) {
                NSLog(@"gdc.video[1] %@", gdc.video[1]);
                [moviecell.SLTImageView setImageWithURL:[NSURL URLWithString:gdc.video[1]]];
                
                moviecell.videoURL = gdc.video[0];
            }
            moviecell.photocommentLabel.text = gdc.content;
            CGSize textSize = [gdc.content boundingRectWithSize:CGSizeMake(viewWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(15)] } context:nil].size;
            moviecell.photocommentLabel.frame = CGRectMake(Adaptive(15), (Adaptive(50) - textSize.height) / 2, textSize.width, textSize.height);
            moviecell.cnumberLabel.text = gdc.comments;
            CGSize cnumberSize = [moviecell.cnumberLabel.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(18)] }];
            moviecell.cnumberLabel.frame = CGRectMake(CGRectGetMaxX(moviecell.pImage.frame) + Adaptive(3), CGRectGetMinY(moviecell.pImage.frame), cnumberSize.width, cnumberSize.height);
            
            if ([gdc.ipraises intValue] == 1) {
                [moviecell.likeButton setBackgroundImage:[UIImage imageNamed:@"GD_yizan"] forState:UIControlStateNormal];
            }
            else {
                [moviecell.likeButton setBackgroundImage:[UIImage imageNamed:@"GD_zan"] forState:UIControlStateNormal];
            }
            moviecell.likeButton.tag = [gdc.talkid intValue];
            [moviecell.likeButton addTarget:self action:@selector(zan:) forControlEvents:UIControlEventTouchUpInside];
            moviecell.likeButton.frame = CGRectMake(CGRectGetMaxX(moviecell.cnumberLabel.frame) + Adaptive(10), CGRectGetMinY(moviecell.pImage.frame), Adaptive(25), Adaptive(20));
            
            moviecell.znumberLabel.text = gdc.praises;
            CGSize znumberSize = [moviecell.znumberLabel.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(18)] }];
            moviecell.znumberLabel.frame = CGRectMake(CGRectGetMaxX(moviecell.likeButton.frame) + Adaptive(3), CGRectGetMinY(moviecell.likeButton.frame), znumberSize.width, znumberSize.height);
            
            if ([self.isMy intValue] == 999) {
                moviecell.removeButton.frame = CGRectMake(CGRectGetMaxX(moviecell.znumberLabel.frame) + Adaptive(15), CGRectGetMinY(moviecell.pImage.frame), Adaptive(16.5), Adaptive(18.75));
                moviecell.removeButton.tag = [gdc.talkid intValue] * 2;
                [moviecell.removeButton addTarget:self action:@selector(removeCell:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            [moviecell.openButton addTarget:self action:@selector(opencontent:) forControlEvents:UIControlEventTouchUpInside];
            [moviecell.playButton addTarget:self action:@selector(playButton:) forControlEvents:UIControlEventTouchUpInside];
            return moviecell;
        }
    }
    else if (indexPath.row == 1) {
        //赞的cell
        GBZanCell* cell = [tableView dequeueReusableCellWithIdentifier:@"zanCell"];
        if (!cell) {
            cell = [[GBZanCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"zanCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (int a = 0; a < 6; a++) {
            UIImageView* imageview111 = (UIImageView*)[cell viewWithTag:a + 100];
            imageview111.hidden = YES;
        }
        
        for (int a = 0; a < gdc.praise_listArray.count; a++) {
            
            UIImageView* imagevire = (UIImageView*)[cell viewWithTag:a + 100];
            imagevire.hidden = NO;
            [imagevire setImageWithURL:[NSURL URLWithString:gdc.praise_listArray[a]] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
            
        }
        
        [cell.reportButton addTarget:self action:@selector(reportButton:) forControlEvents:UIControlEventTouchUpInside];
        cell.reportButton.tag = indexPath.section;
        return cell;
    }
    else if (indexPath.row - 2 < gdc.comments_list.count + gdc.replay_listArray.count) {
        //评论的cell
        GBPinLunCell* cell = [tableView dequeueReusableCellWithIdentifier:@"pinlunCell"];
        if (!cell) {
            cell = [[GBPinLunCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"pinlunCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //评论的头像
            cell.info_headimg = [[AsynImageView alloc] initWithFrame:CGRectMake(Adaptive(30), Adaptive(5), Adaptive(35), Adaptive(35))];
            
            cell.info_headimg.layer.cornerRadius = cell.info_headimg.bounds.size.width / 2;
            cell.info_headimg.layer.masksToBounds = YES;
            [cell addSubview:cell.info_headimg];
            
            //评论的昵称
            cell.info_headlab = [[UILabel alloc] init];
            
            cell.info_headlab.textColor = [UIColor orangeColor];
            cell.info_headlab.font = [UIFont fontWithName:FONT size:Adaptive(11.6)];
            [cell addSubview:cell.info_headlab];
            
            //评论的时间
            cell.info_timelab = [[UILabel alloc] initWithFrame:CGRectMake(self.view.bounds.size.width - Adaptive(35) - Adaptive(70), CGRectGetMinY(cell.info_headimg.frame), Adaptive(70), Adaptive(14))];
            
            cell.info_timelab.textAlignment = 2;
            cell.info_timelab.textColor = [UIColor lightGrayColor];
            cell.info_timelab.font = [UIFont fontWithName:FONT size:Adaptive(10)];
            [cell addSubview:cell.info_timelab];
            
            //评论的内容
            cell.info_contentlab = [[UILabel alloc] init];
            cell.info_contentlab.numberOfLines = 0;
            
            cell.info_contentlab.textColor = [UIColor whiteColor];
            cell.info_contentlab.font = [UIFont fontWithName:FONT size:Adaptive(13)];
            [cell addSubview:cell.info_contentlab];
            
            //线
            cell.info_line = [[UILabel alloc] init];
            cell.info_line.backgroundColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1];
            [cell addSubview:cell.info_line];
        }
        CGRect frame = [cell frame];
        cell.cell_type = @"1";
        //评论
        cell.info_id = gdc.info_idArray[indexPath.row - 2];
        
        [cell.info_headimg setImageWithURL:[NSURL URLWithString:gdc.heaimgArray[indexPath.row - 2]] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
        
        cell.info_headlab.text = gdc.nicknameArray[indexPath.row - 2];
        CGSize info_headsize = [cell.info_headlab.text sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(14)] }];
        cell.info_headlab.frame = CGRectMake(CGRectGetMaxX(cell.info_headimg.frame) + Adaptive(5), CGRectGetMinY(cell.info_headimg.frame), info_headsize.width, info_headsize.height);
        
        cell.info_timelab.text = gdc.timeArray[indexPath.row - 2];
        
        if ([gdc.infoArray[indexPath.row - 2] isKindOfClass:[NSDictionary class]]) {
            cell.cell_type = @"2";
            NSDictionary* contentDict = gdc.infoArray[indexPath.row - 2];
            NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复%@：%@", [contentDict objectForKey:@"target_name"], [contentDict objectForKey:@"content"]]];
            NSString* nameStr = [contentDict objectForKey:@"target_name"];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(2, nameStr.length)];
            
            cell.info_contentlab.attributedText = str;
            
            cell.replay_id = [contentDict objectForKey:@"replay_id"];
        } else {
            cell.info_contentlab.text = gdc.infoArray[indexPath.row - 2];
        }
        
        CGSize info_content = [cell.info_contentlab.text boundingRectWithSize:CGSizeMake(viewWidth - Adaptive(50) - Adaptive(35), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(14)] } context:nil].size;
        cell.info_contentlab.frame = CGRectMake(CGRectGetMaxX(cell.info_headimg.frame) + Adaptive(5), CGRectGetMaxY(cell.info_headlab.frame) + Adaptive(5), info_content.width, info_content.height);
        
        if (CGRectGetMaxY(cell.info_contentlab.frame) > CGRectGetMaxY(cell.info_headimg.frame)) {
            cell.info_line.frame = CGRectMake(CGRectGetMinX(cell.info_headimg.frame), CGRectGetMaxY(cell.info_contentlab.frame) + Adaptive(5), viewWidth - CGRectGetMinX(cell.info_headimg.frame) * 2, 1);
        } else {
            cell.info_line.frame = CGRectMake(CGRectGetMinX(cell.info_headimg.frame), CGRectGetMaxY(cell.info_headimg.frame) + Adaptive(5), viewWidth - CGRectGetMinX(cell.info_headimg.frame) * 2, 0.5);
        }
        //回复评论
        //点击cell回复评论
        UITapGestureRecognizer* replyCommentTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(replyComment:)];
        [cell addGestureRecognizer:replyCommentTap];
        
        frame.size.height = CGRectGetMaxY(cell.info_line.frame);
        cell.frame = frame;
        return cell;
    } else {
        //textField的cell
        textcell = [tableView dequeueReusableCellWithIdentifier:@"textfieldCell"];
        if (!textcell) {
            textcell = [[GBTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"textfieldCell"];
            textcell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        textcell.textfield.delegate = self;
        textcell.sendButton.tag = [gdc.talkid intValue];
        [textcell.sendButton addTarget:self action:@selector(liuyan:) forControlEvents:UIControlEventTouchUpInside];
        return textcell;
    }
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    GDComment* gdc = [allstatus objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {
        return viewWidth;
    } else if (indexPath.row == 1) {
        return Adaptive(44);
    } else if (indexPath.row - 2 < gdc.comments_list.count + gdc.replay_listArray.count) {
        GBPinLunCell* cell = (GBPinLunCell*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    } else {
        return Adaptive(44);
    }
}
- (void)reportButton:(UIButton*)button
{
    NSString* reportUrl = [NSString stringWithFormat:@"%@api/?method=gdb.report_content", BASEURL];
    [HttpTool postWithUrl:reportUrl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        
        if (ResponseObject_RC == 0) {
            GDComment* gdc = [allstatus objectAtIndex:button.tag];
            NSDictionary* data = [responseObject objectForKey:@"data"];
            self.reportArray = [NSMutableArray array];
            self.report_idArray = [NSMutableArray array];
            reportActionSheet = [[ReportActionSheet alloc] initWithTitle:@"我们将在24小时内验证并处理您的反馈,请严肃选择举报类型" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil];
            for (NSString* key in [data allKeys]) {
                [reportActionSheet addButtonWithTitle:[data objectForKey:key]];
                [self.reportArray addObject:[data objectForKey:key]];
                [self.report_idArray addObject:key];
            }
            reportActionSheet.name = gdc.nickname;
            reportActionSheet.date = gdc.hour;
            reportActionSheet.content = gdc.content;
            reportActionSheet.talkid = gdc.talkid;
            [reportActionSheet showInView:self.view];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError* error){}];
}
- (void)actionSheet:(ReportActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) return;
    report_typeid = [self.report_idArray objectAtIndex:buttonIndex - 1];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.message = [NSString stringWithFormat:@"您将举报 %@ 在 %@ 发布的 %@ 为 %@，请确认", actionSheet.name, actionSheet.date, actionSheet.content, [self.reportArray objectAtIndex:buttonIndex - 1]];
    alert.tag = 980;
    [alert show];
}
- (void)playButton:(UIButton*)button
{
    __block NSString* str = moviecell.videoURL;
    MPMoviePlayerViewController* movieVc = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:str]];
    //弹出播放器
    [self presentMoviePlayerViewControllerAnimated:movieVc];
}
- (void)zan:(MCFireworksButton*)button
{
    
    NSString* zanurl = [NSString stringWithFormat:@"%@api/?method=gdb.praise&talkid=%ld", BASEURL, (long)button.tag];
    [HttpTool postWithUrl:zanurl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"rc"] integerValue] == 11) {
            [button popInsideWithDuration:0.4];
            [button setBackgroundImage:[UIImage imageNamed:@"GD_zan"] forState:UIControlStateNormal];
        } else if ([[responseObject objectForKey:@"rc"] integerValue] == 10) {
            [button popOutsideWithDuration:0.5];
            [button setBackgroundImage:[UIImage imageNamed:@"GD_yizan"] forState:UIControlStateNormal];
            [button animate];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        }
        [self headerRereshing];
    } fail:^(NSError* error){}];
}
- (void)opencontent:(UIButton*)button
{
    NSIndexPath* index = [_tableView indexPathForCell:(UITableViewCell*)button.superview.superview.superview];
   
    isopen[index.section] = !isopen[index.section];
    GBTableViewCell* cell = (GBTableViewCell*)[_tableView cellForRowAtIndexPath:index];
   
    if (isopen[index.section]) {
        [cell.openImg setImage:[UIImage imageNamed:@"GD_shang"]];
    } else {
        [cell.openImg setImage:[UIImage imageNamed:@"GD_xia"]];
    }
    [_tableView reloadData];
}
//表随键盘高度变化
- (void)keyboardShow:(NSNotification*)note
{
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    
    /*
     haveRelayCell == NO  直接评论说说 应该弹起输入框
     */
    
    if (haveRelayCell == NO) {
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            //根据绝对高度算出view的偏移量
            CGFloat keyMinHeight = viewHeight - deltaY - textcell.bounds.size.height;
            if (rootpoint.origin.y > keyMinHeight) {
                self.view.transform = CGAffineTransformMakeTranslation(0, keyMinHeight - rootpoint.origin.y);
            }
        }];
    } else {
        if ([keyName isEqual:@"First"]) {
            
            [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
                //根据绝对高度算出view的偏移量
                CGFloat keyMinHeight = viewHeight - deltaY - textcell.bounds.size.height;
                if (rootpoint.origin.y > keyMinHeight) {
                    self.view.transform = CGAffineTransformMakeTranslation(0, keyMinHeight - rootpoint.origin.y);
                }
            }];
        } else {
            
            CGRect frame = secondTFView.frame;
            frame.origin.y = viewHeight - deltaY - Adaptive(44) - NavigationBar_Height;
            frame.origin.x = 0;
            secondTFView.frame = frame;
            
            if (frame.origin.y < cellOriginY) {
                _tableView.transform = CGAffineTransformMakeTranslation(0, frame.origin.y - cellOriginY - Adaptive(44));
                NSLog(@"结果 %f", frame.origin.y - cellOriginY - Adaptive(44));
            }
        }
    }
}
- (void)keyboardHide:(NSNotification*)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        _tableView.transform = CGAffineTransformIdentity;
        cellOriginY = 0;
        haveRelayCell = NO;
        textcell.textfield.placeholder = @"";
        secondTF.placeholder = @"";
        CGRect frame = secondTFView.frame;
        frame.origin.y = viewHeight;
        secondTFView.frame = frame;
    }];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField*)textField
{
    //输入框在屏幕的绝对高度只应获取一次
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    rootpoint = [[textcell.textfield superview] convertRect:textcell.textfield.bounds toView:app.window];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField*)textField
{
    textField.text = @"";
    haveRelayCell = NO;
    liuyanType = @"3";
    CGRect frame = secondTFView.frame;
    frame.origin.y = viewHeight;
    secondTFView.frame = frame;
    return YES;
}
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    textcell.textfield.placeholder = @"";
    secondTF.placeholder = @"";
    [textcell.textfield resignFirstResponder];
    [secondTFView resignFirstResponder];
    [secondTFView removeFromSuperview];
}
- (void)handleFrom
{
    textcell.textfield.placeholder = @"";
    [self.view endEditing:YES];
}
//发表界面
- (void)goTosenderView:(UIBarButtonItem*)sender
{
    [self.navigationController pushViewController:[publish_ViewController new] animated:YES];
}
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    //是否删除说说的提示框
    if (alertView.tag == 99) {
        if (buttonIndex == 1) {
            NSString* removeURL = [NSString stringWithFormat:@"%@api/?method=gdb.deletetalk&talkid=%@", BASEURL, removeCellNumber];
            [HttpTool postWithUrl:removeURL params:nil contentType:CONTENTTYPE success:^(id responseObject) {
                
                [self headerRereshing];
            } fail:^(NSError* error){}];
        }
    } else if (alertView.tag == 980) {
        if (buttonIndex == 1) {
            NSString* reporturl = [NSString stringWithFormat:@"%@api/?method=gdb.report&typeid=%@&talkid=%@", BASEURL, report_typeid, reportActionSheet.talkid];
            [HttpTool postWithUrl:reporturl params:nil contentType:CONTENTTYPE success:^(id responseObject) {} fail:^(NSError* error){}];
        }
    } else {
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        }
    }
}
//放大头像
- (void)magnifyHead:(UIGestureRecognizer*)gesture
{
    [SJAvatarBrowser showImage:(UIImageView*)gesture.view];
}
//删除说说
- (void)removeCell:(UIButton*)button
{
    removeCellNumber = [NSString stringWithFormat:@"%ld", button.tag / 2];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:nil message:@"确认删除此条说说？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alert.tag = 99;
    [alert show];
}
//点击cell回复评论
- (void)replyComment:(UIGestureRecognizer*)gesture
{
    //通过点击评论、回复响应的输入框
    haveRelayCell = YES;
    GBPinLunCell* cell = (GBPinLunCell*)gesture.view;
    
    if ([cell.cell_type isEqualToString:@"2"]) { //回复cell
        liuyanType = @"2";
        self.replay_id = cell.replay_id;
    } else {
        //评论cell
        liuyanType = @"1";
    }
    self.info_id = cell.info_id;
    //获取cell在self.view中得绝对位置
    CGRect rect = [cell convertRect:cell.bounds toView:self.view];
    cellOriginY = rect.origin.y;
    textcell.textfield.placeholder = [NSString stringWithFormat:@"回复%@：", cell.info_headlab.text];
    secondTF.placeholder = [NSString stringWithFormat:@"回复%@：", cell.info_headlab.text];
    
    //判断textcell是否在屏幕内
    CGRect textCellRect = [textcell convertRect:textcell.bounds toView:self.view];
    
    //textCell全部显示在屏幕内再使用textcell的输入框，否则使用第二输入框,避免弹出不了textcell的输入框
    CGFloat textCell_Height = textCellRect.origin.y + textcell.bounds.size.height;
    
    CGFloat tableView_MaxHeight = viewHeight - NavigationBar_Height - Tabbar_Height;
    if (!textcell || (textCell_Height > tableView_MaxHeight || textCell_Height < 0)) {
        
        keyName = @"Second";
        [self.view addSubview:secondTFView];
        [secondTF becomeFirstResponder];
    } else {
        keyName = @"First";
        [textcell.textfield becomeFirstResponder];
    }
}
- (void)liuyan:(UIButton*)button
{
    if ([liuyanType isEqual:@"3"]) {
        NSString* sendurl = [NSString stringWithFormat:@"%@api/?method=gdb.comments&", BASEURL];
        [HttpTool GET:sendurl parameters:@{ @"talkid" : [NSString stringWithFormat:@"%ld", (long)button.tag],
                                            @"info" : textcell.textfield.text }
              success:^(AFHTTPRequestOperation* operation, id responseObject) {
                        [self headerRereshing];
    } failure:^(AFHTTPRequestOperation* operation, NSError* error){}];
    } else if ([liuyanType isEqual:@"1"]) {
        //回复评论
        NSString* urlStr = [NSString stringWithFormat:@"%@api/?method=gdb.replay", BASEURL];
        NSString* contendString = textcell.textfield.text;
        if ([keyName isEqual:@"Second"]) {
            contendString = secondTF.text;
            [secondTF resignFirstResponder];
        }
        NSDictionary* dict = @{ @"rid" : self.replay_id,
                                @"types" : @"1",
                                @"comment_id" : self.info_id,
                                @"content" : contendString };
        
        [HttpTool postWithUrl:urlStr params:dict contentType:CONTENTTYPE success:^(id responseObject) {
            
            [self headerRereshing];
            
        }fail:^(NSError* error){}];
    } else {
        //回复别人的回复
        NSLog(@"22222");
        NSString* urlStr = [NSString stringWithFormat:@"%@api/?method=gdb.replay", BASEURL];
        NSString* contendString = textcell.textfield.text;
        if ([keyName isEqual:@"Second"]) {
            contendString = secondTF.text;
            [secondTF resignFirstResponder];
        }
        NSDictionary* dict = @{ @"rid" : self.replay_id,
                                @"comment_id" : self.info_id,
                                @"types" : @"2",
                                @"content" : contendString };
        [HttpTool postWithUrl:urlStr params:dict contentType:CONTENTTYPE success:^(id responseObject) {
            
            [self headerRereshing];
            
        }fail:^(NSError* error){}];
    }
}
@end
