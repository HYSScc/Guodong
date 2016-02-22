//
//  JWNavigationController.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "JWNavigationController.h"

@interface JWNavigationController ()

@end

@implementation JWNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINavigationBar  *nacbar = [UINavigationBar appearance];
  //  nacbar.backgroundColor = BASECOLOR;
    [nacbar setBackgroundImage:[UIImage imageNamed:@"nav"] forBarMetrics:UIBarMetricsDefault];
    
    [nacbar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
      self.navigationBar.tintColor = [UIColor whiteColor];
    
}
@end
