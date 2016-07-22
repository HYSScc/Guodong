//
//  DetailsContentView.m
//  果动
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "NewsDetailsViewController.h"
#import "DetailsContentView.h"
#import "ContentDetails.h"
#import "NewsFunctionView.h"

#import "AppDelegate.h"
#import "ShareView.h"

#import "PublishViewController.h"
@implementation DetailsContentView
{
    UIImageView *_headerImageView;
    UILabel     *_nameLabel;
    UILabel     *_dateLabel;
    UILabel     *_contentLabel;
    UILabel     *_longLine;
    NSString    *talk_idString;
    UIView      *alphaView;
    ShareView   *share;
    NSString    *user_id;
    NSString    *whoPublish;
    UIViewController *viewController;
    UIImageView     *shareImageView;
    
    
}
- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        viewController = controller;
        [self createUI];
    }
    return self;
}
- (void)createUI {
    
    self.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
    
    
    _headerImageView       = [UIImageView new];
    _headerImageView.frame = CGRectMake(Adaptive(13), Adaptive(13), Adaptive(30), Adaptive(30));
    _headerImageView.layer.cornerRadius  = _headerImageView.bounds.size.width / 2;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.userInteractionEnabled = YES;
    [self addSubview:_headerImageView];
    
    
    UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushUserPublick:)];
    [_headerImageView addGestureRecognizer:tapLeftDouble];
    
    _nameLabel       = [UILabel new];
    _nameLabel.frame = CGRectMake(CGRectGetMaxX(_headerImageView.frame) + Adaptive(13),
                                  CGRectGetMinY(_headerImageView.frame) + Adaptive(7),
                                  Adaptive(150),
                                  Adaptive(20));
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    [self addSubview:_nameLabel];
    
    _dateLabel       = [UILabel new];
    _dateLabel.frame = CGRectMake(viewWidth - Adaptive(150) - Adaptive(13),
                                  CGRectGetMinY(_headerImageView.frame) + Adaptive(9),
                                  Adaptive(150),
                                  Adaptive(20));
    _dateLabel.font  = [UIFont fontWithName:FONT size:Adaptive(12)];
    _dateLabel.textColor     = [UIColor lightGrayColor];
    _dateLabel.textAlignment = 2;
    [self addSubview:_dateLabel];
    
    
    _contentLabel           = [UILabel new];
    _contentLabel.textColor = [UIColor whiteColor];
    _contentLabel.numberOfLines = 0;
    _contentLabel.font          = [UIFont fontWithName:FONT size:Adaptive(14)];
    [self addSubview:_contentLabel];
    
    _longLine                 = [UILabel new];
    _longLine.backgroundColor = [UIColor colorWithRed:38/255.0 green:38/255.0 blue:38/255.0 alpha:1];
    [self addSubview:_longLine];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeShare) name:@"removeShare" object:nil];
}

- (void)setDetails:(ContentDetails *)details {
    
    user_id = details.user_id;
    whoPublish = details.nickName;
    
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:details.headImgString] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    _nameLabel.text = details.nickName;
    _dateLabel.text = details.timeString;
    
    _contentLabel.text = details.content;
    CGSize contentSize = [details.content boundingRectWithSize:CGSizeMake(viewWidth-Adaptive(26), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:FONT size:Adaptive(15)]} context:nil].size;
    _contentLabel.frame = CGRectMake(Adaptive(13),
                                     CGRectGetMaxY(_headerImageView.frame) + Adaptive(13),
                                     contentSize.width,
                                     contentSize.height);
    
    
    
    for (int a = 0; a < details.photoArray.count; a++) {
        
        CGFloat  getHeight = [[details.photoArray[a] objectForKey:@"height"] intValue] / 2;
        CGFloat  getWidth  = [[details.photoArray[a] objectForKey:@"width"] intValue] / 2;
        
        
        UIImageView *contentImageView = [UIImageView new];
        contentImageView.frame        = CGRectMake(Adaptive(13),
                                                   (CGRectGetMaxY(_contentLabel.frame) + Adaptive(13)) + a * (viewWidth - Adaptive(26)),
                                                   viewWidth - Adaptive(26),
                                                   ((viewWidth - Adaptive(26)) * getHeight) / getWidth);
        contentImageView.backgroundColor = BASECOLOR;
        NSString *imgUrl = [details.photoArray[a] objectForKey:@"url"];
        [contentImageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        contentImageView.tag = a+1;
        [self addSubview:contentImageView];
        
    }
    
    shareImageView  = [UIImageView new];
    [shareImageView sd_setImageWithURL:[NSURL URLWithString:[details.photoArray[0] objectForKey:@"url"]]];
    
    
    UIImageView *contentImageView = (UIImageView *)[self viewWithTag:details.photoArray.count];
    
    
    _longLine.frame = CGRectMake(Adaptive(13),
                                 CGRectGetMaxY(contentImageView.frame) + Adaptive(10),
                                 viewWidth - Adaptive(26),
                                 Adaptive(0.5));
    
    
    NewsFunctionView *functionView = [[NewsFunctionView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(_longLine.frame) + Adaptive(5),viewWidth,Adaptive(40))];
    [functionView.shareButton addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [functionView.commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [functionView.moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    functionView.details = details;
    [self addSubview:functionView];
    
    talk_idString = details.talk_id;
    
    self.height = CGRectGetMaxY(functionView.frame) + Adaptive(5);
    
}
- (void)moreButtonClick:(UIButton *)button {
//    NSNotification *notification =[NSNotification notificationWithName:@"removeNews" object:nil userInfo:nil];
//    
//    //通过通知中心发送通知
//    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    NewsDetailsViewController *news = [NewsDetailsViewController sharedViewControllerManager];
    [news removeNewssss:talk_idString user_id:user_id];
    
}
- (void)commentButtonClick:(UIButton *)button {
    NSNotification *notification =[NSNotification notificationWithName:@"clickCommentButton" object:nil userInfo:nil];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];

}

- (void)shareButtonClick:(UIButton *)button {
   
    
    NSString *url = [NSString stringWithFormat:@"%@usershare/?types=gdb&id=%@",BASEURL,talk_idString];
    
    NSString *title = [NSString stringWithFormat:@"%@的健身动态 - 果动",_nameLabel.text];
    
    
    share = [[ShareView alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, Adaptive(256)) title:title imageName:shareImageView.image url:url id:talk_idString shareType:@"gdb" viewController:viewController];
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

- (void)pushUserPublick:(UIGestureRecognizer *)gesture {
    
   NSLog(@"user_id %@",user_id);
    PublishViewController *publish = [PublishViewController new];
    publish.user_id = user_id;
    publish.className = whoPublish;
    [viewController.navigationController pushViewController:publish animated:YES];
}
@end
