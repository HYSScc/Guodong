//
//  CityViewController.m
//  果动
//
//  Created by mac on 16/5/17.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "CityViewController.h"

@interface CityViewController ()<UITableViewDataSource, UITableViewDelegate>
{
     UITableView *_tableView;
     NSArray     *citys;
    UILabel* textLabel;
}
@end

@implementation CityViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden           = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor     = BASECOLOR;
   
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"当前城市" viewController:self];
    [self.view addSubview:navigation];
    
    [self createUI];

    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"again" object:nil];
    
}

- (void)tongzhi:(NSNotification *)notification {
    textLabel.text = [notification.userInfo objectForKey:@"name"];
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, LastHeight) style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight       = Adaptive(70);
    _tableView.backgroundColor = BASECOLOR;
    [self.view addSubview:_tableView];
    
    
     NSString* url = [NSString stringWithFormat:@"%@citys/", BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
         citys = [responseObject objectForKey:@"all_citys"];
        [_tableView reloadData];
    }];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return citys.count;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section
{
    return Adaptive(70);
}
- (UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(70))];
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(20), headView.bounds.size.height - .5, viewWidth - Adaptive(40), .5)];
    line.backgroundColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1];
    [headView addSubview:line];
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(30), Adaptive(38), Adaptive(150), Adaptive(18))];
    textLabel.font = [UIFont fontWithName:FONT size:Adaptive(18)];
    textLabel.textAlignment = 0;
    textLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:125 / 255.0 blue:40 / 255.0 alpha:1];
    textLabel.text = self.cityName;
    [textLabel sizeToFit];
    [headView addSubview:textLabel]; //102
    
    
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    setButton.frame     = CGRectMake(0, 0, headView.bounds.size.width, headView.bounds.size.height);
    [setButton addTarget:self action:@selector(setButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    setButton.userInteractionEnabled = [_isSet isEqualToString:@"set"] ? YES : NO;
    [headView addSubview:setButton];
    
    
    
    UILabel* currentLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth - Adaptive(100), Adaptive(38), Adaptive(70), Adaptive(15))];
    currentLabel.textAlignment = 1;
    currentLabel.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    currentLabel.text = @"当前城市";
    currentLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    [headView addSubview:currentLabel];
    return headView;
}

- (void)setButtonClick:(UIButton *)button {
  
    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:url]) {
        
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
        
    }
    
  }


//设置单元格的内容
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellidentifier = @"cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.backgroundColor = BASECOLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(20), Adaptive(70) - .5, viewWidth - Adaptive(40), .5)];
    line.backgroundColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1];
    [cell addSubview:line];
    UILabel* textLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(30), Adaptive(38), Adaptive(150),Adaptive(15))];
    textLabel1.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    textLabel1.textAlignment = 0;
    textLabel1.textColor = [UIColor colorWithRed:187 / 255.0 green:187 / 255.0 blue:187 / 255.0 alpha:1];
    textLabel1.text = citys[indexPath.row];
    [cell addSubview:textLabel1];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
