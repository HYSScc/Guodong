//
//  MyExercise.m
//  果动
//
//  Created by mac on 15/4/29.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "MyExercise.h"
#import "Commonality.h"
#import "HttpTool.h"
#import "exerciseComment.h"
#import "ExerciseDetail.h"
#import "MYExerciseTableViewCell.h"
#import "LoginViewController.h"
#import "MainController.h"
#import "AppDelegate.h"
@interface MyExercise ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    NSString *ID;
    UIImageView *imageView;
    UILabel *noMoneyLabelTop;
    UILabel* noMoneyLabel;
    UIButton *shareButton;
}
@property (nonatomic,retain)NSMutableArray *request;
@end

@implementation MyExercise

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"身体数据"];
    
    BackView *backView = [[BackView alloc] initWithbacktitle:@"个人" viewController:self];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
   // self.title = @"身体数据";
    
    self.view.backgroundColor = BASECOLOR;
    UIImageView * image1line=[UIImageView new];
    image1line.image=[UIImage imageNamed:@"home__line1"];
    image1line.frame=CGRectMake(0, 0, viewWidth, 0.5);
    [self.view addSubview:image1line];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - NavigationBar_Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.rowHeight = viewHeight/9.5286;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}

-(void)initView
{
    
    UIImageView *baseImage = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - viewHeight/9.137)/2, viewHeight/7.847, viewHeight/9.137, viewHeight/6.01)];
    baseImage.image = [UIImage imageNamed:@"shuju_stcs"];

    noMoneyLabelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetMaxY(baseImage.frame) + viewHeight/38.114), viewWidth, viewHeight/33.35)];
    noMoneyLabelTop.textColor = [UIColor whiteColor];
    noMoneyLabelTop.text = @"您还没有订单噢...";
    noMoneyLabelTop.textAlignment = 1;
    noMoneyLabelTop.font = [UIFont fontWithName:FONT size:viewHeight/33.35];
    
    noMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noMoneyLabelTop.frame) + viewHeight/53.36, viewWidth, viewHeight/44.467)];
    noMoneyLabel.textColor = [UIColor colorWithRed:94/255.0 green:94/255.0 blue:94/255.0 alpha:1];
    noMoneyLabel.text = @"赶快召唤我们的教练吧!";
    noMoneyLabel.textAlignment = 1;
    noMoneyLabel.font = [UIFont fontWithName:FONT size:viewHeight/44.467];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame = CGRectMake((viewWidth - viewHeight/6.737)/2, CGRectGetMaxY(noMoneyLabel.frame) + viewHeight/26.68, viewHeight/6.737, viewHeight/22.233);
    [shareButton setBackgroundImage:[UIImage imageNamed:@"money_dingke"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];

    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.my_training",BASEURL];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        NSLog(@"res  %@!",responseObject);
        if ([[responseObject objectForKey:@"rc"] intValue] == 0) {
            NSArray *data = [responseObject objectForKey:@"data"];
            self.request = [[NSMutableArray alloc] initWithCapacity:0];
            
            
            if (data.count == 0) {
                
                [_tableView addSubview:baseImage];
                [_tableView addSubview:noMoneyLabel];
                [_tableView addSubview:noMoneyLabelTop];
                [_tableView addSubview:shareButton];
               
            }else
            {
                [baseImage removeFromSuperview];
                [noMoneyLabelTop removeFromSuperview];
                [noMoneyLabel removeFromSuperview];
                [shareButton removeFromSuperview];
                
                
                for (NSDictionary *dict in data) {
                    exerciseComment *comment = [[exerciseComment alloc] initWithDictionary:dict];
                    [self.request addObject:comment];
                    
                }
                [_tableView reloadData];
                
            }
        }
        else if ([[responseObject objectForKey:@"rc"] intValue] == NotLogin_RC_Number)
        {
            [HeadComment showAlert:@"温馨提示" withMessage:@"您还没有登录呢！" delegate:self witchCancelButtonTitle:@"暂不" otherButtonTitles:@"去登录", nil];
            
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:[responseObject objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alert show];
        }
    } fail:^(NSError *error) {
        NSLog(@"error  %@",error);
    }];
    
}
-(void)shareButton
{
    MainController *main = [MainController new];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = main;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.request.count;
}



//设置单元格的内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    MYExerciseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[MYExerciseTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:cellidentifier];
        
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
        // 单元格的选中样式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    exerciseComment *comment = [self.request objectAtIndex:indexPath.row];

    cell.baseImageView.image = [UIImage imageNamed:@"shuju_jiantou"];

    if ([comment.isview isEqualToString:@"0"]) {
        cell.backgroundColor = [UIColor orangeColor];
    }
    else
    {
        cell.backgroundColor = BASECOLOR;
    }
    
    
    cell.coachLabel.text = [NSString stringWithFormat:@"教练/%@",comment.coach];
    cell.coachLabel.textAlignment = 0;
    // 时间戳转时间的方法:
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd HH:mm"];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[comment.time intValue]];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    cell.timeLabel.text = confromTimespStr;

    ID = comment.ID;
    return cell;
    
}
//选中单元格的时候调用
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    exerciseComment *comment = [self.request objectAtIndex:indexPath.row];
    ExerciseDetail *exercise = [ExerciseDetail new];
    
    exercise.ID = comment.ID;
    NSLog(@"exercise.ID        %@",exercise.ID);
    [self.navigationController pushViewController:exercise animated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
    
}
@end
