//
//  OrderFormController.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeController.h"
#import "LoginViewController.h"
#import "OrderComment.h"
#import "OrderFormController.h"
#import "TableViewCell_total.h"
#import "UserFeedbackController.h"
#import "MainController.h"

@interface OrderFormController () <UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate> {
    NSMutableArray* orderArray;
    UITableView* _tableView;
    UIImageView* image;
    UIImageView* image2;
    BOOL isshang;
    int isopen;
    NSString *order_id;
    UIView* classBaseView;
    UIImageView* classImageView;
    UIView* classView;
    NSArray* data;
   
    NSString* url;
    NSMutableAttributedString* str;
    TableViewCell_total* cell_total;
    UILabel* noMoneyLabelTop;
    UILabel* noMoneyLabel;
    UIButton* shareButton;
    UIView* alphaView;
    BOOL ischargeback;
    BOOL ispackage;
   
}
@property (nonatomic, strong) UILabel* coachName;
@property (nonatomic, strong) UILabel* coachPhone;
@property (nonatomic, strong) UILabel* coachIdentificationCode;
@property (nonatomic, strong) UILabel* coachSexy;
@property (nonatomic, strong) UILabel* course;
@property (nonatomic, strong) UILabel* time;
@property (nonatomic, strong) UILabel* orderNumber;
@property (nonatomic, strong) UILabel* userName;
@property (nonatomic, strong) UILabel* userPhone;
@property (nonatomic, strong) UILabel* userLocation;
@property (nonatomic, strong) UIImageView* coachIcon;
@property (nonatomic, strong) UIImageView* cancelImageView;
@property (nonatomic, strong) NSMutableArray* dataSource;
@end

