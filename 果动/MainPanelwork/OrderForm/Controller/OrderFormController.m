//
//  OrderFormController.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "OrderFormController.h"
#import "Commonality.h"
#import "HttpTool.h"
#import "OrderComment.h"
#import "HomeController.h"
#import "LoginViewController.h"
#import "OrderFormController.h"
#import "TableViewCell_total.h"
#import "AppDelegate.h"

#import "MainController.h"
@interface OrderFormController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    NSMutableArray *orderArray;
    UITableView *_tableView;
    UIImageView *image;
    UIImageView * image2;
    BOOL isshang;
    int isopen;
    UIView *classBaseView;
    UIImageView *classImageView;
    UIView *classView;
    NSArray *data;
    NSString *url;
    NSMutableAttributedString *str;
    TableViewCell_total *cell_total;
    UILabel *noMoneyLabelTop;
    UILabel* noMoneyLabel;
    UIButton *shareButton;
    UIView *alphaView;
}
@property (nonatomic,strong ) UILabel        * coachName;
@property (nonatomic,strong ) UILabel        * coachPhone;
@property (nonatomic,strong ) UILabel        * coachIdentificationCode;
@property (nonatomic,strong ) UILabel        * coachSexy;
@property (nonatomic,strong ) UILabel        * course;
@property (nonatomic,strong ) UILabel        * time;
@property (nonatomic,strong ) UILabel        * orderNumber;
@property (nonatomic,strong ) UILabel        * userName;
@property (nonatomic,strong ) UILabel        * userPhone;
@property (nonatomic,strong ) UILabel        * userLocation;
@property (nonatomic,strong ) UIImageView    * coachIcon;
@property (nonatomic,strong ) UIImageView    * cancelImageView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation OrderFormController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setupRefresh];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
     isshang = !isshang;
    [classImageView setImage:[UIImage imageNamed:@"dingdan_shangJT"]];
    [classView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
    self.view.alpha = 1;

}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    isopen = -1;
    self.view.backgroundColor  = BASECOLOR;
    
    alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    alphaView.backgroundColor = [UIColor blackColor];
    
    
    /***********navigationItem.titleView***********/
    
    classBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,viewHeight/8.3375, viewHeight/22.233)];
    classBaseView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = classBaseView;
    
    UILabel *titlelabel = [UILabel new];
    titlelabel.text = @"订单";
    titlelabel.textAlignment = 1;
    titlelabel.font=[UIFont fontWithName: FONT size:viewHeight/37.056];
    titlelabel.frame=CGRectMake(viewHeight/66.7, 0, viewHeight/13.34, viewHeight/22.233);
    [titlelabel setTextColor:[UIColor colorWithRed:235.00/255 green:117.00/255 blue:32.00/255 alpha:1]];
    [classBaseView addSubview:titlelabel];
    
    classImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titlelabel.frame), (classBaseView.frame.size.height - viewHeight/111.167)/2, viewHeight/66.7, viewHeight/111.167)];
    [classImageView setImage:[UIImage imageNamed:@"dingdan_shangJT"]];
    [classBaseView addSubview:classImageView];
    
    
    UIButton *classButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classButton.frame = CGRectMake(0, 0,viewHeight/8.3375, viewHeight/22.233);
    [classButton addTarget:self action:@selector(classButton:) forControlEvents:UIControlEventTouchUpInside];
    [classBaseView addSubview:classButton];
    
    //此处的数字不适配   nav高度为64不变
    classView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth/2-viewHeight/6.67, 55, viewHeight/3.335, 210)];
    classView.backgroundColor = [UIColor clearColor];
    classView.userInteractionEnabled = YES;
    
    UIImageView *classViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, classView.frame.size.width, classView.frame.size.height)];
    [classViewImage setImage:[UIImage imageNamed:@"dingdan_classView"]];
    classViewImage.userInteractionEnabled = YES;
    [classView addSubview:classViewImage];
    
    /***********navigationItem.titleView***********/
    
    //上面的线
    UIImageView * lineImage1 = [UIImageView new];
    lineImage1.image = [UIImage imageNamed:@"home__line1"];
    lineImage1.frame = CGRectMake(0, 0, viewWidth, 0.5);
    [self.view addSubview:lineImage1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,1 , self.view.bounds.size.width,self.view.bounds.size.height-64-50) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdan_no"]];
    image.frame = CGRectMake((viewWidth -65)/2, 117.5, 65, 87.5);
    
    noMoneyLabelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetMaxY(image.frame) + viewHeight/33.35), viewWidth, viewHeight/33.35)];
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

  
    [self setupRefresh];
    url = [NSString stringWithFormat:@"%@api/?method=gdcourse.order",BASEURL];
    
}
-(void)classButton:(UIButton *)button
{
    NSString * hturl = [NSString stringWithFormat:@"%@api/?method=gdcourse.order_class",BASEURL];
    [HttpTool postWithUrl:hturl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            data = [responseObject objectForKey:@"data"];
            NSMutableArray *nameArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *numberArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *class_idArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dict in data) {
                [nameArray addObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]]];
                [numberArray addObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"num"]]];
                [class_idArray addObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"class_id"]]];
            }
            for (int a = 0; a < data.count; a++) {
                // 60+a*50
                CGFloat height = (classView.bounds.size.height-viewHeight/66.7)/data.count;
                NSLog(@"height  %f",height);
                
                UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/66.7,viewHeight/78.471+(a+1)* height, classView.bounds.size.width-viewHeight/33.35, .5)];
                line.backgroundColor = [UIColor lightGrayColor];
                [classView addSubview:line];
                
                
                UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/44.467, viewHeight/66.7 +(height-viewHeight/22.233)/2 + a*height, viewHeight/6.67, viewHeight/22.233)];
                contentLabel.text = nameArray[a];
                contentLabel.textColor = [UIColor grayColor];
                contentLabel.font = [UIFont fontWithName:FONT size:16];
                [classView addSubview:contentLabel];
                
                UILabel *classNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(classView.frame.size.width - viewHeight/8.3375, viewHeight/66.7 +(height-viewHeight/22.233)/2 + a*height, viewHeight/10.262, viewHeight/22.233)];
                classNumberLabel.textColor = [UIColor lightGrayColor];
                classNumberLabel.textAlignment = 2;
                classNumberLabel.font = [UIFont fontWithName:FONT size:viewHeight/51.308];
                classNumberLabel.text =  [NSString stringWithFormat:@"%@单",numberArray[a]];
                [classView addSubview:classNumberLabel];
                
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
                button.frame = CGRectMake(0, viewHeight/66.7 + a*height, classView.bounds.size.width, height);
                button.tag = 9*a+9;
                [button addTarget:self action:@selector(changeClassButton:) forControlEvents:UIControlEventTouchUpInside];
                [classView addSubview:button];
            }
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError *error) {}];
    
    isshang = !isshang;
    if (isshang) {
        [classImageView setImage:[UIImage imageNamed:@"dingdan_xiaJT"]];
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        [app.window addSubview:classView];
        self.view.userInteractionEnabled = NO;
        alphaView.alpha = 0.3;
        [self.view addSubview:alphaView];
       // self.view.alpha = .2;
    }
    else
    {
        [classImageView setImage:[UIImage imageNamed:@"dingdan_shangJT"]];
        [classView removeFromSuperview];
        self.view.userInteractionEnabled = YES;
        alphaView.alpha = 1;
        [alphaView removeFromSuperview];
    }
}
-(void)shareButton
{
    MainController *main = [MainController new];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = main;

}
-(void)changeClassButton:(UIButton *)button
{
    NSLog(@"TAg   %ld",(long)button.tag);
    isshang = NO;
    [classImageView setImage:[UIImage imageNamed:@"dingdan_shangJT"]];
    [classView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
   [alphaView removeFromSuperview];
    
    if (button.tag == 9) {
        url = [NSString stringWithFormat:@"%@api/?method=gdcourse.order",BASEURL];
        [self headerRereshing];
    }
    else
    {
        url = [NSString stringWithFormat:@"%@api/?method=gdcourse.order&class_id=%ld",BASEURL,button.tag/9-1];
        [self headerRereshing];
    }
}
-(void)setupRefresh
{
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_tableView headerBeginRefreshing];
    _tableView.headerPullToRefreshText = HEADERPULLTOREFRESH;
    _tableView.headerReleaseToRefreshText = HEADERRELEASETOREFRESH;
    _tableView.headerRefreshingText = HEADERREFRESHING;
}
-(void)headerRereshing
{
   
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
       
        if (ResponseObject_RC == 0)
        {
            NSDictionary *dict = [responseObject objectForKey:@"data"];
            NSArray *order_info = [dict objectForKey:@"order_info"];
            
            if (order_info.count == 0) {
                //没有订单
                
                [orderArray removeAllObjects];
                [_tableView addSubview:image];
                [_tableView addSubview:noMoneyLabelTop];
                [_tableView addSubview:noMoneyLabel];
                [_tableView addSubview:shareButton];
              //  [_tableView addSubview:image2];
                [_tableView reloadData];
            }
            else
            {   //有订单
                [image removeFromSuperview];
                [noMoneyLabelTop removeFromSuperview];
                [noMoneyLabel removeFromSuperview];
                [shareButton removeFromSuperview];
               // [image2 removeFromSuperview];
                
                orderArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dict in order_info) {
                    OrderComment *order = [[OrderComment alloc] initWithDictionary:dict];
                    [orderArray addObject:order];
                }
                
                [_tableView reloadData];
            }
            [_tableView headerEndRefreshing];
        } else if (ResponseObject_RC == NotLogin_RC_Number) {
            [HeadComment message:@"您还没有登录呢！" delegate:self witchCancelButtonTitle:@"暂不" otherButtonTitles:@"去登录", nil];
        } else {
           [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError *error) {}];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier_total = @"Cell_total";
    
    cell_total = [tableView dequeueReusableCellWithIdentifier:cellIdentifier_total];
    if (!cell_total)
    {
        cell_total = [[TableViewCell_total alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier_total];
        cell_total.selectionStyle = UITableViewCellSelectionStyleNone;
        cell_total.userInteractionEnabled = YES;
    }
    
    cell_total.jiantouButton.tag = indexPath.row;
    [cell_total.jiantouButton addTarget:self action:@selector(opencontent:) forControlEvents:UIControlEventTouchUpInside];
    OrderComment *order = [orderArray objectAtIndex:indexPath.row];
    
    //下单时间
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY/MM/dd "];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[order.create_time intValue]];
    // NSLog(@"1111111  = %@",confromTimesp);
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    cell_total.dateLabel.text = confromTimespStr;
    
    //预订的课程
    str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预订%@＊1节",order.course]];
    
    //状态
    cell_total.statusLabel.text = order.status;
    if ([order.gd_status intValue] == 3 || [order.gd_status intValue] == 4) {
        cell_total.statusLabel.textColor = [UIColor grayColor];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(2,order.course.length)];
    }
    else
    {
        cell_total.statusLabel.textColor = [UIColor colorWithRed:235.00/255 green:117.00/255 blue:32.00/255 alpha:1];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:235.00/255 green:117.00/255 blue:32.00/255 alpha:1] range:NSMakeRange(2,order.course.length)];
    }
    //预订的课程
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,2)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(2+order.course.length,3)];
    //一个label不同颜色不同字体显示 NSMakeRange(*,*)  位置 长度
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight/39.235] range:NSMakeRange(0,2)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight/39.235] range:NSMakeRange(2,order.course.length)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:viewHeight/60.636] range:NSMakeRange(2+order.course.length,3)];
    cell_total.classLabel.attributedText = str;
    

    
    //订单详情 - 学员名字
    cell_total.name.text = order.name;
    
    //----订课时间
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateStyle:NSDateFormatterMediumStyle];
    [formatter1 setTimeStyle:NSDateFormatterShortStyle];
    [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSDate *confromTimesp1 = [NSDate dateWithTimeIntervalSince1970:[order.pre_time intValue]];
    NSString *confromTimespStr1 = [formatter1 stringFromDate:confromTimesp1];
    cell_total.datetime.text = confromTimespStr1;
    
    //电话号码
    cell_total.number.text = order.number;
    
    //地址
    NSLog(@"地址 %@",order.place);
    cell_total.address.text = order.place;
    NSLog(@"cell地址 %@",cell_total.address.text);
    
    if (order.coach_info.count == 0)
    {
        NSLog(@"字典为空");
        
    }
    else
    {
        //接单
        //教练名字
        
        [cell_total.ccView addSubview:cell_total.coachView];
        cell_total.coachName.text = order.coachName;
        CGRect newframe = cell_total.ccView.frame;
        newframe.size.height = viewHeight/3.335;
        cell_total.ccView.frame = newframe;
      
        
        //性别
        NSLog(@"order.sex  %@",order.sex);
        if ([order.sex intValue] == 1) {
            cell_total.coachSex.text = @"男";
        }
        else
        {
            cell_total.coachSex.text = @"女";
        }
        
        //负责课程
        cell_total.coachClass.text = order.coachClass;
       
        
        
        //头像
     
        NSLog(@"教练头像 %@",order.headimg);
       
        [cell_total.coachImg setImageWithURL:[NSURL URLWithString:order.headimg] placeholderImage:[UIImage imageNamed:@"教练头像"] success:^(UIImage *image, BOOL cached) {
           // NSLog(@"cached  %d",cached);
        } failure:^(NSError *error) {
            // NSLog(@"error  %@",error);
        }];
        
    }
    if (isopen == indexPath.row) {
        [cell_total.nextImageView setImage:[UIImage imageNamed:@"dingdan_cellxia"]];
        [cell_total addSubview:cell_total.ccView];
    }
    else
    {
        [cell_total.nextImageView setImage:[UIImage imageNamed:@"dingdan_cellshang"]];
        [cell_total.ccView removeFromSuperview];
    }
    
    return cell_total;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderComment *order = [orderArray objectAtIndex:indexPath.row];
    
    if (isopen == indexPath.row) {
        if (order.coach_info.count == 0)
        {
            return viewHeight/3.511;
        }
        else
        {
            return viewHeight/2.4704;
        }
    }else{
        return viewHeight/9.529;
    }
}
-(void)opencontent:(UIButton *)button
{
    if (isopen != button.tag) {
        isopen = (int)button.tag;
    }
    else
    {
        isopen = -1;
    }
    [_tableView reloadData];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}
@end
