//
//  sportsViewController.m
//  私练
//
//  Created by z on 15/1/23.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "sportsViewController.h"
#import "histoyrSportViewController.h"
#import "Commonality.h"
#import "HttpTool.h"
#import "historyTableViewCell.h"
#import "contentSportViewController.h"
#import "SportComment.h"

#define viewWidth [UIScreen mainScreen].bounds.size.width
@interface SportsViewController ()<UITableViewDataSource,UITableViewDelegate>

{
    UIImageView *textImageView;
    UIImageView *imageView;
    UIButton *button;
    NSString *status;
    NSMutableArray *activityArray;
    UITableView *_tableView;
}
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SportsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  //   __weak SportsViewController *weakSelf = self;
    self.view.backgroundColor     = BASECOLOR;
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"我们的活动"];

    UIImageView * lineImage1=[UIImageView new];
    lineImage1.image=[UIImage imageNamed:@"home__line1"];
    lineImage1.frame              = CGRectMake(0, 0, viewWidth, 1);
    [self.view addSubview:lineImage1];
    
    UIButton *amentButton=[UIButton buttonWithType:UIButtonTypeSystem];
    amentButton.frame = CGRectMake(viewHeight/2.0212, viewHeight/24.7037, viewHeight/9.529, viewHeight/22.233);
    amentButton.titleLabel.font = [UIFont fontWithName:FONT size:13];
    [amentButton setTitle:@"以前的活动" forState:UIControlStateNormal];
    [amentButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *releaseButtonItem = [[UIBarButtonItem alloc] initWithCustomView:amentButton];
    self.navigationItem.rightBarButtonItem = releaseButtonItem;
    
    _tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(10, 5, viewWidth - 20, viewHeight) style:UITableViewStylePlain];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.rowHeight       = 120;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];

    
    
    
    imageView            = [[UIImageView alloc] init];
  //  imageView.image      = [UIImage imageNamed:@"images1"];

    imageView.bounds     = CGRectMake(0, 0, 150, 150);
    imageView.center     = CGPointMake(viewWidth/2-10, viewHeight/4);

    textImageView        = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"textImage"]];
   // textImageView.frame = CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame)+20, 100, 30);
    textImageView.bounds = CGRectMake(0, 0, 189, 18);
    textImageView.center = CGPointMake(viewWidth/2-10, CGRectGetMaxY(imageView.frame)+viewHeight/15);
   
    
    
    
}

-(void)setupRefresh
{
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_tableView headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText    = HEADERPULLTOREFRESH;
    _tableView.headerReleaseToRefreshText = HEADERRELEASETOREFRESH;
    _tableView.headerRefreshingText       = HEADERREFRESHING;
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
   [self setupRefresh];
}
-(void)headerRereshing
{
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=activity.new",BASEURL];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        NSLog(@"responseObject  %@",responseObject);
        if ([[responseObject objectForKey:@"rc"] intValue] == 0)
        {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            
            
            
            status = [dict objectForKey:@"status"];
            if ([status intValue] == 0) {
                [_tableView addSubview:imageView];
                [_tableView addSubview:textImageView];
                
            }
            else
            {
                NSArray *array = [dict objectForKey:@"activity"];
                activityArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dict in array) {
                    
                    NSLog(@"dict   >>>>>>>   %@",dict);
                    
                    SportComment *sport = [[SportComment alloc] initWithDictionary:dict];
                    
                    [activityArray addObject:sport];
                    
                    //   NSLog(@"self.request>>>>>>>>>%ld",self.request.count);
                    [_tableView reloadData];
                    
                }
                
                
            }
            [_tableView headerEndRefreshing];
        }
        else
        {
             [_tableView headerEndRefreshing];
            [HeadComment showAlert:@"温馨提示" withMessage:@"您还没有登录呢！" delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
        }
        
    } fail:^(NSError *error) {
        NSLog(@"error   %@",error);
    }];
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  activityArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //1,定义一个重用标示符
    static NSString *cellIdentifier = @"Cell";
    
    //2,从队列中出列一个可以重用的单元格
    historyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //3,
    if (!cell) {
        cell = [[historyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.backgroundColor = [UIColor clearColor];
    SportComment *sport = [activityArray objectAtIndex:indexPath.row];
    cell.titleLabel.text = sport.theme;
        NSLog(@"cell.title  %@",cell.titleLabel.text);
    NSLog(@"image   %@",sport.image);
    NSURL *imageurl = [NSURL URLWithString:sport.image];
    NSData *data = [[NSData alloc] initWithContentsOfURL:imageurl];
    UIImage *image = [[UIImage alloc] initWithData:data];
    cell.logoImageView.image = image;
   // 时间戳转时间的方法:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"MM月dd日"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[sport.time intValue]];
    NSLog(@"1296035591  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    cell.dateLabel.text = confromTimespStr;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *where = @"100";
    contentSportViewController *contentVC = [[contentSportViewController alloc] init];
    SportComment *sport = [activityArray objectAtIndex:indexPath.row];
    contentVC.where = where;
    contentVC.idstr  = sport.idstr;
    NSLog(@"sport.id  %@",sport.idstr);
    [self.navigationController pushViewController:contentVC animated:YES];
}


-(void)buttonClick:(UIButton *)button
{
    
    histoyrSportViewController *histoyrVC = [[histoyrSportViewController alloc] init];
    [self.navigationController pushViewController:histoyrVC animated:YES];
    
}

@end