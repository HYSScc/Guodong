//
//  NewsFunctionView.m
//  果动
//
//  Created by mac on 16/5/30.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ContentDetails.h"
#import "NewsFunctionView.h"
#import "MyNewsModel.h"
@implementation NewsFunctionView
{
    UILabel     *likeLabel;
    UILabel     *commentLabel;
    NSString    *talk_id;
    NSString    *classtype;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = BASEGRYCOLOR;
    
    
    for (int a = 0; a < 2; a++) {
        UILabel *line = [UILabel new];
        line.frame    = CGRectMake(((viewWidth - Adaptive(30)) / 3) * (a + 1),
                                   Adaptive(5), .5, self.bounds.size.height - Adaptive(10));
        line.backgroundColor = BASECOLOR;
        [self addSubview:line];
        
        
    }
    
    _praiseButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _praiseButton.frame = CGRectMake(0, 0, ((viewWidth - Adaptive(30)) / 3), self.bounds.size.height);
    [_praiseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_praiseButton];
    
    _commentButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _commentButton.frame = CGRectMake(((viewWidth - Adaptive(30)) / 3), 0,((viewWidth - Adaptive(30)) / 3), self.bounds.size.height);
    [self addSubview:_commentButton];
    
    
    _shareButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _shareButton.frame = CGRectMake(((viewWidth - Adaptive(30)) / 3) * 2, 0, ((viewWidth - Adaptive(30)) / 3), self.bounds.size.height);
    [self addSubview:_shareButton];
    
    
    UIImageView *moreImageView = [UIImageView new];
    moreImageView.frame        = CGRectMake(viewWidth - Adaptive((13 + 15)), Adaptive(20), Adaptive(15), Adaptive(3));
    moreImageView.image        = [UIImage imageNamed:@"find_more"];
    [self addSubview:moreImageView];
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _moreButton.frame = CGRectMake(viewWidth - Adaptive(30),
                                   0,
                                   Adaptive(30),
                                   self.bounds.size.height);
  //  _moreButton.backgroundColor = ORANGECOLOR;
    [self addSubview:_moreButton];
    
    
    NSArray *array = @[@"find_nolike",@"find_comment",@"find_share"];
    
    for (int a = 0; a < 3; a++) {
        UIImageView *imageView = [UIImageView new];
        imageView.image        = [UIImage imageNamed:array[a]];
        imageView.tag          = (a+1) * 10;
        [self addSubview:imageView];
        
        switch (a) {
            case 0:
                imageView.frame = CGRectMake((viewWidth - Adaptive(20)) / 6 - Adaptive(17),
                                             Adaptive(13),
                                             Adaptive(17),
                                             Adaptive(17));
                break;
            case 1:
                imageView.frame = CGRectMake((viewWidth - Adaptive(20)) / 2 - Adaptive(17.5),
                                             Adaptive(15),
                                             Adaptive(17.5),
                                             Adaptive(16));
                break;
            case 2:
                imageView.frame = CGRectMake(((viewWidth - Adaptive(20)) / 6) * 5 - Adaptive(17.5),
                                             Adaptive(12),
                                             Adaptive(17.5),
                                             Adaptive(19));
                break;
                
            default:
                break;
        }
    }
    
    likeLabel           = [UILabel new];
    likeLabel.frame     = CGRectMake((viewWidth - Adaptive(20)) / 6 + Adaptive(5),
                                     Adaptive(15),
                                     Adaptive(60),
                                     Adaptive(15));
    likeLabel.text      = @"15";
    likeLabel.textColor = [UIColor lightGrayColor];
    likeLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    [self addSubview:likeLabel];
    
    commentLabel       = [UILabel new];
    commentLabel.frame = CGRectMake((viewWidth - Adaptive(20)) / 2 + Adaptive(5),
                                    Adaptive(15),
                                    Adaptive(60),
                                    Adaptive(15));
    commentLabel.text      = @"20";
    commentLabel.textColor = [UIColor lightGrayColor];
    commentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    [self addSubview:commentLabel];
    
    
}

- (void)setDetails:(ContentDetails *)details {
    
    UIImageView *imageView = (UIImageView *)[self viewWithTag:10];
    
    if ([details.isPraise intValue] == 0) {
        
        imageView.image = [UIImage imageNamed:@"find_nolike"];
    } else {
        imageView.image = [UIImage imageNamed:@"find_like"];
    }
    
    likeLabel.text    = details.likeNumber;
    commentLabel.text = details.commentNumber;
    talk_id           = details.talk_id;
    classtype = @"details";
    
    
}

- (void)setNewsModel:(MyNewsModel *)newsModel {
    UIImageView *imageView = (UIImageView *)[self viewWithTag:10];
    
    if ([newsModel.ipraises intValue] == 0) {
        
        imageView.image = [UIImage imageNamed:@"find_nolike"];
        
    } else {
        
        imageView.image = [UIImage imageNamed:@"find_like"];
    }
    
    likeLabel.text    = newsModel.praises;
    commentLabel.text = newsModel.comments;
    talk_id           = newsModel.talk_id;
    classtype         = @"myNews";
}



- (void)buttonClick:(UIButton *)button {
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.praise&talkid=%@",BASEURL,talk_id];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        if ([HttpTool judgeWhetherUserLogin]) {
            if ([classtype isEqualToString:@"details"]) {
                NSNotification *notification = [NSNotification notificationWithName:@"refushNewsDetails" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } else {
                NSNotification *notification = [NSNotification notificationWithName:@"myNews" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
            
            [alert show];
        }
    }];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1) {
        NSNotification *notification =[NSNotification notificationWithName:@"pushLoginView" object:nil userInfo:nil];
        
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end
