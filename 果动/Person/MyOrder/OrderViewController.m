//
//  OrderViewController.m
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "OrderCommentViewController.h"
#import "OrderViewController.h"
#import "AddMessageViewController.h"
#import "OrderTitleCell.h"
#import "OrderUserCell.h"
#import "OrderCoachCell.h"
#import "OrderRemarkCell.h"
#import "LoginViewController.h"
#import "PackageIntroduceCell.h"

#import "OrderDataModel.h"

@interface OrderViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@end

@implementation OrderViewController
{
    UIView         *moveView;
    UITableView    *_tableView;
    NSMutableArray *orderArray;
    int             page;
    int             refushType;
    UIView         *noDataView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"我的订单" viewController:self];
    [self.view addSubview:navigation];
    
    
   
    
    page = 1;
    refushType = 0;
    orderArray = [NSMutableArray array];
   
   [self createUI];
    
    
    if ([HttpTool judgeWhetherUserLogin]) {
        
        // 2.集成刷新控件
        [self setupRefresh];
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        alert.tag = 999;
        [alert show];
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
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdcourse.order&status=%d",BASEURL,refushType];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        [orderArray removeAllObjects];
         NSDictionary *data = [responseObject objectForKey:@"data"];
        if ([[data objectForKey:@"order_info"] count] != 0)
        {
            [noDataView removeFromSuperview];
            for (NSDictionary *dict in [data objectForKey:@"order_info"]) {
                OrderDataModel *dataModel = [[OrderDataModel alloc] initWithDictionary:dict];
                [orderArray addObject:dataModel];
            }
           
        }
         [_tableView reloadData];
        // 结束刷新状态
        [_tableView headerEndRefreshing];
    }];
}

