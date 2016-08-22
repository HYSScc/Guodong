//
//  PictureViewController.m
//  果动
//
//  Created by mac on 16/7/19.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "PictureViewController.h"
#import "PictureTableViewCell.h"
#import "PictureModel.h"
#import "FinderViewController.h"
@interface PictureViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PictureViewController
{
    UITableView    *_tableView;
    NSMutableArray *pictureArray;
    int page;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 2.集成刷新控件
   // [self headerRereshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    page = 1;
    pictureArray = [NSMutableArray array];
    [self createUI];
    // 2.集成刷新控件
    [self setupRefresh];
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
    NSString *url = [NSString stringWithFormat:@"%@api/?method=find.list",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        [pictureArray removeAllObjects];
        page = 1;
        if ([[responseObject objectForKey:@"data"] count] != 0) {
            for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
                PictureModel *picture = [[PictureModel alloc] initWithDictionary:dict];
                [pictureArray addObject:picture];
            }
            [_tableView reloadData];
        }
        // 结束刷新状态
        [_tableView headerEndRefreshing];
        
    }];
}

- (void)footerRereshing
{
    NSString *url = [NSString stringWithFormat:@"%@api/?method=find.list&page=%d",BASEURL,page];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"data"] count] != 0) {
            for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
                PictureModel *picture = [[PictureModel alloc] initWithDictionary:dict];
                [pictureArray addObject:picture];
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
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, LastHeight ) style:UITableViewStylePlain];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.rowHeight       = Adaptive(249);
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = BASECOLOR;
    
    [self.view addSubview:_tableView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return pictureArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    PictureTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[PictureTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PictureModel *picture  = pictureArray[indexPath.row];
    
    cell.titleLabel.text   = picture.title;
    cell.contentLabel.text = picture.content;
    
    if (![picture.imageString isKindOfClass:[NSNull class]]) {
        [cell.titleImageView sd_setImageWithURL:[NSURL URLWithString:picture.imageString]];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PictureModel *picture  = pictureArray[indexPath.row];
    
    FinderViewController *finder = [FinderViewController sharedViewControllerManager];
    
    
    [finder pushWebViewWithName:picture.content_id title:picture.title];
    
}

@end
