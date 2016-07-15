//
//  My_NewsView.m
//  果动
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "FinderPubViewController.h"
#import "NewsDetailsViewController.h"
#import "My_NewsView.h"
#import "My_NewsTableViewCell.h"
#import "MyNewsModel.h"
@interface My_NewsView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation My_NewsView
{
    UITableView    *_tableView;
    NSString       *user_id;
    NSMutableArray *dataArray;
    UIViewController *viewController;
    int page;
    UIView  *noDataView;
}
- (instancetype)initWithFrame:(CGRect)frame user_id:(NSString *)user viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASECOLOR;
        user_id        = user;
        page           = 1;
        dataArray      = [NSMutableArray array];
        viewController = controller;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"myNews" object:nil];
        [self createUI];
        // 2.集成刷新控件
        [self setupRefresh];
    }
    return self;
}

- (void)tongzhi:(NSNotification *)notification {
    [self headerRereshing];
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
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.personal_center&user_id=%@&page=0",BASEURL,user_id];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        [dataArray removeAllObjects];
        
        if ([[[responseObject objectForKey:@"data"] objectForKey:@"data_list"] count] != 0) {
            [noDataView removeFromSuperview];
            for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"data_list"]) {
                MyNewsModel *newsModel = [[MyNewsModel alloc] initWithDictionary:dict];
                [dataArray addObject:newsModel];
            }
        }
        
        [_tableView reloadData];
        // 结束刷新状态
        [_tableView headerEndRefreshing];
    }];
    
}
- (void)footerRereshing
{
     NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.personal_center&user_id=%@&page=%d",BASEURL,user_id,page];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        if ([[[responseObject objectForKey:@"data"] objectForKey:@"data_list"] count] != 0) {
            for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"data_list"]) {
                MyNewsModel *newsModel = [[MyNewsModel alloc] initWithDictionary:dict];
                [dataArray addObject:newsModel];
            }
            [_tableView reloadData];
            page++;
        } else {
            _tableView.footerRefreshingText = @"没有新的数据了...";
        }
        // 结束刷新状态
        [_tableView footerEndRefreshing];
    }];
}

- (void)createUI {
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               viewWidth,
                                                               self.bounds.size.height)
                                              style:UITableViewStylePlain];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BASECOLOR;
    [self addSubview:_tableView];
    
    
    noDataView       = [UIView new];
    noDataView.frame = CGRectMake(0, 0, viewWidth, self.bounds.size.height);
    [_tableView addSubview:noDataView];
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.frame        = CGRectMake((viewWidth - Adaptive(44)) / 2,
                                            Adaptive(90),
                                            Adaptive(44),
                                            Adaptive(32));
    iconImageView.image = [UIImage imageNamed:@"myPublish_nodata"];
    [noDataView addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame    = CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + Adaptive(15),
                                     viewWidth,
                                     Adaptive(15));
    titleLabel.text      = @"这里太空了...";
    titleLabel.textColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
    titleLabel.textAlignment = 1;
    titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
    [noDataView addSubview:titleLabel];
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    publishButton.frame     = CGRectMake((viewWidth - Adaptive(80)) / 2, CGRectGetMaxY(titleLabel.frame) + Adaptive(10), Adaptive(80), Adaptive(15));
    publishButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
    [publishButton setTitle:@"发布一条心情" forState:UIControlStateNormal];
    [publishButton setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [noDataView addSubview:publishButton];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"发布一条心情"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [publishButton setAttributedTitle:str forState:UIControlStateNormal];
    
    
}

- (void)publishButtonClick:(UIButton *)button {
     viewController.hidesBottomBarWhenPushed          = YES;
    FinderPubViewController *publish = [FinderPubViewController new];
    publish.className = @"动态";
    [viewController.navigationController pushViewController:publish animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    My_NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[My_NewsTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MyNewsModel *newsModel = dataArray[indexPath.row];
    cell.newsModel = newsModel;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyNewsModel *newsModel = dataArray[indexPath.row];
    NewsDetailsViewController *detailsView = [NewsDetailsViewController new];
    
    // 跳转的时候隐藏tabbar
    viewController.hidesBottomBarWhenPushed          = YES;
    detailsView.talk_id = newsModel.talk_id;
    [viewController.navigationController pushViewController:detailsView animated:YES];
    // 跳转之后显示tabbar back回来时tabbar正常显示
    viewController.hidesBottomBarWhenPushed          = NO;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    My_NewsTableViewCell *cell = (My_NewsTableViewCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

@end
