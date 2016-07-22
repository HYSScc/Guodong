//
//  MoneyViewController.m
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MoneyIntroduceController.h"
#import "SetShareViewController.h"
#import "LoginViewController.h"
#import "MoneyViewController.h"
#import "MoneyTableViewCell.h"
#import "MoneyModel.h"
@interface MoneyViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITextField *_textField;
    UITableView *_tableView;
    NSMutableArray *moneyArray;
    int page;
    UIView *noDataView;
    
    UILabel *timeOverLabel;
    
}
@end

@implementation MoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"优惠券" viewController:self];
    [self.view addSubview:navigation];
    
    page = 1;
     moneyArray = [NSMutableArray array];
    
    
    if ([HttpTool judgeWhetherUserLogin]) {
        [self createUI];
        // 2.集成刷新控件
        [self setupRefresh];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
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
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdmoney.mymoney",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        page = 1;
        [moneyArray removeAllObjects];
        if ([[[responseObject objectForKey:@"data"] objectForKey:@"cons"] count] != 0) {
            [noDataView removeFromSuperview];
            for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"cons"]) {
                MoneyModel *moneyModel = [[MoneyModel alloc] initWithDictionary:dict];
                [moneyArray addObject:moneyModel];
            }
        }
        NSString *number = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"expire"]];
        
        if ([number intValue] != 0) {
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"有 %@ 张优惠券即将过期",number]];
            [str addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:NSMakeRange(2,number.length)];
            timeOverLabel.attributedText = str;
        }
        
      
        
        
        [_tableView reloadData];
        // 结束刷新状态
        [_tableView headerEndRefreshing];
    }];

}
- (void)footerRereshing
{
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdmoney.mymoney&page=%d",BASEURL,page];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        if ([[[responseObject objectForKey:@"data"] objectForKey:@"cons"] count] != 0) {
            for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"cons"]) {
                MoneyModel *moneyModel = [[MoneyModel alloc] initWithDictionary:dict];
                [moneyArray addObject:moneyModel];
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
    
    _textField       = [UITextField new];
    UIView *view     = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    _textField.leftView     = view;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    _textField.frame = CGRectMake(Adaptive(13),
                                  Adaptive(13) + NavigationBar_Height,
                                  viewWidth - Adaptive((26 + 80 + 10)),
                                  Adaptive(28));
    _textField.placeholder       = @"请输入优惠券号码";
    _textField.font              = [UIFont fontWithName:FONT size:Adaptive(14)];
    _textField.textColor         = [UIColor grayColor];
    _textField.layer.borderColor = ORANGECOLOR.CGColor;
    _textField.layer.borderWidth = 1.f;
    [_textField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.view addSubview:_textField];
    
    UIButton *exchangeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    exchangeButton.frame     = CGRectMake(CGRectGetMaxX(_textField.frame) + Adaptive(10),
                                          Adaptive(13) + NavigationBar_Height,
                                          Adaptive(80),
                                          Adaptive(28));
    exchangeButton.backgroundColor = ORANGECOLOR;
    [exchangeButton setTitle:@"兑换" forState:UIControlStateNormal];
    [exchangeButton setTintColor:[UIColor blackColor]];
    [exchangeButton addTarget:self action:@selector(exchangeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:exchangeButton];
    
    
    timeOverLabel = [UILabel new];
    timeOverLabel.frame = CGRectMake(Adaptive(13),
                                     CGRectGetMaxY(_textField.frame) + Adaptive(13),
                                     viewWidth / 2,
                                     Adaptive(13));
    timeOverLabel.textColor = [UIColor grayColor];
    timeOverLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    [self.view addSubview:timeOverLabel];
    
    UILabel *introduceLabel = [UILabel new];
    introduceLabel.frame    = CGRectMake(viewWidth - Adaptive(73),
                                         CGRectGetMaxY(_textField.frame) + Adaptive(13),
                                         Adaptive(60),
                                         Adaptive(13));
    introduceLabel.text = @"优惠券说明";
    introduceLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    introduceLabel.textColor = [UIColor grayColor];
    [self.view addSubview:introduceLabel];
    
    
    UIImageView *questionImageView = [UIImageView new];
    questionImageView.frame        = CGRectMake(CGRectGetMinX(introduceLabel.frame) - Adaptive(14),
                                                CGRectGetMaxY(_textField.frame) + Adaptive(14),
                                                Adaptive(11),
                                                Adaptive(11));
    questionImageView.image = [UIImage imageNamed:@"person_question"];
    [self.view addSubview:questionImageView];
    
    
    UIButton *introduceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    introduceButton.frame = CGRectMake(CGRectGetMinX(introduceLabel.frame),
                                       CGRectGetMaxY(_textField.frame) + Adaptive(5),
                                       viewWidth - CGRectGetMinX(introduceLabel.frame) - Adaptive(13),
                                       Adaptive(29));
    [introduceButton addTarget:self action:@selector(introduceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:introduceButton];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeOverLabel.frame) + Adaptive(13), viewWidth, viewHeight - CGRectGetMaxY(timeOverLabel.frame) - Adaptive(13)) style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.rowHeight  = Adaptive(110);
    _tableView.backgroundColor = BASECOLOR;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    noDataView = [UIView new];
    noDataView.frame = CGRectMake(0, 0, viewWidth, viewHeight - NavigationBar_Height);
    [_tableView addSubview:noDataView];
    
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.frame        = CGRectMake((viewWidth - Adaptive(28)) / 2,
                                            Adaptive(90),
                                            Adaptive(28),
                                            Adaptive(34));
    iconImageView.image = [UIImage imageNamed:@"money_nodata"];
    [noDataView addSubview:iconImageView];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.frame    = CGRectMake(0, CGRectGetMaxY(iconImageView.frame) + Adaptive(15),
                                     viewWidth,
                                     Adaptive(15));
    titleLabel.text      = @"暂时没有优惠券...";
    titleLabel.textColor = [UIColor colorWithRed:127/255.0 green:127/255.0 blue:127/255.0 alpha:1];
    titleLabel.textAlignment = 1;
    titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
    [noDataView addSubview:titleLabel];
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    publishButton.frame     = CGRectMake((viewWidth - Adaptive(120)) / 2, CGRectGetMaxY(titleLabel.frame) + Adaptive(10), Adaptive(120), Adaptive(15));
    publishButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
    [publishButton setTitle:@"分享获得首张优惠券" forState:UIControlStateNormal];
    [publishButton setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [noDataView addSubview:publishButton];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"分享获得首张优惠券"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [publishButton setAttributedTitle:str forState:UIControlStateNormal];
}

// 跳转到优惠券说明
- (void)introduceButtonClick:(UIButton *)button {
    
    self.hidesBottomBarWhenPushed = YES;
    MoneyIntroduceController *introduce = [MoneyIntroduceController new];
    [self.navigationController pushViewController:introduce animated:YES];
    
}


- (void)publishButtonClick:(UIButton *)button {
    self.hidesBottomBarWhenPushed = YES;
    SetShareViewController *shareView = [SetShareViewController new];
    [self.navigationController pushViewController:shareView animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void)exchangeButtonClick:(UIButton *)button {
    
    [_textField resignFirstResponder];
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdmoney.exchange&code=%@",BASEURL,_textField.text];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        [self headerRereshing];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return moneyArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    MoneyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[MoneyTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.backgroundColor = BASECOLOR;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    MoneyModel *moneyModel = moneyArray[indexPath.row];
    cell.moneyModel        = moneyModel;
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}
@end
