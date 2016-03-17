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
#import "Mingxi_shareJuan.h"
#import "MingXi_exp.h"
@interface SYJLViewController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    UITableView* _tableView;
    UILabel* numberLabel;
    BOOL isExp;
}
@property (nonatomic, retain) NSMutableArray* request,*publicity_list,*exp_array;
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
            NSDictionary* data      = [responseObject objectForKey:@"data"];
            NSArray *cons           = [data objectForKey:@"cons"];
            NSArray *publicity_list = [data objectForKey:@"publicity_list"];
            
            
            // 体验卷
            
            if ([[[data objectForKey:@"exp"] class] isSubclassOfClass:[NSDictionary class]]) {
                if ([[[data objectForKey:@"exp"] objectForKey:@"status"] intValue] == 1 ) {
                    isExp = YES; // 未使用
                }
                
            }
            
            if (cons.count == 0 && publicity_list.count == 0 && isExp == NO) {
                [self.view addSubview:baseImage];
            }
            else {
                numberLabel.text    = [NSString stringWithFormat:@"%@", [data objectForKey:@"banlance"]];
                self.request        = [[NSMutableArray alloc] initWithCapacity:0];
                self.publicity_list = [[NSMutableArray alloc] initWithCapacity:0];
                self.exp_array      = [[NSMutableArray alloc] initWithCapacity:0];
                
                
                // 私房钱
                
                for (NSDictionary* dict in cons) {
                    MingXiComment* mingxi = [[MingXiComment alloc] initWithDictionary:dict];
                    if ([mingxi.code intValue] != 0) {
                        [self.request addObject:mingxi];
                    }
                }
                // 分享卷
                
                for (NSDictionary* juanDict in publicity_list) {
                    
                    if ([[juanDict objectForKey:@"status"] intValue] == 1) {
                        Mingxi_shareJuan* mingxi = [[Mingxi_shareJuan alloc] initWithDictionary:juanDict];
                        
                        [self.publicity_list addObject:mingxi];
                    }
                    
                }
                
                
                // 体验卷
                if ([[[data objectForKey:@"exp"] class] isSubclassOfClass:[NSDictionary class]]) {
                    if ([[[data objectForKey:@"exp"] objectForKey:@"status"] intValue] == 0) {
                        NSDictionary *expDict        = [data objectForKey:@"exp"];
                        MingXi_exp* mingxi           = [[MingXi_exp alloc] initWithDictionary:expDict];
                        NSLog(@"mingxi  %d",mingxi.status);
                        [self.exp_array addObject:mingxi];
                    }
                }
                
            }
            [_tableView reloadData];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
        
    }
                     fail:^(NSError* error){
                     }];
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"self.exp_array.count + self.publicity_list.count + self.request.count %lu",self.exp_array.count + self.publicity_list.count + self.request.count);
    return self.exp_array.count + self.publicity_list.count + self.request.count;
}
// 设置单元格的内容的
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (indexPath.row < self.exp_array.count) {
        
        MingXi_exp* mingxi = [self.exp_array objectAtIndex:indexPath.row];
        //1,定义一个重用标示符
        static NSString* cellIdentifier = @"expCell";
        
        //2,从队列中出列一个可以重用的单元格
        MingXiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //3,
        if (!cell) {
            cell = [[MingXiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle   = UITableViewCellSelectionStyleNone;
        cell.numberLabel.text = [NSString stringWithFormat:@"%@",mingxi.name];
        cell.titleLabel.text  = [NSString stringWithFormat:@"%@",mingxi.name];
        cell.timeLabel.text   = mingxi.exp_code;
        
        
        cell.biaozhi.image         = [UIImage imageNamed:@"MingXi_xiaofei"];
        cell.numberImage.image     = [UIImage imageNamed:@"mingxi_fouseimage"];
        cell.numberLabel.textColor = [UIColor colorWithRed:177.00 / 255 green:177.00 / 255 blue:174.00 / 255 alpha:1];
        
        
        return cell;
        
    } else if (indexPath.row - self.exp_array.count < self.publicity_list.count) {
        Mingxi_shareJuan* mingxi = [self.publicity_list objectAtIndex:indexPath.row - self.exp_array.count];
        //1,定义一个重用标示符
        static NSString* cellIdentifier = @"Cell";
        
        //2,从队列中出列一个可以重用的单元格
        MingXiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //3,
        if (!cell) {
            cell = [[MingXiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle   = UITableViewCellSelectionStyleNone;
        cell.numberLabel.text = [NSString stringWithFormat:@"%@",mingxi.name];
        cell.titleLabel.text  = [NSString stringWithFormat:@"%@",mingxi.name];
        cell.timeLabel.text   = mingxi.code;
        
        
        
        cell.biaozhi.image         = [UIImage imageNamed:@"MingXi_xiaofei"];
        cell.numberImage.image     = [UIImage imageNamed:@"mingxi_fouseimage"];
        cell.numberLabel.textColor = [UIColor colorWithRed:177.00 / 255 green:177.00 / 255 blue:174.00 / 255 alpha:1];
        
        
        return cell;
    } else {
        
        MingXiComment* mingxi = [self.request objectAtIndex:indexPath.row  - self.publicity_list.count - self.exp_array.count];
        //1,定义一个重用标示符
        static NSString* cellIdentifier = @"Cell";
        
        //2,从队列中出列一个可以重用的单元格
        MingXiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        //3,
        if (!cell) {
            cell = [[MingXiTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.selectionStyle    = UITableViewCellSelectionStyleNone;
        cell.numberImage.frame = CGRectMake(Adaptive(20), Adaptive(15), Adaptive(68), Adaptive(40));
        cell.numberLabel.frame = CGRectMake(0, 0, cell.numberImage.bounds.size.width, cell.numberImage.bounds.size.height);
        cell.numberLabel.text  = [NSString stringWithFormat:@"￥%@",mingxi.money];
        cell.titleLabel.text   = mingxi.types;
        // 时间戳转时间的方法:
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSDate* confromTimesp      = [NSDate dateWithTimeIntervalSince1970:[mingxi.time intValue]];
        NSString* confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell.timeLabel.text        = confromTimespStr;
        
        if ([mingxi.code intValue] == 1) {
            cell.biaozhi.image         = [UIImage imageNamed:@"MingXi_xiaofei"];
            cell.numberImage.image     = [UIImage imageNamed:@"mingxi_fouseimage"];
            cell.numberLabel.textColor = [UIColor colorWithRed:177.00 / 255 green:177.00 / 255 blue:174.00 / 255 alpha:1];
            
        } else  {
            cell.biaozhi.image = [UIImage imageNamed:@"MingXi_guoqi"];
            cell.numberImage.image = [UIImage imageNamed:@"mingxi_fouseimage"];
            cell.numberLabel.textColor = [UIColor colorWithRed:177.00 / 255 green:177.00 / 255 blue:174.00 / 255 alpha:1];
        }
        
        return cell;
        
    }
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
