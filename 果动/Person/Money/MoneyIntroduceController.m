//
//  MoneyIntroduceController.m
//  果动
//
//  Created by mac on 16/7/18.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "MoneyIntroduceCell.h"
#import "MoneyIntroduceController.h"
#import "MoneyIntroduceModel.h"
@interface MoneyIntroduceController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *dataArray;
}
@end

@implementation MoneyIntroduceController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden           = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 隐藏navigationBar
    self.view.backgroundColor = BASEGRYCOLOR;
   
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"优惠券说明" viewController:self];
    [self.view addSubview:navigation];

    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               NavigationBar_Height,
                                                               viewWidth,
                                                               viewHeight - NavigationBar_Height)
                                              style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BASEGRYCOLOR;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    [self startRequest];
}

- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdmoney.rules",BASEURL];
   
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        
        dataArray = [NSMutableArray array];
        
        for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"info"]) {
            MoneyIntroduceModel *introduce = [[MoneyIntroduceModel alloc] initWithDictionary:dict];
            [dataArray addObject:introduce];
        }
        [_tableView reloadData];
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count %lu",(unsigned long)dataArray.count);
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    MoneyIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[MoneyIntroduceCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MoneyIntroduceModel *introduce = dataArray[indexPath.row];
    cell.introduce = introduce;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoneyIntroduceCell *introduceCell = (MoneyIntroduceCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return introduceCell.frame.size.height;
}

@end
