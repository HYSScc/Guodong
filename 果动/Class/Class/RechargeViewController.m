//
//  RechargeViewController.m
//  果动
//
//  Created by mac on 16/7/5.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "LoginViewController.h"
#import "AddMessageViewController.h"
#import "AppDelegate.h"
#import "RechargeModel.h"
#import "RechargeCell.h"
#import "RechargeViewController.h"
#import "RechargePayView.h"
@interface RechargeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RechargeViewController
{
    
    UIImageView    *titleImageView;
    UILabel        *totalPrice;
    UITableView    *_tableView;
    NSInteger      index;
    NSString       *priceNumber;
    NSString       *price_id;
    NSString       *classNumber;
    NSMutableArray *dataArray;
    
    NSMutableAttributedString *attributedString;
    RechargePayView *payView;
    UIView          *alphaView;
    AppDelegate     *app;
    CGFloat         width;
    CGFloat         height;
    NSString        *imageUrl;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden           = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
   
    UIView *navigationView = [UIView new];
    navigationView.frame   = CGRectMake(0, 0, viewWidth, NavigationBar_Height);
    navigationView.backgroundColor = ORANGECOLOR;
    [self.view addSubview:navigationView];
    
    UIImageView* backArrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(13), Adaptive(20)+(Adaptive(44) - Adaptive(16.5)) / 2, Adaptive(9.75), Adaptive(16.5))];
    backArrowImageView.image = [UIImage imageNamed:@"every_back"];
    [self.view addSubview:backArrowImageView];
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.backgroundColor = [UIColor clearColor];
    backButton.frame = CGRectMake(-Adaptive(5), Adaptive(20), viewHeight / 9.5286, Adaptive(44));
    [backButton addTarget:self action:@selector(backButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];

    
    
    UIView* titleView = [[UIView alloc]initWithFrame:CGRectMake((viewWidth - Adaptive(51.6)) / 2,
                                                                Adaptive(20) + Adaptive((44 - 27)) / 2,
                                                                Adaptive(51.6),
                                                                Adaptive(27))];
    UIImageView* titleImage =[[UIImageView alloc]initWithFrame:CGRectMake(0,
                                                                          0,
                                                                          titleView.bounds.size.width,
                                                                          titleView.bounds.size.height)];
    titleImage.image  = [UIImage imageNamed:@"shouye_titleImage"];
    
    
    [titleView addSubview:titleImage];
    [navigationView addSubview:titleView];
    
    
    /***************客服****************************/
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoButton.frame     = CGRectMake(viewWidth - Adaptive((13 + 19)),  Adaptive(20) + Adaptive((44 - 19)) / 2, Adaptive(19), Adaptive(19));
    [photoButton setBackgroundImage:[UIImage imageNamed:@"shouye_photo"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(telePhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:photoButton];
    
  //  NSLog(@"[HttpTool judgeWhetherUserLogin] %@",[HttpTool judgeWhetherUserLogin]);
    
    if ([HttpTool judgeWhetherUserLogin]) {
         NSLog(@"[HttpTool judgeWhetherUserLogin] %d",[HttpTool judgeWhetherUserLogin]);
        [self startRequest];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAlphaView:) name:@"removeAlphaView" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushMainView) name:@"pushMainView" object:nil];
}

- (void)pushMainView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}

- (void)backButton
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)removeAlphaView:(NSNotification *)notification {
    
    [UIView animateWithDuration:.2 animations:^{
        
        payView.frame = CGRectMake(0, viewHeight , viewWidth, Adaptive(216));
    } completion:^(BOOL finished) {
        [alphaView removeFromSuperview];
        [payView   removeFromSuperview];
        
        AddMessageViewController *addMessageVC = (AddMessageViewController *)[self.navigationController.viewControllers objectAtIndex:2];

        addMessageVC.isChange    = [_addressMessageDict objectForKey:@"isChange"];      
        addMessageVC.order_id    = [_addressMessageDict objectForKey:@"order_id"];
        
        [self.navigationController popToViewController:addMessageVC animated:YES];
    }];
   
}

- (void)telePhoneClick:(UIButton *)button {
    NSMutableString* str = [[NSMutableString alloc] initWithFormat:@"tel:%@",KEFU];
    UIWebView* callWebview = [[UIWebView alloc] init];
    
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    
    [self.view addSubview:callWebview];
}


- (void)startRequest {
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=package.list",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        
            dataArray = [NSMutableArray array];
            for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"package_list"]) {
                RechargeModel *recharge = [[RechargeModel alloc] initWithDictionary:dict];
                [dataArray addObject:recharge];
            }
            [_tableView reloadData];
            
            RechargeModel *recharge = dataArray[0];
            NSString *priceString = [NSString stringWithFormat:@"合计：%@ 元",recharge.price];
            
            attributedString = [[NSMutableAttributedString alloc] initWithString:priceString];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:13] range:NSMakeRange(0,3)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:24] range:NSMakeRange(3,recharge.price.length)];
            [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:13] range:NSMakeRange(3+recharge.price.length + 1,1)];
            
            
            priceNumber = recharge.price;
            price_id    = recharge.type_id;
            classNumber = recharge.classNumber;
            
            width  = [[[[responseObject objectForKey:@"data"] objectForKey:@"img"] objectForKey:@"width"] floatValue] / 2;
            height = [[[[responseObject objectForKey:@"data"] objectForKey:@"img"] objectForKey:@"height"] floatValue] / 2;
            imageUrl   = [[[responseObject objectForKey:@"data"] objectForKey:@"img"] objectForKey:@"img"];
            
            [self createUI];
    }];
}

