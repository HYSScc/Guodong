//
//  SYJLViewController.m
//  果动
//
//  Created by mac on 15/8/28.
//  Copyright (c) 2015年 Unique. All rights reserved.
//


#import "LoginViewController.h"
#import "MingXiComment.h"
#import "MingXiTableViewCell.h"
#import "SYJLViewController.h"
@interface SYJLViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    UITableView* _tableView;
    UILabel* numberLabel;
}
@property (nonatomic, retain) NSMutableArray* request;
@end

@implementation SYJLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"使用记录"];
    BackView* backView = [[BackView alloc] initWithbacktitle:@"私房钱" viewController:self];
    UIBarButtonItem* backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    self.view.backgroundColor = BASECOLOR;

    UIImageView* baseImage = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(119)) / 2, (viewHeight - Adaptive(10) - Adaptive(133)) / 2, Adaptive(119), Adaptive(133))];
    baseImage.image = [UIImage imageNamed:@"syjl_no"];

    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - Adaptive(10)) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.rowHeight = Adaptive(70);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 设置单元格的分割样式
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:_tableView];

    NSString* url = [NSString stringWithFormat:@"%@api/?method=gdmoney.mymoney", BASEURL];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {

        if (ResponseObject_RC == 0) {
            NSDictionary* data = [responseObject objectForKey:@"data"];
            NSArray* cons = [data objectForKey:@"cons"];
            if (cons.count == 0) {
                [self.view addSubview:baseImage];
            }
            else {
                numberLabel.text = [NSString stringWithFormat:@"%@", [data objectForKey:@"banlance"]];
                self.request = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary* dict in cons) {
                    MingXiComment* mingxi = [[MingXiComment alloc] initWithDictionary:dict];
                    if ([mingxi.code intValue] != 0) {
                        [self.request addObject:mingxi];
                    }
                }
            }
            [_tableView reloadData];
        }
        else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }

    }
        fail:^(NSError* error){
        }];
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.request.count;
}
// 设置单元格的内容的
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    //1,定义一个重用标示符
    static NSString* cellIdentifier = @"Cell";

    //2,从队列中出列一个可以重用的单元格
    MingXiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    //3,
    if (!cell) {
        cell = [[MingXiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MingXiComment* mingxi = [self.request objectAtIndex:indexPath.row];
    cell.numberLabel.text = mingxi.money;
    cell.titleLabel.text = mingxi.types;
    // 时间戳转时间的方法:
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:[mingxi.time intValue]];
    //  NSLog(@"1296035591  = %@",confromTimesp);
    NSString* confromTimespStr = [formatter stringFromDate:confromTimesp];
    cell.timeLabel.text = confromTimespStr;

    if ([mingxi.code intValue] == 1) {
        cell.biaozhi.image = [UIImage imageNamed:@"MingXi_xiaofei"];
        cell.numberImage.image = [UIImage imageNamed:@"mingxi_fouseimage"];
        cell.numberLabel.textColor = [UIColor colorWithRed:177.00 / 255 green:177.00 / 255 blue:174.00 / 255 alpha:1];
    }
    else if ([mingxi.code intValue] == 2) {
        cell.biaozhi.image = [UIImage imageNamed:@"MingXi_guoqi"];
        cell.numberImage.image = [UIImage imageNamed:@"mingxi_fouseimage"];
        cell.numberLabel.textColor = [UIColor colorWithRed:177.00 / 255 green:177.00 / 255 blue:174.00 / 255 alpha:1];
    }
    else {
        cell.numberImage.image = [UIImage imageNamed:@"mingxi_tureimage"];
        cell.biaozhi.image = [UIImage imageNamed:@""];
        cell.numberLabel.textColor = [UIColor colorWithRed:226.00 / 255 green:160.00 / 255 blue:48.00 / 255 alpha:1];
    }

    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}
@end
