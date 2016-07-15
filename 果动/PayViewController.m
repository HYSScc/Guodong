//
//  PayViewController.m
//  果动
//
//  Created by mac on 16/6/15.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "RechargeViewController.h"
#import "PayViewController.h"
#import "PayTableViewCell.h"
#import "PayModel.h"
#import "payView.h"
#import "OrderViewController.h"
@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PayViewController
{
    UITableView *_tableView;
    NSInteger   isClick;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"支付" viewController:self];
    [self.view addSubview:navigation];
    [self createUI];
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushOrderView) name:@"pushOrderView" object:nil];
    
    
}

- (void)pushOrderView {
    
    self.hidesBottomBarWhenPushed          = YES;
    OrderViewController *order = [OrderViewController new];
    [self.navigationController pushViewController:order animated:YES];
    self.hidesBottomBarWhenPushed          = NO;
    
}

- (void)createUI {
    
    UIImageView *iconImageView = [UIImageView new];
    iconImageView.frame        = CGRectMake((viewWidth -  _iconWidth / 2) / 2,
                                            Adaptive(13) + NavigationBar_Height,
                                            _iconWidth / 2,
                                            _iconHeight / 2);
    [iconImageView sd_setImageWithURL:[NSURL URLWithString:_iconImageUrl]];
    [self.view addSubview:iconImageView];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(300)) / 2,
                                                               CGRectGetMaxY(iconImageView.frame) + Adaptive(20),
                                                               Adaptive(300),
                                                               Adaptive(50))
                                              style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.rowHeight  = Adaptive(50);
    _tableView.bounces    = NO;
    _tableView.backgroundColor = ORANGECOLOR;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle  = UITableViewCellEditingStyleNone;
    [self.view addSubview:_tableView];
    
    
    UIImageView *rechargeImageView = [UIImageView new];
    rechargeImageView.frame        = CGRectMake(Adaptive(13),
                                                CGRectGetMaxY(_tableView.frame) + Adaptive(13),
                                               viewWidth - Adaptive(26),
                                                (viewWidth - Adaptive(26))*([_rechargeHeight floatValue]/2)/([_rechargeWidth floatValue]/2));
    rechargeImageView.userInteractionEnabled = YES;
    [rechargeImageView sd_setImageWithURL:[NSURL URLWithString:_rechargeUrl]];
    [self.view addSubview:rechargeImageView];
    
    
    UIButton *rechargeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rechargeButton.frame     = CGRectMake(0, 0, rechargeImageView.bounds.size.width, rechargeImageView.bounds.size.height);
    [rechargeButton addTarget:self action:@selector(rechargeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [rechargeImageView addSubview:rechargeButton];
    
    
    UIButton *introduceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    introduceButton.frame     = CGRectMake((viewWidth - Adaptive(80)) / 2,
                                           CGRectGetMaxY(rechargeImageView.frame) + Adaptive(10),
                                           Adaptive(80),
                                           Adaptive(15));
  //  [introduceButton setTitle:@"体验券说明" forState:UIControlStateNormal];
    [introduceButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
  //  [introduceButton addTarget:self action:@selector(introduceButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    introduceButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    [self.view addSubview:introduceButton];
    
    UILabel *line = [UILabel new];
    line.frame    = CGRectMake((viewWidth - Adaptive(80)) / 2,
                               CGRectGetMaxY(introduceButton.frame),
                               Adaptive(80),
                               .5);
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    
    CGRect payFrame = CGRectMake(0,
                                 CGRectGetMaxY(line.frame) + Adaptive(5),
                                 viewWidth,
                                 viewHeight  - CGRectGetMaxY(line.frame));
    payView *pay = [[payView alloc] initWithFrame:payFrame payMoney:_oneClassPrice classTime:_oneClassTime youhuijuan:_userMoney order_id:_order_id viewController:self];
    [self.view addSubview:pay];
    
}

#pragma mark - 充值
- (void)rechargeButtonClick:(UIButton *)button {
    RechargeViewController *rechargeVC = [RechargeViewController new];
    rechargeVC.addressMessageDict      = _addressMessageDict;
    
    [self.navigationController pushViewController:rechargeVC animated:YES];
}

//#pragma mark - 体验券说明
//- (void)introduceButtonClick:(UIButton *)button {
//    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdmoney.introduce",BASEURL];
//    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
//        
//    } success:^(id responseObject) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[responseObject objectForKey:@"data"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        
//        [alert show];
//    }];
//}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _packageArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    PayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[PayTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.row == 0) {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元/1课时",_oneClassPrice]];
        [str addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:NSMakeRange(0,_oneClassPrice.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(_oneClassPrice.length,5)];
        cell.contentLabel.attributedText = str;
        
    } else {
        PayModel *pay = [[PayModel alloc] initWithDictionary: _packageArray[indexPath.row - 1]];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元/%@课时",pay.price,pay.classNumber]];
        [str addAttribute:NSForegroundColorAttributeName value:ORANGECOLOR range:NSMakeRange(0,pay.price.length)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(pay.price.length,4+pay.classNumber.length)];
        
        cell.contentLabel.attributedText = str;
        cell.remarkLabel.text  = pay.remark;
        
    }
    if (isClick == indexPath.row) {
        
        cell.ringImageView.image = [UIImage imageNamed:@"pay_ring_orange"];
        cell.kuangImageView.image = [UIImage imageNamed:@"pay_kuang_orange"];
    } else {
        cell.ringImageView.image = [UIImage imageNamed:@"pay_ring_gry"];
        cell.kuangImageView.image = [UIImage imageNamed:@"pay_kuang_gry"];
    }
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    isClick = indexPath.row;
    [_tableView reloadData];
    
    NSDictionary *payDict;
    if (indexPath.row == 0) {
        
        payDict = @{@"money":_oneClassPrice,
                    @"payTypes":@"gdcourse",
                    @"package_id":@""};
        
    } else {
        PayModel *pay = [[PayModel alloc] initWithDictionary: _packageArray[indexPath.row - 1]];
        payDict = @{@"money":pay.price,
                    @"payTypes":@"package",
                    @"package_id":pay.package_id};
    }
    
    
    
        NSNotification *notification =[NSNotification notificationWithName:@"changeMoney" object:nil userInfo:payDict];
    
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
