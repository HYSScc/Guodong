//
//  My_NewsTableViewCell.m
//  果动
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "AppDelegate.h"
#import "ShareView.h"

#import "My_NewsTableViewCell.h"
#import "NewsFunctionView.h"
#import "MyNewsModel.h"
@implementation My_NewsTableViewCell
{
    UIImageView *headImageView;
    UILabel     *nickNameLabel;
    UILabel     *dateLabel;
    UILabel     *contentLabel;
    UIImageView *contentImageView;
    NewsFunctionView *functionView;
    
    NSString    *talk_idString;
    UIView      *alphaView;
    ShareView   *share;
    NSString    *nickName;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShare) name:@"removeShare" object:nil];
        self.backgroundColor = BASEGRYCOLOR;
        UILabel *lineLabel = [UILabel new];
        lineLabel.frame    = CGRectMake(0, 0, viewWidth, Adaptive(10));
        lineLabel.backgroundColor = BASECOLOR;
        [self addSubview:lineLabel];
        
        headImageView = [UIImageView new];
        headImageView.frame        = CGRectMake(Adaptive(13),
                                               CGRectGetMaxY(lineLabel.frame) + Adaptive(10),
                                                Adaptive(30),
                                                Adaptive(30));
        headImageView.layer.cornerRadius  = headImageView.bounds.size.width / 2;
        headImageView.layer.masksToBounds = YES;
        [self addSubview:headImageView];
        
        
        nickNameLabel = [UILabel new];
        nickNameLabel.frame    = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(10),
                                            Adaptive(15),
                                            Adaptive(120),
                                            Adaptive(20));
        nickNameLabel.textColor = [UIColor whiteColor];
        nickNameLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        [self addSubview:nickNameLabel];
        
        
        dateLabel = [UILabel new];
        dateLabel.frame    = CGRectMake(viewWidth -Adaptive((13 + 100)),
                                        Adaptive(18),
                                        Adaptive(100),
                                        Adaptive(15));
        dateLabel.textColor = [UIColor grayColor];
        dateLabel.font      = [UIFont fontWithName:FONT size:Adaptive(11)];
        dateLabel.textAlignment = 2;
        [self addSubview:dateLabel];
        
        
        contentLabel = [UILabel new];
        contentLabel.frame    = CGRectMake(Adaptive(13),
                                           CGRectGetMaxY(headImageView.frame) + Adaptive(5),
                                           viewWidth - Adaptive(26),
                                           Adaptive(35));
        contentLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
        contentLabel.textColor = [UIColor whiteColor];
        contentLabel.numberOfLines = 2;
        [self addSubview:contentLabel];
        
        contentImageView       = [UIImageView new];
        
        contentImageView.image = [UIImage imageNamed:@"news_result"];
        [self addSubview:contentImageView];
        
        
     
        
    }
    return self;
}

- (void)setNewsModel:(MyNewsModel *)newsModel {
    
    [headImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.headimgUrl] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    talk_idString = newsModel.talk_id;
    nickNameLabel.text = newsModel.nickName;
    dateLabel.text     = newsModel.date;
    contentLabel.text  = newsModel.content;
    
    CGFloat  getHeight = newsModel.height / 2;
    CGFloat  getWidth  = newsModel.widht / 2;
    
    contentImageView.frame        = CGRectMake(Adaptive(13),
                                               CGRectGetMaxY(contentLabel.frame) + Adaptive(5),
                                               viewWidth - Adaptive(26),
                                               ((viewWidth - Adaptive(26)) * getHeight) / getWidth);
    
    
    [contentImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.photoUrl]];
    functionView = [[NewsFunctionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(contentImageView.frame) + Adaptive(5),viewWidth,Adaptive(40))];
   
    [functionView.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [functionView.moreButton  addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    functionView.newsModel = newsModel;
    [self addSubview:functionView];
    
    
    
    
    CGRect Frame       = self.frame;
    Frame.size.height  = CGRectGetMaxY(functionView.frame) + Adaptive(5);
    self.frame         = Frame;
    
}
- (void)moreButtonClick:(UIButton *)button {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报",@"删除", nil];
    actionSheet.tag = 998;
    [actionSheet showInView:self];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 998) {
        
        if (buttonIndex == 0) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不友善行为：色情、辱骂等",@"垃圾广告、推销",@"其他", nil];
            actionSheet.tag = 1000;
            [actionSheet showInView:self];
        } else if (buttonIndex == 1) {
            NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.deletetalk&talkid=%@",BASEURL,talk_idString];
            [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress *progress) {
                
            } success:^(id responseObject) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                 target:self
                                               selector:@selector(refushAllUI:)
                                               userInfo:alert
                                                repeats:YES];
            }];
        }
    }  else {
        NSString *typeid;
        if (buttonIndex <  2) {
            typeid = [NSString stringWithFormat:@"%ld",buttonIndex + 1];
            NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.report&typeid=%@&talkid=%@",BASEURL,typeid,talk_idString];
            [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress *progress) {
                
            } success:^(id responseObject) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles: nil];
                [alert show];
                [NSTimer scheduledTimerWithTimeInterval:1.5f
                                                 target:self
                                               selector:@selector(timerFireMethod:)
                                               userInfo:alert
                                                repeats:YES];
            }];
        }
    }
}
- (void)refushAllUI:(NSTimer*)theTimer {
    
    NSNotification *notification =[NSNotification notificationWithName:@"refushAllUI" object:nil userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
}
// 提示框消失
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)shareButtonClick:(UIButton *)button {
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@usershare/?types=gdb&id=%@",BASEURL,talk_idString];
    
    NSString *title = [NSString stringWithFormat:@"%@的健身动态 - 果动",nickNameLabel.text];
    
    
    share = [[ShareView alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, Adaptive(256)) title:title imageName:contentImageView.image url:url id:talk_idString shareType:@"gdb" viewController:nil];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    alphaView = [UIView new];
    alphaView.frame           = CGRectMake(0, 0, viewWidth, viewHeight);
    alphaView.backgroundColor = BASECOLOR;
    alphaView.alpha           = .3;
    
    UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
    [alphaView addGestureRecognizer:tapLeftDouble];
    
    [UIView animateWithDuration:.2 animations:^{
        [app.window addSubview:alphaView];
        CGRect Frame   = share.frame;
        Frame.origin.y = viewHeight - Adaptive(256);
        share.frame    = Frame;
        [app.window addSubview:share];
        
    }];
}

- (void)removeShare {
    [alphaView removeFromSuperview];
    
    
    [UIView animateWithDuration:.2 animations:^{
        CGRect Frame   = share.frame;
        Frame.origin.y = viewHeight;
        share.frame    = Frame;
    } completion:^(BOOL finished) {
        [share removeFromSuperview];
    }];
}

-(void)magnifyImage:(UIGestureRecognizer *)gesture
{
    [self removeShare];
}

@end