@implementation OrderFormController
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self setupRefresh];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    isshang = !isshang;
    [classImageView setImage:[UIImage imageNamed:@"dingdan_shangJT"]];
    [classView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
    self.view.alpha = 1;
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    isopen = -1;
    ispackage = NO;
    self.view.backgroundColor = BASECOLOR;
    
    alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    alphaView.backgroundColor = [UIColor blackColor];
    
    /***********navigationItem.titleView***********/
    
    classBaseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Adaptive(80), Adaptive(30))];
    classBaseView.backgroundColor = [UIColor clearColor];
    self.navigationItem.titleView = classBaseView;
    
    UILabel* titlelabel = [UILabel new];
    titlelabel.text = @"订单";
    titlelabel.textAlignment = 1;
    titlelabel.font = [UIFont fontWithName:FONT size:Adaptive(18)];
    titlelabel.frame = CGRectMake(viewHeight / 66.7, 0,Adaptive(50), Adaptive(30));
    [titlelabel setTextColor:[UIColor colorWithRed:235.00 / 255 green:117.00 / 255 blue:32.00 / 255 alpha:1]];
    [classBaseView addSubview:titlelabel];
    
    classImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titlelabel.frame), (classBaseView.frame.size.height - Adaptive(6)) / 2,Adaptive(10),Adaptive(6))];
    [classImageView setImage:[UIImage imageNamed:@"dingdan_shangJT"]];
    [classBaseView addSubview:classImageView];
    
    UIButton* classButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classButton.frame = CGRectMake(0, 0, Adaptive(80), Adaptive(30));
    [classButton addTarget:self action:@selector(classButton:) forControlEvents:UIControlEventTouchUpInside];
    [classBaseView addSubview:classButton];
    
    //此处的数字不适配   nav高度为64不变
    classView = [[UIView alloc] initWithFrame:CGRectMake(viewWidth / 2 - Adaptive(100), 55, Adaptive(200), 210)];
    classView.backgroundColor = [UIColor clearColor];
    classView.userInteractionEnabled = YES;
    
    
    
    /***********navigationItem.titleView***********/
    
    //上面的线
    UIImageView* lineImage1 = [UIImageView new];
    lineImage1.image = [UIImage imageNamed:@"home__line1"];
    lineImage1.frame = CGRectMake(0, 0, viewWidth, 0.5);
    [self.view addSubview:lineImage1];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, self.view.bounds.size.width, self.view.bounds.size.height - NavigationBar_Height - Tabbar_Height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dingdan_no"]];
    image.frame = CGRectMake((viewWidth - 65) / 2, 117.5, 65, 87.5);
    
    noMoneyLabelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, (CGRectGetMaxY(image.frame) + Adaptive(20)), viewWidth, Adaptive(20))];
    noMoneyLabelTop.textColor = [UIColor whiteColor];
    noMoneyLabelTop.text = @"您还没有订单噢...";
    noMoneyLabelTop.textAlignment = 1;
    noMoneyLabelTop.font = [UIFont fontWithName:FONT size:Adaptive(20)];
    
    noMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(noMoneyLabelTop.frame) + Adaptive(12.5), viewWidth, Adaptive(15))];
    noMoneyLabel.textColor = [UIColor colorWithRed:94 / 255.0 green:94 / 255.0 blue:94 / 255.0 alpha:1];
    noMoneyLabel.text = @"赶快召唤我们的教练吧!";
    noMoneyLabel.textAlignment = 1;
    noMoneyLabel.font = [UIFont fontWithName:FONT size:Adaptive(15)];
    
    shareButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareButton.frame = CGRectMake((viewWidth - Adaptive(99)) / 2, CGRectGetMaxY(noMoneyLabel.frame) + Adaptive(25), Adaptive(99), Adaptive(30));
    [shareButton setBackgroundImage:[UIImage imageNamed:@"money_dingke"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButton) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupRefresh];
    url = [NSString stringWithFormat:@"%@api/?method=gdcourse.order", BASEURL];
}
- (void)classButton:(UIButton*)button
{
    UIImageView* classViewImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, classView.frame.size.width, classView.frame.size.height)];
    [classViewImage setImage:[UIImage imageNamed:@"dingdan_classView"]];
    classViewImage.userInteractionEnabled = YES;
    [classView addSubview:classViewImage];
    
    NSString* hturl = [NSString stringWithFormat:@"%@api/?method=gdcourse.order_class", BASEURL];
    [HttpTool postWithUrl:hturl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            data = [responseObject objectForKey:@"data"];
            NSMutableArray* nameArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray* numberArray = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray* class_idArray = [[NSMutableArray alloc] initWithCapacity:0];
             NSMutableArray* typesArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary* dict in data) {
                [nameArray addObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"name"]]];
                [numberArray addObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"num"]]];
                [class_idArray addObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"class_id"]]];
                [typesArray addObject:[NSString stringWithFormat:@"%@", [dict objectForKey:@"type"]]];
            }
            
            
            
            for (int a = 0; a < data.count; a++) {
                CGFloat height = (classView.bounds.size.height - Adaptive(10)) / data.count;
        
                UILabel* classViewline = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(10), Adaptive(8.5) + (a + 1) * height, classView.bounds.size.width - Adaptive(20), .5)];
                
                classViewline.backgroundColor = [UIColor lightGrayColor];
                [classView addSubview:classViewline];
                
                UILabel* contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(15), Adaptive(10) + (height - Adaptive(30)) / 2 + a * height, Adaptive(100), Adaptive(30))];
                contentLabel.text = nameArray[a];
                contentLabel.textColor = [UIColor grayColor];
                contentLabel.font = [UIFont fontWithName:FONT size:Adaptive(16)];
                [classView addSubview:contentLabel];
                
                UILabel* classNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(classView.frame.size.width - Adaptive(80), Adaptive(10) + (height - Adaptive(30)) / 2 + a * height, Adaptive(65), Adaptive(30))];
                classNumberLabel.textColor = [UIColor lightGrayColor];
                classNumberLabel.textAlignment = 2;
                classNumberLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
                classNumberLabel.text = [NSString stringWithFormat:@"%@单", numberArray[a]];
                [classView addSubview:classNumberLabel];
                
                SHButton* button = [SHButton buttonWithType:UIButtonTypeSystem];
                button.frame     = CGRectMake(0, Adaptive(10) + a * height, classView.bounds.size.width, height);
                button.tag       = 9 * a + 9;
                button.types     = typesArray[a];
                [button addTarget:self action:@selector(changeClassButton:) forControlEvents:UIControlEventTouchUpInside];
                [classView addSubview:button];
                NSLog(@"button.types %@",button.types);
            }
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }}fail:^(NSError* error){}];
    
    isshang = !isshang;
    
    if (isshang) {
        [classImageView setImage:[UIImage imageNamed:@"dingdan_xiaJT"]];
        AppDelegate* app = [UIApplication sharedApplication].delegate;
        [app.window addSubview:classView];
        self.view.userInteractionEnabled = NO;
        alphaView.alpha = 0.3;
        [self.view addSubview:alphaView];
    } else {
        [classImageView setImage:[UIImage imageNamed:@"dingdan_shangJT"]];
        [classView removeFromSuperview];
        [classView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];//移除所有子视图
        self.view.userInteractionEnabled = YES;
        alphaView.alpha = 1;
        [alphaView removeFromSuperview];
    }
}
- (void)shareButton
{
    MainController* main = [MainController new];
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = main;
}
- (void)changeClassButton:(SHButton*)button
{
    NSLog(@"TAg   %ld", (long)button.tag);
    isshang = NO;
    [classImageView setImage:[UIImage imageNamed:@"dingdan_shangJT"]];
    [classView removeFromSuperview];
    self.view.userInteractionEnabled = YES;
    [alphaView removeFromSuperview];
    
    if ([button.types isEqualToString:@"gd"]) {
        ispackage = NO;
        if (button.tag == 9) {
            url = [NSString stringWithFormat:@"%@api/?method=gdcourse.order", BASEURL];
            [self headerRereshing];
        }
        else {
            url = [NSString stringWithFormat:@"%@api/?method=gdcourse.order&class_id=%ld", BASEURL, button.tag / 9 - 1];
            [self headerRereshing];
        }
    } else {
        NSLog(@"套餐");
        url       = [NSString stringWithFormat:@"%@api/?method=package.package_order", BASEURL];
        ispackage = YES;
        [self headerRereshing];
    }
    
   
}
- (void)setupRefresh
{
    //下拉刷新
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    [_tableView headerBeginRefreshing];
    _tableView.headerPullToRefreshText = HEADERPULLTOREFRESH;
    _tableView.headerReleaseToRefreshText = HEADERRELEASETOREFRESH;
    _tableView.headerRefreshingText = HEADERREFRESHING;
}
- (void)headerRereshing
{
    
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        
        if (ResponseObject_RC == 0) {
            NSDictionary* dict = [responseObject objectForKey:@"data"];
            NSArray* order_info = [dict objectForKey:@"order_info"];
            
          //  NSArray *packageArray = [dict objectForKey:@"package"];
            
            if (order_info.count == 0) {
                // 没有订单
                
                [orderArray removeAllObjects];
                [_tableView addSubview:image];
                [_tableView addSubview:noMoneyLabelTop];
                [_tableView addSubview:noMoneyLabel];
                [_tableView addSubview:shareButton];
               
                [_tableView reloadData];
            } else {
                // 有订单
                [image removeFromSuperview];
                [noMoneyLabelTop removeFromSuperview];
                [noMoneyLabel removeFromSuperview];
                [shareButton removeFromSuperview];
                
                
                orderArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary* dict in order_info) {
                    OrderComment* order = [[OrderComment alloc] initWithDictionary:dict];
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
    }fail:^(NSError* error){}];
}

