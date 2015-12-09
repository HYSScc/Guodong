//
//  contentSportViewController.m
//  私练
//
//  Created by z on 15/1/23.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "contentSportViewController.h"
#import "Commonality.h"
#import "HttpTool.h"
@interface contentSportViewController ()
@property (nonatomic,assign)CGSize size;
@end

@implementation contentSportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    self.navigationItem.titleView = [HeadComment titleLabeltext:@"我们的活动"];
    
    UIImageView * lineImage1=[UIImageView new];
    lineImage1.image=[UIImage imageNamed:@"home__line1"];
    lineImage1.frame=CGRectMake(0, 0, viewWidth, 1);
    [self.view addSubview:lineImage1];
    
    if ([self.where intValue] == 100) {
        UIBarButtonItem * button=[[UIBarButtonItem alloc]initWithTitle:@"报名" style:UIBarButtonItemStylePlain target:self action:@selector(button:)];
        self.navigationItem.rightBarButtonItem=button;
    }
    else
    {
        NSLog(@"");
    }
    [self initView];

        NSString *url = [NSString stringWithFormat:@"%@api/?method=activity.activity_detail&activity_id=%@",BASEURL,self.idstr];
        [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
    
            NSLog(@"res>>>  %@",responseObject);
            NSDictionary *dict         = [responseObject objectForKey:@"data"];
            NSString *time             = [dict objectForKey:@"time"];
            // 时间戳转时间的方法:
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateStyle:NSDateFormatterMediumStyle];
            [formatter setTimeStyle:NSDateFormatterShortStyle];
            [formatter setDateFormat:@"YYYY/MM/dd HH时"];
            NSDate *confromTimesp      = [NSDate dateWithTimeIntervalSince1970:[time intValue]];

            NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
            self.dateLabel.text        = confromTimespStr;
            self.contentLabel.text     = [dict objectForKey:@"info"];
            self.numbelLabel.text      = [NSString stringWithFormat:@"%@",[dict objectForKey:@"mobilePhone"]] ;
            self.placeLabel.text       = [dict objectForKey:@"place"];
            self.supportLabel.text     = [dict objectForKey:@"support"];
            self.amoutLabel.text       = [NSString stringWithFormat:@"%@",[dict objectForKey:@"number"]];
            self.gatherPlaceLabel.text = [dict objectForKey:@"address"];
            self.themeLabel.text       = [dict objectForKey:@"theme"];
            self.total                 = [dict objectForKey:@"total"];
            [self.image setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"img"]]];
            
             self.size = [self.contentLabel.text boundingRectWithSize:CGSizeMake(viewWidth-20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18]} context:nil].size;
            self.contentLabel.frame = CGRectMake(130, CGRectGetMaxY(self.gatherPlaceLabel.frame)+10, self.size.width, self.size.height);
            
                  } fail:^(NSError *error) {
            NSLog(@"error   %@",error);
        }];

    
    
}
-(void)initView
{
    UILabel *theme                  = [[UILabel alloc] init];
    theme.frame                     = CGRectMake(20, 40, 80, 30);
    theme.text                      = @"活动主题:";
    theme.textColor                 = [UIColor whiteColor];
    theme.font                      = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:theme];

    self.themeLabel                 = [[UILabel alloc]init];
    self.themeLabel.frame           = CGRectMake(CGRectGetMaxX(theme.frame)+10, theme.frame.origin.y, 100, 30);
    self.themeLabel.textColor       = [UIColor redColor];
    self.themeLabel.font            = [UIFont fontWithName:FONT size:20];
    [self.view addSubview:self.themeLabel];

    self.image                      = [UIImageView new];
    self.image.backgroundColor      = [UIColor colorWithRed:255/255 green:255/255 blue:255/255 alpha:.2];
    self.image.frame                = CGRectMake(viewWidth - 130, 10, 120, 120);
    self.image.layer.cornerRadius   = 30;
    self.image.layer.masksToBounds  = YES;
    [self.view addSubview:self.image];

    UILabel *time                   = [UILabel new];
    time.frame                      = CGRectMake(20, CGRectGetMaxY(self.image.frame)+10, 80, 30);
    time.textColor                  = [UIColor whiteColor];
    time.text                       = @"活动时间:";
    time.font                       = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:time];

    self.dateLabel                  = [UILabel new];
    self.dateLabel.frame            = CGRectMake(CGRectGetMaxX(time.frame)+10, time.frame.origin.y, 200, 30);
    self.dateLabel.textColor        = [UIColor whiteColor];
    self.dateLabel.font             = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:self.dateLabel];

    UILabel *lianxiren              = [UILabel new];
    lianxiren.frame                 = CGRectMake(20, CGRectGetMaxY(time.frame)+5, 120, 30);
    lianxiren.text =@"活动联系人电话:";
    lianxiren.textColor             = [UIColor whiteColor];
    lianxiren.font                  = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:lianxiren];

    self.numbelLabel                = [UILabel new];
    self.numbelLabel.frame          = CGRectMake(CGRectGetMaxX(lianxiren.frame)+10, CGRectGetMaxY(time.frame)+5, 200, 30);
    self.numbelLabel.textColor      = [UIColor whiteColor];
    self.numbelLabel.font           = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:self.numbelLabel];

    UILabel *address                = [UILabel new];
    address.frame                   = CGRectMake(20, CGRectGetMaxY(lianxiren.frame)+5, 100, 30);
    address.text                    = @"活动地点:";
    address.textColor               = [UIColor whiteColor];
    address.font                    = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:address];

    self.placeLabel                 = [UILabel new];
    self.placeLabel.frame           = CGRectMake(CGRectGetMaxX(address.frame)+10, CGRectGetMaxY(lianxiren.frame)+5, 200, 30);
    self.placeLabel.textColor       = [UIColor whiteColor];
    self.placeLabel.font            = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:self.placeLabel];

    UILabel *support                = [UILabel new];
    support.frame                   = CGRectMake(20, CGRectGetMaxY(self.placeLabel.frame)+5, 100, 30);
    support.textColor               = [UIColor whiteColor];
    support.text                    = @"活动支持:";
    support.font                    = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:support];

    self.supportLabel               = [UILabel new];
    self.supportLabel.frame         = CGRectMake(CGRectGetMaxX(support.frame)+10, CGRectGetMaxY(self.placeLabel.frame)+5, 200, 30);
    self.supportLabel.textColor     = [UIColor whiteColor];
    self.supportLabel.font          = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:self.supportLabel];

    UILabel *people                 = [UILabel new];
    people.text                     = @"活动人数:";
    people.frame                    = CGRectMake(20, CGRectGetMaxY(self.supportLabel.frame)+5, 100, 30);
    people.textColor                = [UIColor whiteColor];
    people.font                     = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:people];

    self.amoutLabel                 = [UILabel new];
    self.amoutLabel.frame           = CGRectMake(CGRectGetMaxX(people.frame)+10, CGRectGetMaxY(self.supportLabel.frame)+5, 200, 30);
    self.amoutLabel.textColor       = [UIColor whiteColor];
    self.amoutLabel.font            = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:self.amoutLabel];


    UILabel *JHaddress              = [UILabel new];
    JHaddress.frame                 = CGRectMake(20, CGRectGetMaxY(self.amoutLabel.frame)+5, 100, 30);
    JHaddress.text                  = @"集合地点:";
    JHaddress.textColor             = [UIColor whiteColor];
    JHaddress.font                  = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:JHaddress];

    self.gatherPlaceLabel           = [UILabel new];
    self.gatherPlaceLabel.frame     = CGRectMake(CGRectGetMaxX(JHaddress.frame)+10, CGRectGetMaxY(self.amoutLabel.frame)+5, 200, 30);
    self.gatherPlaceLabel.textColor = [UIColor whiteColor];
    self.gatherPlaceLabel.font      = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:self.gatherPlaceLabel];

    UILabel *huodong                = [UILabel new];
    huodong.frame                   = CGRectMake(20, CGRectGetMaxY(self.gatherPlaceLabel.frame)+5, 100, 30);
    huodong.text                    = @"活动简介:";
    huodong.textColor               = [UIColor whiteColor];
    huodong.font                    = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:huodong];

    self.contentLabel               = [UILabel new];

    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = 0;


    //self.contentLabel.frame = CGRectMake(CGRectGetMaxX(huodong.frame)+10, CGRectGetMaxY(self.gatherPlaceLabel.frame)+5, viewWidth -(CGRectGetMaxX(huodong.frame)+10)  , viewHeight - CGRectGetMaxY(huodong.frame));
    self.contentLabel.textColor     = [UIColor whiteColor];
    self.contentLabel.font          = [UIFont fontWithName:FONT size:16];
    [self.view addSubview:self.contentLabel];
}

-(void)button:(UIButton *)button
{
    NSLog(@"点击了报名按钮");
    //http://10.0.1.20/api/?method=activity.signup&activity_id=3
    NSString *url = [NSString stringWithFormat:@"%@api/?method=activity.signup&activity_id=%@",BASEURL,self.idstr];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        NSLog(@"respon  >>>>>>   %@",responseObject);
        NSString *msg = [responseObject objectForKey:@"msg"];
        if ([msg isEqualToString:@"ok"]) {
            msg = @"报名成功";
        }
      
        [HeadComment showAlert:@"温馨提示" withMessage:msg delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    } fail:^(NSError *error) {
        NSLog(@"error  %@",error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
