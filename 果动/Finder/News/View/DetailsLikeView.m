//
//  DetailsLikeView.m
//  果动
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "SHImageView.h"
#import "PublishViewController.h"
#import "DetailsLikeView.h"
#import "ContentDetails.h"
#import "DetailMoreLikeViewController.h"
@implementation DetailsLikeView
{
    UILabel          *likeLabel;
    UIViewController *viewController;
    NSString         *user_id;
    DetailMoreLikeViewController *moreLike;
    NSMutableArray  *likeArray;
    UIImageView *likemoreImageView;
    NSString *whoPublish;
    UIButton *moreButton;
}
- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController*)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        viewController = controller;
    }
    return self;
}

- (void)createUI {
    self.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
    
    likeLabel  = [UILabel new];
    likeLabel.textColor = [UIColor whiteColor];
    likeLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    likeLabel.frame     = CGRectMake(Adaptive(13),
                                     (Adaptive(40) - Adaptive(15)) / 2,
                                     Adaptive(75),
                                     Adaptive(14));
    likeLabel.text      = @"150人赞";
    [self addSubview:likeLabel];
    
    
    likemoreImageView = [UIImageView new];
    likemoreImageView.frame        = CGRectMake(viewWidth - Adaptive(30) - Adaptive(13),
                                                Adaptive(4),
                                                Adaptive(32),
                                                Adaptive(32));
    likemoreImageView.image        = [UIImage imageNamed:@"find_likemore"];
    likemoreImageView.userInteractionEnabled = YES;
    
    
    moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    moreButton.frame     = CGRectMake(viewWidth - Adaptive(30) - Adaptive(13),
                                      Adaptive(5),
                                      Adaptive(30),
                                      Adaptive(30));
    [moreButton addTarget:self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setDetails:(ContentDetails *)details {
    
    likeLabel.text = [NSString stringWithFormat:@"%@赞",details.likeNumber];
   
    likeArray = [NSMutableArray array];
    likeArray = details.likeHeadImgArray;
    if ([details.likeNumber intValue] != 0) {
        [self addSubview:likemoreImageView];
        [self addSubview:moreButton];
    }
    
    
    /*** 限制最多创建7个头像   ****/
    NSInteger arrayNumber = details.likeHeadImgArray.count;
    if (details.likeHeadImgArray.count > 7) {
        arrayNumber = 7;
    }
    for (int a = 0; a < arrayNumber; a++) {
        SHImageView *imageView = [SHImageView new];
        imageView.frame        = CGRectMake(CGRectGetMaxX(likeLabel.frame) + a*Adaptive(35), Adaptive(5), Adaptive(30), Adaptive(30));
        imageView.layer.cornerRadius  = imageView.bounds.size.width / 2;
        imageView.layer.masksToBounds = YES;
        imageView.backgroundColor = BASECOLOR;
        NSDictionary *priseDict = details.likeHeadImgArray[a];
        imageView.tag = [[priseDict objectForKey:@"uid"] integerValue];
        NSURL *priseURL         = [NSURL URLWithString:[priseDict objectForKey:@"headimg"]];
        
        [imageView sd_setImageWithURL:priseURL placeholderImage:[UIImage imageNamed:@"person_nohead"]];
        [self addSubview:imageView];
        imageView.self_id = 1000 + a;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
        [imageView addGestureRecognizer:tapLeftDouble];
        
    }
    
    /*** ****** ***/
    moreLike = [DetailMoreLikeViewController new];
    moreLike.details = details;
}
-(void)magnifyImage:(UIGestureRecognizer *)gesture
{
    
    NSLog(@"headimg.tag %ld",gesture.view.tag);
    
    PublishViewController *publish = [PublishViewController new];
    publish.user_id = [NSString stringWithFormat:@"%ld",gesture.view.tag];
    SHImageView *imageView = (SHImageView *)gesture.view;
    
    publish.className = [likeArray[imageView.self_id - 1000] objectForKey:@"nickname"];
    [viewController.navigationController pushViewController:publish animated:YES];
    
}
- (void)moreButtonClick:(UIButton *)button {
    viewController.hidesBottomBarWhenPushed = YES;
    [viewController.navigationController pushViewController:moreLike animated:YES];
}
@end
