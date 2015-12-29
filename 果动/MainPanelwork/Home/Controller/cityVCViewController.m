//
//  cityVCViewController.m
//  果动
//
//  Created by mac on 15/3/30.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "cityVCViewController.h"
#import "Commonality.h"
#import "HttpTool.h"
@interface cityVCViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *citys;
    int number;
}
@end

@implementation cityVCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BASECOLOR;
    
    
    self.navigationItem.titleView=[HeadComment titleLabeltext:@"当前城市"];
    BackView *backView = [[BackView alloc] initWithbacktitle:@"首页" viewController:self];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    
    //上面的线
    UIImageView * lineImage1=[UIImageView new];
    lineImage1.image=[UIImage imageNamed:@"home__line1"];
    lineImage1.frame=CGRectMake(0, 0, viewWidth, .5);
    [self.view addSubview:lineImage1];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight-(viewHeight/22.233)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = viewHeight/9.529;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    NSString *url = [NSString stringWithFormat:@"%@citys/",BASEURL];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            citys = [responseObject objectForKey:@"all_citys"];
            [_tableView reloadData];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError *error) {}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return citys.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return viewHeight/9.529;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight/9.529)];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/33.35, headView.bounds.size.height - .5, viewWidth - viewHeight/16.675, .5)];
    line.backgroundColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    [headView addSubview:line];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/22.233, viewHeight/17.553, viewHeight/4.447, viewHeight/37.056)];
    textLabel.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
    textLabel.textAlignment = 0;
    textLabel.textColor = [UIColor colorWithRed:255/255.0 green:125/255.0 blue:40/255.0 alpha:1];
    textLabel.text = self.city;
    [headView addSubview:textLabel];//102
    
    UILabel *currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - viewHeight/6.67, viewHeight/17.553, viewHeight/9.5286, viewHeight/44.467)];
    currentLabel.textAlignment = 1;
    currentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
    currentLabel.text = @"当前城市";
    currentLabel.font = [UIFont fontWithName:FONT size:viewHeight/44.467];
    [headView addSubview:currentLabel];
    return headView;
}
//设置单元格的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.backgroundColor = [UIColor clearColor];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
     UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/33.35, viewHeight/9.5286 - .5, viewWidth - viewHeight/16.675, .5)];
    line.backgroundColor = [UIColor colorWithRed:85/255.0 green:85/255.0 blue:85/255.0 alpha:1];
    [cell addSubview:line];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/22.233, viewHeight/17.553, viewHeight/4.447, viewHeight/44.467)];
    textLabel.font = [UIFont fontWithName:FONT size:viewHeight/44.467];
    textLabel.textAlignment = 0;
    textLabel.textColor = [UIColor colorWithRed:187/255.0 green:187/255.0 blue:187/255.0 alpha:1];
    textLabel.text = citys[indexPath.row];
    [cell addSubview:textLabel];
    
    return cell;
    
}
@end