//设置某个区中有多少行
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return orderArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    OrderComment* order = [orderArray objectAtIndex:indexPath.row];
    
    //还没教练接单的时候
    if (order.coach_info.count == 0){
        cell_total = [tableView dequeueReusableCellWithIdentifier:@"Cell_total"];
        if (!cell_total) {
            cell_total = [[TableViewCell_total alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_total"];
            cell_total.selectionStyle = UITableViewCellSelectionStyleNone;
            cell_total.userInteractionEnabled = YES;
        }
        
        cell_total.jiantouButton.tag = indexPath.row;
        [cell_total.jiantouButton addTarget:self action:@selector(opencontent:) forControlEvents:UIControlEventTouchUpInside];
        //下单时间
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY/MM/dd "];
        NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:[order.create_time intValue]];
        NSString* confromTimespStr = [formatter stringFromDate:confromTimesp];
        cell_total.dateLabel.text = confromTimespStr;
        
        if (ispackage == YES) {
            
            str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预订%@＊第%@/%@节", order.course,order.cur,order.total]];
            //预订的课程
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(2 + order.course.length, 4 + order.cur.length + order.total.length)];
            //一个label不同颜色不同字体显示 NSMakeRange(*,*)  位置 长度
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight / 39.235] range:NSMakeRange(0, 2)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight / 39.235] range:NSMakeRange(2, order.course.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(11)] range:NSMakeRange(2 + order.course.length, 4 + order.cur.length + order.total.length)];
           
        } else {
           
            
            str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预订%@＊1节", order.course]];
            //预订的课程
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(2 + order.course.length, 3)];
            //一个label不同颜色不同字体显示 NSMakeRange(*,*)  位置 长度
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight / 39.235] range:NSMakeRange(0, 2)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight / 39.235] range:NSMakeRange(2, order.course.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(11)] range:NSMakeRange(2 + order.course.length, 3)];
        }
        
        //预订的课程
        
        //状态
        cell_total.statusLabel.text = order.status;
        if ([order.gd_status intValue] == 3 || [order.gd_status intValue] == 4) {
            cell_total.statusLabel.textColor = [UIColor grayColor];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(2, order.course.length)];
        } else {
            cell_total.statusLabel.textColor = [UIColor colorWithRed:235.00 / 255 green:117.00 / 255 blue:32.00 / 255 alpha:1];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:235.00 / 255 green:117.00 / 255 blue:32.00 / 255 alpha:1] range:NSMakeRange(2, order.course.length)];
        }
        
        cell_total.classLabel.attributedText = str;
        
        //订单详情 - 学员名字
        cell_total.name.text = order.name;
        
        //----订课时间
        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateStyle:NSDateFormatterMediumStyle];
        [formatter1 setTimeStyle:NSDateFormatterShortStyle];
        [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSDate* confromTimesp1 = [NSDate dateWithTimeIntervalSince1970:[order.pre_time intValue]];
        NSString* confromTimespStr1 = [formatter1 stringFromDate:confromTimesp1];
        cell_total.datetime.text = confromTimespStr1;
        
        //电话号码
        cell_total.number.text = order.number;
        //地址
        cell_total.address.text = order.place;
        if ([order.gd_status isEqualToString:@"1"]) {
            //退单按钮
            [cell_total.chargeback addTarget:self action:@selector(chargeback:) forControlEvents:UIControlEventTouchUpInside];
            cell_total.chargeback.tag = indexPath.row;
            [cell_total.ccView addSubview:cell_total.chargeback];
        }
       
        
        if (ischargeback == YES) {
            
            CGRect newframe = cell_total.ccView.frame;
            newframe.size.height = Adaptive(200);
            cell_total.ccView.frame = newframe;
            [cell_total.ccView addSubview:cell_total.backView];
            [cell_total.backCancelButton addTarget:self action:@selector(backCancelButton) forControlEvents:UIControlEventTouchUpInside];
            [cell_total.backSureButton addTarget:self action:@selector(backSureButton) forControlEvents:UIControlEventTouchUpInside];
            
            [cell_total.backView addSubview:cell_total.backCancelButton];
            [cell_total.backView addSubview:cell_total.backSureButton];
            
        } else {
            [cell_total.backView removeFromSuperview];
            CGRect newframe = cell_total.ccView.frame;
            newframe.size.height = Adaptive(120);
            cell_total.ccView.frame = newframe;
        }
        
        if (isopen == indexPath.row) {
            [cell_total.nextImageView setImage:[UIImage imageNamed:@"dingdan_cellxia"]];
            [cell_total addSubview:cell_total.ccView];
        } else {
            [cell_total.nextImageView setImage:[UIImage imageNamed:@"dingdan_cellshang"]];
            [cell_total.ccView removeFromSuperview];
        }
        return cell_total;
    } else {
        //教练接单
        TableViewCell_haveCoach *haveCoach = [tableView dequeueReusableCellWithIdentifier:@"Cell_coach"];
        if (!haveCoach) {
            haveCoach = [[TableViewCell_haveCoach alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell_coach"];
            haveCoach.selectionStyle = UITableViewCellSelectionStyleNone;
            haveCoach.userInteractionEnabled = YES;
        }
        /**************************************/
        haveCoach.jiantouButton.tag = indexPath.row;
        [haveCoach.jiantouButton addTarget:self action:@selector(opencontent:) forControlEvents:UIControlEventTouchUpInside];
        //下单时间
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY/MM/dd "];
        NSDate* confromTimesp = [NSDate dateWithTimeIntervalSince1970:[order.create_time intValue]];
        NSString* confromTimespStr = [formatter stringFromDate:confromTimesp];
        haveCoach.dateLabel.text = confromTimespStr;
        
        if (ispackage == YES) {
            str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预订%@＊第%@/%@节", order.course,order.cur,order.total]];
            //预订的课程
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(2 + order.course.length, 4 + order.cur.length + order.total.length)];
            //一个label不同颜色不同字体显示 NSMakeRange(*,*)  位置 长度
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight / 39.235] range:NSMakeRange(0, 2)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight / 39.235] range:NSMakeRange(2, order.course.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(11)] range:NSMakeRange(2 + order.course.length, 4 + order.cur.length + order.total.length)];
            
        } else {
            str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"预订%@＊1节", order.course]];
            //预订的课程
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(2 + order.course.length, 3)];
            //一个label不同颜色不同字体显示 NSMakeRange(*,*)  位置 长度
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight / 39.235] range:NSMakeRange(0, 2)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:viewHeight / 39.235] range:NSMakeRange(2, order.course.length)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(11)] range:NSMakeRange(2 + order.course.length, 3)];
        }
        
        //状态
        haveCoach.statusLabel.text = order.status;
        if ([order.gd_status intValue] == 3 || [order.gd_status intValue] == 4) {
            haveCoach.statusLabel.textColor = [UIColor grayColor];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(2, order.course.length)];
        } else {
            haveCoach.statusLabel.textColor = [UIColor colorWithRed:235.00 / 255 green:117.00 / 255 blue:32.00 / 255 alpha:1];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:235.00 / 255 green:117.00 / 255 blue:32.00 / 255 alpha:1] range:NSMakeRange(2, order.course.length)];
        }
       
        haveCoach.classLabel.attributedText = str;
        
        //订单详情 - 学员名字
        haveCoach.name.text = order.name;
        
        //----订课时间
        NSDateFormatter* formatter1 = [[NSDateFormatter alloc] init];
        [formatter1 setDateStyle:NSDateFormatterMediumStyle];
        [formatter1 setTimeStyle:NSDateFormatterShortStyle];
        [formatter1 setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSDate* confromTimesp1 = [NSDate dateWithTimeIntervalSince1970:[order.pre_time intValue]];
        NSString* confromTimespStr1 = [formatter1 stringFromDate:confromTimesp1];
        haveCoach.datetime.text = confromTimespStr1;
        
        //电话号码
        haveCoach.number.text = order.number;
        
        //地址
        haveCoach.address.text = order.place;
       
        
        if (isopen == indexPath.row) {
            [haveCoach.nextImageView setImage:[UIImage imageNamed:@"dingdan_cellxia"]];
            [haveCoach addSubview:haveCoach.ccView];
        } else {
            [haveCoach.nextImageView setImage:[UIImage imageNamed:@"dingdan_cellshang"]];
            [haveCoach.ccView removeFromSuperview];
        }
        /**************************************/
        CGRect newframe = haveCoach.ccView.frame;
        newframe.size.height = Adaptive(200);
        haveCoach.ccView.frame = newframe;
        //教练名字
        [haveCoach.ccView addSubview:haveCoach.coachView];
        haveCoach.coachName.text = order.coachName;
        //性别
        if ([order.sex intValue] == 1) {
            haveCoach.coachSex.text = @"男";
        } else {
            haveCoach.coachSex.text = @"女";
        }
        //负责课程
        haveCoach.coachClass.text = order.coachClass;
        //头像
        [haveCoach.coachImg setImageWithURL:[NSURL URLWithString:order.headimg] placeholderImage:[UIImage imageNamed:@"person_nohead"] success:^(UIImage* image, BOOL cached) {}failure:^(NSError* error){}];
        
        return haveCoach;
    }
}
//取消
-(void)backCancelButton
{
    ischargeback = NO;
   [self setupRefresh];
}
//确定
-(void)backSureButton
{
    ischargeback = NO;
    
    NSString *backurl = [NSString stringWithFormat:@"%@refund/?order_id=%@",BASEURL,order_id];
    [HttpTool postWithUrl:backurl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            [self setupRefresh];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"退单成功，回退款项将退回到相应的支付渠道，请及时查收！我们的不足之处望您给出宝贵的建议" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"反馈", nil];
            alert.tag = 100;
            [alert show];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError *error) {}];
}
//退单
-(void)chargeback:(UIButton*)button
{
    ischargeback = YES;
    OrderComment* order = [orderArray objectAtIndex:button.tag];
    order_id = order.order_id;
    NSLog(@"order_id %@",order_id);
    
   [self setupRefresh];
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    OrderComment* order = [orderArray objectAtIndex:indexPath.row];
    
    if (isopen == indexPath.row) {
        if (order.coach_info.count == 0) {
            if (!ischargeback) {
                return Adaptive(190);
            } else {
                return Adaptive(270);
            }
        } else {
            return Adaptive(270);
        }
    } else {
        return Adaptive(70);
    }
}
- (void)opencontent:(UIButton*)button
{
    if (isopen != button.tag) {
        isopen = (int)button.tag;
    } else {
        isopen = -1;
    }
    [_tableView reloadData];
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
// 提交编辑
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        OrderComment* order = [orderArray objectAtIndex:indexPath.row];
        
        NSString *removeUrl = [NSString stringWithFormat:@"%@api/?method=gdcourse.delete_order",BASEURL];
        NSDictionary *removeDict = @{@"order_id":order.order_id};
        [HttpTool postWithUrl:removeUrl params:removeDict contentType:CONTENTTYPE success:^(id responseObject) {
            if (ResponseObject_RC == 0) {
                
                  [orderArray removeObjectAtIndex:indexPath.row];
                // 可以删除一行  也可以删除多行
                  [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
                  [_tableView reloadData];
            } else {
                [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
            }
        } fail:^(NSError *error) {}];
    }
}

// 删除的按钮上的文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)alertView:(UIAlertView*)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:[UserFeedbackController new] animated:YES];
        }
    } else {
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:[LoginViewController new] animated:YES];
        }
    }
    
}
@end
