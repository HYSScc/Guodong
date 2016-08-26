//
//  CustomView.m
//  果动
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "CustomView.h"

#import "OrderViewController.h"
#import "DataViewController.h"
#import "NewsViewController.h"
#import "PublishViewController.h"
#import "DairyViewController.h"
#import "MoneyViewController.h"
#import "FeedbackViewController.h"

@implementation CustomView {
    UIViewController *viewController;
    NSString *user_id;
    NSString *nickName;
    NSString *haveNews;
    UILabel *newsLabel;
    NSInteger number;
}

- (instancetype)initWithFrame:(CGRect)frame titleImage:(UIImage *)image title:(NSString *)title buttontag:(NSInteger)tag viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        
        viewController = controller;
        number = tag;
        newsLabel = [UILabel new];
        newsLabel.frame    = CGRectMake(Adaptive(110), (Adaptive(43) - Adaptive(20)) / 2, Adaptive(10), Adaptive(10));
        newsLabel.layer.cornerRadius  = newsLabel.frame.size.width / 2;
        newsLabel.layer.masksToBounds = YES;
        newsLabel.backgroundColor     = [UIColor colorWithRed:244/255.0 green:53/255.0 blue:48/255.0 alpha:1];
        
        self.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
        [self createUIWithImage:image titleString:title buttontag:tag];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(markTopView:) name:@"Custom" object:nil];
    }
    return self;
}
- (void)markTopView:(NSNotification *)notification {
    user_id  = [notification.userInfo objectForKey:@"user"];
    nickName = [notification.userInfo objectForKey:@"nickName"];
    haveNews = [notification.userInfo objectForKey:@"haveNews"];
    
    if ([haveNews intValue] != 0  && (int)number == 12) {
        [self addSubview:newsLabel];
    } else {
        [newsLabel removeFromSuperview];
    }
}

- (void) createUIWithImage:(UIImage *)image titleString:(NSString *)string buttontag:(NSInteger)tag {
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];
    
    switch (tag) {
        case 10:
            imageView.frame = CGRectMake(Adaptive(13),
                                         (Adaptive(43) - Adaptive(17.5)) / 2,
                                         Adaptive(13),
                                         Adaptive(17.5));
            break;
        case 11:
            imageView.frame = CGRectMake(Adaptive(13),
                                         (Adaptive(43) - Adaptive(11.5)) / 2,
                                         Adaptive(18.5),
                                         Adaptive(11.5));
            break;
        case 12:
        {
            imageView.frame = CGRectMake(Adaptive(13),
                                         (Adaptive(43) - Adaptive(17.5)) / 2,
                                         Adaptive(15),
                                         Adaptive(17.5));
        }
            break;
        case 13:
            imageView.frame = CGRectMake(Adaptive(13),
                                         (Adaptive(43) - Adaptive(18)) / 2,
                                         Adaptive(14.5),
                                         Adaptive(18));
            break;
        case 14:
            imageView.frame = CGRectMake(Adaptive(13),
                                         (Adaptive(43) - Adaptive(17.5)) / 2,
                                         Adaptive(17.5),
                                         Adaptive(17.5));
            break;
        case 15:
            imageView.frame = CGRectMake(Adaptive(13),
                                         (Adaptive(43) - Adaptive(17.5)) / 2,
                                         Adaptive(13),
                                         Adaptive(17.5));
            break;
        case 16:
            imageView.frame = CGRectMake(Adaptive(13),
                                         (Adaptive(43) - Adaptive(11.5)) / 2,
                                         Adaptive(18.5),
                                         Adaptive(11.5));
            break;
            
        default:
            break;
    }
    
    UILabel *label = [UILabel new];
    label.frame    = CGRectMake(Adaptive(44),
                                (Adaptive(43) - Adaptive(20)) / 2,
                                Adaptive(100),
                                Adaptive(20));
    label.font      = [UIFont fontWithName:FONT size:Adaptive(15)];
    label.textColor = [UIColor whiteColor];
    label.text      = string;
    [self addSubview:label];
    
    
    UIImageView *triangleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"person_rightArrow"]];
    triangleImage.frame        = CGRectMake(viewWidth - Adaptive(13) - Adaptive(9),
                                            (Adaptive(43) - Adaptive(15.5)) / 2,
                                            Adaptive(9),
                                            Adaptive(15.5));
    [self addSubview:triangleImage];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.tag       = tag;
    button.frame     = CGRectMake(0, 0, viewWidth, Adaptive(43));
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
}

- (void)buttonClick:(UIButton *)button {
    
    switch (button.tag) {
        case 10:
        {
            viewController.hidesBottomBarWhenPushed          = YES;
            OrderViewController *order = [OrderViewController new];
            [viewController.navigationController pushViewController:order animated:YES];
            viewController.hidesBottomBarWhenPushed          = NO;
        }
            break;
        case 11:
        {
            viewController.hidesBottomBarWhenPushed          = YES;
            DataViewController *data = [DataViewController new];
            data.userName = nickName;
            [viewController.navigationController pushViewController:data animated:YES];
            viewController.hidesBottomBarWhenPushed          = NO;
        }
            break;
        case 12:
        {
            viewController.hidesBottomBarWhenPushed          = YES;
            NewsViewController *news = [NewsViewController new];
            [viewController.navigationController pushViewController:news animated:YES];
            viewController.hidesBottomBarWhenPushed          = NO;
        }
            break;
        case 13:
        {   viewController.hidesBottomBarWhenPushed          = YES;
            PublishViewController *publish = [PublishViewController new];
            publish.user_id = user_id;
            publish.className = @"我的发布";
            [viewController.navigationController pushViewController:publish animated:YES];
            viewController.hidesBottomBarWhenPushed          = NO;
        }
            break;
        case 14:
        {
            viewController.hidesBottomBarWhenPushed          = YES;
            DairyViewController *dairy = [DairyViewController new];
            dairy.nickName = nickName;
            [viewController.navigationController pushViewController:dairy animated:YES];
            viewController.hidesBottomBarWhenPushed          = NO;
        }
            break;
        case 15:
        {   viewController.hidesBottomBarWhenPushed          = YES;
            MoneyViewController *money = [MoneyViewController new];
            [viewController.navigationController pushViewController:money animated:YES];
             viewController.hidesBottomBarWhenPushed          = NO;
        }
            break;
        case 16:
        {
            viewController.hidesBottomBarWhenPushed          = YES;
            FeedbackViewController *feedback = [FeedbackViewController new];
            [viewController.navigationController pushViewController:feedback animated:YES];
             viewController.hidesBottomBarWhenPushed          = NO;
        }
            break;
            
        default:
            break;
    }
}

@end
