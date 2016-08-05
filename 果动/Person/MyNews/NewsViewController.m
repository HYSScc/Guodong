//
//  NewsViewController.m
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "PersonViewController.h"
#import "NewsViewController.h"
#import "NewsDetailsViewController.h"
#import "NewsModel.h"
#import "LoginViewController.h"
#import "News_GDBCell.h"
#import "News_MoneyCell.h"
#import "News_systemCell.h"
@interface NewsViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NewsViewController
{
    UITableView    *_tableView;
    NSMutableArray *dataArray;
    BOOL           isOpen[100];
    int last_len;
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
  
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"我的消息" viewController:self];
    [self.view addSubview:navigation];

     dataArray  = [NSMutableArray array];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight - NavigationBar_Height)
                                              style:UITableViewStylePlain];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.backgroundColor = BASECOLOR;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    
    if ([HttpTool judgeWhetherUserLogin]) {
        // 2.集成刷新控件
        [self setupRefresh];
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

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.message",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        [dataArray removeAllObjects];
        for (NSDictionary *dict in [data objectForKey:@"messge_list"]) {
            NewsModel *news = [[NewsModel alloc] initWithDictionary:dict];
            [dataArray addObject:news];
        }
        
        last_len = [[data objectForKey:@"last_len"] intValue];
        PersonViewController *personVC    = [PersonViewController sharedViewControllerManager];
        [personVC.tabBarController.tabBar hideBadgeOnItemIndex:2];
        personVC.haveNews = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"common"] objectForKey:@"has_message"]];
        [_tableView reloadData];
        // 结束刷新状态
        [_tableView headerEndRefreshing];
        
        
    }];
}

- (void)footerRereshing
{
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.message&last_len=%d",BASEURL,last_len];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *data = [responseObject objectForKey:@"data"];

        if ([[data objectForKey:@"messge_list"] count] != 0) {
            for (NSDictionary *dict in [data objectForKey:@"messge_list"]) {
                NewsModel *news = [[NewsModel alloc] initWithDictionary:dict];
                [dataArray addObject:news];
            }
            PersonViewController *personVC    = [PersonViewController sharedViewControllerManager];
            [personVC.tabBarController.tabBar hideBadgeOnItemIndex:2];
            personVC.haveNews = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"common"] objectForKey:@"has_message"]];
            last_len = [[data objectForKey:@"last_len"] intValue];
            [_tableView reloadData];
        } else {
            _tableView.footerRefreshingText = @"没有新的数据了...";
        }
        // 结束刷新状态
        [_tableView footerEndRefreshing];
       
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsModel *newsModel = dataArray[indexPath.row];
    
    if ([newsModel.classString isEqualToString:@"gd_money"] ) {
        static NSString *Moneycellidentifier = @"Moneycell";
        
        
        
        News_MoneyCell *cell = [tableView dequeueReusableCellWithIdentifier:Moneycellidentifier];
        if (cell == nil)
        {
            cell = [[News_MoneyCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:Moneycellidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text   = newsModel.title;
        cell.contentLabel.text = newsModel.content;
        
        return cell;
    } else if ([newsModel.classString isEqualToString:@"gdb"]) {
        
        
        
        static NSString *gdbcellidentifier = @"GDBcell";
        
        News_GDBCell *cell = [tableView dequeueReusableCellWithIdentifier:gdbcellidentifier];
        if (cell == nil)
        {
            cell = [[News_GDBCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:gdbcellidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.titleLabel.text   = newsModel.title;
        cell.contentLabel.text = newsModel.talkinfo;
        NSLog(@"图片URL %@",newsModel.talkphotoString);
        [cell.photoImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.talkphotoString]];
        
        return cell;
        
    } else {
        NSLog(@"2");
        static NSString *Systemcellidentifier = @"Systemcell";
        
        News_systemCell *cell = [tableView dequeueReusableCellWithIdentifier:Systemcellidentifier];
        if (cell == nil)
        {
            cell = [[News_systemCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:Systemcellidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        CGRect CellFrame = [cell frame];
        // 根据BOOL数组值判断高度
        if (isOpen[indexPath.row]) {
            // 展开
            
            CGSize textSize = [newsModel.content boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(14)]} context:nil].size;
            
            if (textSize.height > Adaptive(44)) {
                cell.contentLabel.frame = CGRectMake(Adaptive(13),
                                                     Adaptive(47) + Adaptive(9),
                                                     viewWidth - Adaptive(26),
                                                     textSize.height);
            } else {
                cell.contentLabel.frame = CGRectMake(Adaptive(13),
                                                     Adaptive(47) + Adaptive(9),
                                                     viewWidth - Adaptive(26),
                                                     Adaptive(44));
            }
        } else {
            cell.contentLabel.frame = CGRectMake(Adaptive(13),
                                                 Adaptive(47) + Adaptive(9),
                                                 viewWidth - Adaptive(26),
                                                 Adaptive(30));
        }
        
      
        
        cell.sepatateLabel.frame = CGRectMake(0,
                                              CGRectGetMaxY(cell.contentLabel.frame) + Adaptive(9),
                                              viewWidth,
                                              Adaptive(10));
        CellFrame.size.height  = CGRectGetMaxY(cell.sepatateLabel.frame);
        
       
        
        cell.frame             = CellFrame;
        cell.titleLabel.text   = newsModel.title;
        cell.contentLabel.text = newsModel.content;
        
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    NewsModel *newsModel = dataArray[indexPath.row];
    
    if ([newsModel.classString isEqualToString:@"gdb"] ) {
        
        NewsDetailsViewController *detailsView = [NewsDetailsViewController new];
        
        // 跳转的时候隐藏tabbar
        self.hidesBottomBarWhenPushed = YES;
        detailsView.talk_id = newsModel.idString;
        [self.navigationController pushViewController:detailsView animated:YES];
        
    } else {
        isOpen[indexPath.row] = !isOpen[indexPath.row];
        [tableView reloadData];
    }
    
    
    
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSLog(@"1");
    
    NewsModel *newsModel = dataArray[indexPath.row];
    
    if ([newsModel.classString isEqualToString:@"sys"] ) {
        
        // 根据BOOL数组值判断高度
        if (isOpen[indexPath.row]) {
            // 展开
            News_systemCell *cell = (News_systemCell *)[self tableView:_tableView
                                                 cellForRowAtIndexPath:indexPath];
            
            
            return cell.frame.size.height;
            
        } else {
            return Adaptive(100);
        }
    } else {
        
        return Adaptive(100);
        
    }
    
}
@end