- (void)footerRereshing
{
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdcourse.order&status=%d&page=%d",BASEURL,refushType,page];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        if ([[data objectForKey:@"order_info"] count] != 0) {
            for (NSDictionary *dict in [data objectForKey:@"order_info"]) {
                OrderDataModel *dataModel = [[OrderDataModel alloc] initWithDictionary:dict];
                [orderArray addObject:dataModel];
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
    
    
    if ([HttpTool judgeWhetherUserLogin]) {
        NSArray *titleArray = @[@"全部",@"待付款",@"进行中",@"已完成"];
        
        for (int a = 0; a < titleArray.count; a++) {
            UIButton  *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame      = CGRectMake(viewWidth / titleArray.count * a,
                                           Adaptive(13) + NavigationBar_Height,
                                           viewWidth / [titleArray count],
                                           Adaptive(20));
            button.tag        = a + 1;
            [button addTarget:self action:@selector(changeTypeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitle:titleArray[a] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
            
            if (a == 0) {
                [button setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
            }
            
            [self.view addSubview:button];
        }
        
        moveView       = [UIView new];
        moveView.frame = CGRectMake((viewWidth / [titleArray count] - Adaptive(25)) / 2,
                                    Adaptive(35) + NavigationBar_Height,
                                    Adaptive(25),
                                    Adaptive(2));
        moveView.backgroundColor = ORANGECOLOR;
        [self.view addSubview:moveView];
        

    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, Adaptive(35) + NavigationBar_Height + Adaptive(2), viewWidth, viewHeight - CGRectGetMaxY(moveView.frame )+ Adaptive(5)) style:UITableViewStyleGrouped];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.backgroundColor = BASECOLOR;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    noDataView = [UIView new];
    noDataView.frame = CGRectMake(0, 0, viewWidth, viewHeight - NavigationBar_Height);
    [_tableView addSubview:noDataView];
    
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.frame        = CGRectMake((viewWidth - Adaptive(25)) / 2,
                                            Adaptive(90),
                                            Adaptive(25),
                                            Adaptive(36));
    iconImageView.image = [UIImage imageNamed:@"order_nodata"];
    [noDataView addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame    = CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + Adaptive(15),
                                     viewWidth,
                                     Adaptive(15));
    titleLabel.text      = @"没有相关订单";
    titleLabel.textColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
    titleLabel.textAlignment = 1;
    titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
    [noDataView addSubview:titleLabel];
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Adaptive(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return .1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return orderArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 根据课程完成状态来确定行数
    OrderDataModel *dataModel = orderArray[section];
    
    if ([dataModel.classOrPachage isEqualToString:@"gdcourse"]) {
        // 课程类型
        if ([dataModel.course_status intValue] == 6) {
            // 待付款
            return 3;
        } else if ([dataModel.course_status intValue] == 2) {
            // 进行中 -> 教练已接单
            return 3;
        } else if ([dataModel.course_status intValue] == 1) {
            // 等待教练接单
            return 3;
        } else {
            // 其他的类型
            return 4;
        }
    } else {
        // 套餐支付副券
        return 1;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     待付款：已预约并下单且未付款的订单  对应状态为“待付款”（无教练栏），底部选项为
     “删除订单” “去付款”点击去付款时直接到下单页，原来下单按钮的文字
     “下单”变为“确认” 不管最终付款与否，都只保留此订单最新版本。
     
     进行中：对应状态为“等待教练确认”（无教练头像）或“教练已确认”（有教练头像），
     无底部选项栏
     
     已完成：对应状态为“已完成”，底部状态栏为“删除订单”，按钮靠右
     对应状态为“待评价”，底部状态栏为“删除订单”和“去评价”
     
     注：设计稿中订单导航的“待评价”改为“已完成”
     */
    
    OrderDataModel *dataModel = orderArray[indexPath.section];
    
    if ([dataModel.classOrPachage isEqualToString:@"gdcourse"]) {
        // 课程类型
        if (indexPath.row == 0) {
            static NSString *cellidentifier = @"titleCell";
            
            OrderTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
            if (cell == nil)
            {
                cell = [[OrderTitleCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.dataModel = dataModel;
            return cell;
        } else if (indexPath.row == 1) {
            
            static NSString *cellidentifier = @"userCell";
            
            OrderUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
            if (cell == nil)
            {
                cell = [[OrderUserCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.dataModel = dataModel;
            return cell;
        } else if (indexPath.row == 2) {
            
            // 待付款  无教练栏  加载删除栏
            if ([dataModel.course_status intValue] == 6) {
                
                static NSString *cellidentifier = @"remarkCell";
                
                OrderRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
                if (cell == nil)
                {
                    cell = [[OrderRemarkCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.dataModel = dataModel;
                [cell.removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [cell.payButton addTarget:self action:@selector(goPayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                
                return cell;
            } else {
                
                // 进行中 无删除栏  加载教练栏
                
                static NSString *cellidentifier = @"coachCell";
                
                OrderCoachCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
                if (cell == nil)
                {
                    cell = [[OrderCoachCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                
                cell.dataModel = dataModel;
                return cell;
            }
        } else {
            
            // 第三行  如果有 必为删除栏  加载删除栏
            static NSString *cellidentifier = @"remarkCell";
            
            OrderRemarkCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
            if (cell == nil)
            {
                cell = [[OrderRemarkCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.dataModel = dataModel;
            [cell.removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.commentButton addTarget:self action:@selector(goCommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
            
        }
    } else {
        // 套餐支付副券
        
        static NSString *cellidentifier = @"packageCell";
        
        PackageIntroduceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (cell == nil)
        {
            cell = [[PackageIntroduceCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dataModel            = dataModel;
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDataModel *dataModel = orderArray[indexPath.section];
    
    if ([dataModel.classOrPachage isEqualToString:@"gdcourse"]) {
        // 课程类型
        
        if (indexPath.row == 0) {
            
            OrderTitleCell *cell = (OrderTitleCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
            
        } else if (indexPath.row == 1) {
            
            OrderUserCell *cell = (OrderUserCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
            
        } else if (indexPath.row == 2) {
            
            // 待付款  无教练栏  加载删除栏
            if ([dataModel.course_status intValue] == 6) {
                
                OrderRemarkCell *cell = (OrderRemarkCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
                return cell.frame.size.height;
                
            } else {
                // 进行中 无删除栏  加载教练栏
                OrderCoachCell *cell = (OrderCoachCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
                return cell.frame.size.height;
            }
        } else {
            // 第三行  如果有 必为删除栏  加载删除栏
            OrderRemarkCell *cell = (OrderRemarkCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
    } else {
        PackageIntroduceCell *cell = (PackageIntroduceCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}

- (void)changeTypeButtonClick:(UIButton *)button {
    
    UIButton *button1 = (UIButton *)[self.view viewWithTag:1];
    UIButton *button2 = (UIButton *)[self.view viewWithTag:2];
    UIButton *button3 = (UIButton *)[self.view viewWithTag:3];
    UIButton *button4 = (UIButton *)[self.view viewWithTag:4];
    
    switch (button.tag) {
        case 1:
        {
            // 全部数据
            [button1 setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            refushType = 0;
            
        }
            
            break;
        case 2:
        {
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button2 setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
            [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            // 待付款
            refushType = 6;
        }
            
            break;
        case 3:
        {
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button3 setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
            [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            // 进行中
            refushType = 2;
        }
    
            break;
        case 4:
        {
            [button1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button4 setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
            // 已完成
            refushType = 4;
        }
            
            break;
            
        default:
            break;
    }
    
    //设定文字颜色
    [UIView animateWithDuration:.2f animations:^{
        // 移动滑块
        if (button.tag == 1) {
            NSInteger OriginX = button.frame.origin.x + button.bounds.size.width / 2 - Adaptive(12.5);
            moveView.frame = CGRectMake(OriginX,
                                        Adaptive(35) + NavigationBar_Height,
                                        Adaptive(25),
                                        Adaptive(2));
        } else {
            
            NSInteger OriginX = button.frame.origin.x + button.bounds.size.width / 2 - Adaptive(19);
            moveView.frame = CGRectMake(OriginX,
                                        Adaptive(35) + NavigationBar_Height,
                                        Adaptive(38),
                                        Adaptive(2));
        }
    }];
    
    // 更新数据
    [self setupRefresh];
}


#pragma mark - 删除订单、去评价、去支付按钮点击事件
- (void)removeButtonClick:(UIButton *)button {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认删除此订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        if (buttonIndex == 1) {
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        }
    } else {
        if (buttonIndex == 1) {
           
            OrderRemarkCell *cell     = (OrderRemarkCell *)alertView.superview.superview;
            NSIndexPath *indexPath    = [_tableView indexPathForCell:cell];
            OrderDataModel *dataModel = orderArray[indexPath.section];
            NSString *url = [NSString stringWithFormat:@"%@api/?method=gdcourse.delete_order&order_id=%@",BASEURL,dataModel.order_id];
            [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
                
            } success:^(id responseObject) {
                [self headerRereshing];
            }];
        }
    }
}
- (void)goPayButtonClick:(UIButton *)button {
    
    NSLog(@"去支付");
    OrderRemarkCell *cell     = (OrderRemarkCell *)button.superview;
    NSIndexPath *indexPath    = [_tableView indexPathForCell:cell];
    OrderDataModel *dataModel = orderArray[indexPath.section];
    
    NSString *classOrShip     = [dataModel.course_type isEqualToString:@"1"] ? @"class" : @"shop";
    
    NSString *class_id        = dataModel.class_id;
    NSString *className       = dataModel.courseName;
    
    self.hidesBottomBarWhenPushed = YES;
    AddMessageViewController *addMessageVC = [AddMessageViewController new];
    addMessageVC.class_id    = class_id;
    addMessageVC.className   = className;
    addMessageVC.classOrShip = classOrShip;
    addMessageVC.isChange    = @"change";
    addMessageVC.name        = dataModel.userName;
    addMessageVC.phoneNumber = dataModel.photoNumber;
    addMessageVC.address     = dataModel.userPlace;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY年MM月dd日"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[dataModel.pre_time intValue]];
  
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    addMessageVC.date        = confromTimespStr;
    addMessageVC.time        = dataModel.pre_time_area;
    addMessageVC.order_id    = dataModel.order_id;
    
    [self.navigationController pushViewController:addMessageVC animated:YES];
     self.hidesBottomBarWhenPushed = YES;
}
- (void)goCommentButtonClick:(UIButton *)button {
    
    NSLog(@"去评价");
    
    OrderRemarkCell *cell     = (OrderRemarkCell *)button.superview;
    NSIndexPath *indexPath    = [_tableView indexPathForCell:cell];
    OrderDataModel *dataModel = orderArray[indexPath.section];
    
    self.hidesBottomBarWhenPushed = YES;
    OrderCommentViewController *comment = [OrderCommentViewController new];
    comment.order_id = dataModel.order_id;
    [self.navigationController pushViewController:comment animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

@end