- (void)createUI {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"removeRechargeView" object:nil];

    
    UIView *orangeLineView = [UIView new];
    orangeLineView.frame   = CGRectMake(Adaptive(13),
                                        Adaptive(13) + NavigationBar_Height,
                                        viewWidth - Adaptive(26),
                                        viewHeight - NavigationBar_Height - Adaptive(80));
    orangeLineView.layer.borderWidth = .5;
    orangeLineView.layer.borderColor = ORANGECOLOR.CGColor;
    orangeLineView.backgroundColor   = BASECOLOR;
    [self.view addSubview:orangeLineView];
    
    titleImageView       = [UIImageView new];
    titleImageView.frame = CGRectMake((orangeLineView.bounds.size.width - width) / 2, Adaptive(26), width, height);
    [titleImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    [orangeLineView addSubview:titleImageView];
    
    
    CGRect tableViewFrame = CGRectMake(Adaptive(13),
                                       CGRectGetMaxY(titleImageView.frame) + Adaptive(26),
                                       orangeLineView.bounds.size.width  - Adaptive(26),
                                       orangeLineView.bounds.size.height - CGRectGetMaxY(titleImageView.frame) - Adaptive(39));
    
    _tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.rowHeight  = Adaptive(70);
    _tableView.backgroundColor = BASECOLOR;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [orangeLineView addSubview:_tableView];
    
    
    totalPrice       = [UILabel new];
    totalPrice.frame = CGRectMake(Adaptive(35),
                                  CGRectGetMaxY(orangeLineView.frame) + (viewHeight  - CGRectGetMaxY(orangeLineView.frame) - Adaptive(20)) / 2 ,
                                  viewWidth / 2,
                                  Adaptive(20));
    totalPrice.textColor = ORANGECOLOR;
    totalPrice.font      = [UIFont fontWithName:FONT size:Adaptive(15)];
    totalPrice.attributedText = attributedString;
    [self.view addSubview:totalPrice];
    
    UIButton *payButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    payButton.frame     = CGRectMake(viewWidth - Adaptive(163),
                                     CGRectGetMaxY(orangeLineView.frame) + (viewHeight  - CGRectGetMaxY(orangeLineView.frame) - Adaptive(40)) / 2,
                                     Adaptive(150),
                                     Adaptive(40));
    payButton.backgroundColor = ORANGECOLOR;
    [payButton setTitle:@"充值" forState:UIControlStateNormal];
    [payButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    payButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    [payButton addTarget:self action:@selector(payButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:payButton];
    
    payView = [[RechargePayView alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, Adaptive(216)) viewController:self];
    
    app = [UIApplication sharedApplication].delegate;
    
    alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    alphaView.backgroundColor = BASECOLOR;
    alphaView.alpha = 0.6;
    UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    [alphaView addGestureRecognizer:tapLeftDouble];
    
}

- (void)tongzhi:(NSNotification *)notification {
    [UIView animateWithDuration:.2 animations:^{
        
        payView.frame = CGRectMake(0, viewHeight , viewWidth, Adaptive(216));
    } completion:^(BOOL finished) {
        [alphaView removeFromSuperview];
        [payView removeFromSuperview];
    }];
}


-(void)magnifyImage:(UIGestureRecognizer *)gesture
{
    
    [UIView animateWithDuration:.2 animations:^{
        
        payView.frame = CGRectMake(0, viewHeight , viewWidth, Adaptive(216));
    } completion:^(BOOL finished) {
        [alphaView removeFromSuperview];
        [payView removeFromSuperview];
    }];
}
- (void)payButtonClick:(UIButton *)button {
    
    NSNotification *notification =[NSNotification notificationWithName:@"price" object:nil userInfo:@{@"price":priceNumber,@"id":price_id,@"classNumber":classNumber}];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    [UIView animateWithDuration:.2 animations:^{
        [app.window addSubview:alphaView];
        payView.frame = CGRectMake(0, viewHeight  - Adaptive(216), viewWidth, Adaptive(216));
        [app.window addSubview:payView];
    }];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    RechargeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[RechargeCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    RechargeModel *recharge = dataArray[indexPath.row];
    
    if (index == indexPath.row) {
        cell.clickImageView.image = [UIImage imageNamed:@"pay_ring_orange"];
        cell.priceLabel.textColor = ORANGECOLOR;
        cell.classNumberLabel.textColor = ORANGECOLOR;
    } else {
        cell.clickImageView.image = [UIImage imageNamed:@"pay_ring_gry"];
        cell.priceLabel.textColor = [UIColor whiteColor];
        cell.classNumberLabel.textColor = [UIColor whiteColor];
    }
    
    cell.titleLabel.text = recharge.titleName;
    cell.priceLabel.text = [NSString stringWithFormat:@"充值 %@元",recharge.price];
    cell.classNumberLabel.text = [NSString stringWithFormat:@"含%@课时",recharge.classNumber];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RechargeModel *recharge = dataArray[indexPath.row];
    index = indexPath.row;
    NSString *priceString = [NSString stringWithFormat:@"合计：%@ 元",recharge.price];
    
    priceNumber = recharge.price;
    price_id    = recharge.type_id;
    classNumber = recharge.classNumber;
    
    
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:priceString];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:13] range:NSMakeRange(0,3)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:24] range:NSMakeRange(3,recharge.price.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:13] range:NSMakeRange(3+recharge.price.length + 1,1)];
    totalPrice.attributedText = str;
    
    [_tableView reloadData];
}



@end
