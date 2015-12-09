//
//  HQGZViewController.m
//  果动
//
//  Created by mac on 15/8/28.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "HQGZViewController.h"
#import "Commonality.h"

@interface HQGZViewController ()

@end

@implementation HQGZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
     self.navigationItem.titleView = [HeadComment titleLabeltext:@"获取规则"];
    BackView *backView = [[BackView alloc] initWithbacktitle:@"私房钱" viewController:self];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
        NSArray *array = @[@"1.首次分享即可获得私房钱哦!",@"2.上课累计3次,可随机获得1-100的私房钱哦!",@"3.私房钱只累计3个月,请您及时使用!",@"4.私房钱仅限APP内下单使用!",@"5.最终解释权归果动所有!"];
        for (int a = 0; a < 5; a++)
        {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, a*(viewHeight/11.117 + 1), viewWidth, viewHeight/11.117)];
          //  view.backgroundColor = [UIColor orangeColor];
            [self.view addSubview:view];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 1, viewWidth, 0.5)];
            image.image = [UIImage imageNamed:@"set_xian"];
            [view addSubview:image];
//
//            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(viewHeight/44.467, (view.bounds.size.height - viewHeight/26.68)/2, viewWidth, viewHeight/26.68)];
            label.textColor = [UIColor whiteColor];
            label.text = array[a];
            label.font = [UIFont fontWithName:FONT size:viewHeight/47.643];
            [view addSubview:label];
        }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
