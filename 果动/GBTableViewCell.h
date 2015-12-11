//
//  GBTableViewCell.h
//  果动
//
//  Created by mac on 15/9/7.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsynImageView.h"
#import "MCFireworksButton.h"
#import "Commonality.h"
#import "GDComment.h"
//第一行图片
@interface GBTableViewCell : UITableViewCell
@property (nonatomic,retain) NSString *talkid;
@property (nonatomic,retain) UIButton *pingButton;
@property (nonatomic,retain) MCFireworksButton *likeButton;
@property (nonatomic,retain) UIImageView *openImg;
@property (nonatomic,retain) UIButton *openButton;
@property (nonatomic,retain) UILabel *photocommentLabel;
@property (nonatomic,retain) UILabel *cnumberLabel;
@property (nonatomic,retain) UIImageView *pImage;
@property (nonatomic,retain) UILabel *znumberLabel;
@property (nonatomic,retain) UIView *pingzanView;
@property (nonatomic,retain) UIImageView *photoImageView;
@property (nonatomic,retain) UIButton *removeButton;
@end

//第一行视频
@interface GBMovieCell : UITableViewCell
@property (nonatomic,retain) UIImageView *SLTImageView;
@property (nonatomic,retain) NSString *talkid;
@property (nonatomic,retain) UIButton *pingButton;
@property (nonatomic,retain) MCFireworksButton *likeButton;
@property (nonatomic,retain) UIImageView *openImg;
@property (nonatomic,retain) UIButton *openButton;
@property (nonatomic,retain) UILabel *photocommentLabel;
@property (nonatomic,retain) UILabel *cnumberLabel;
@property (nonatomic,retain) UIImageView *pImage;
@property (nonatomic,retain) UILabel *znumberLabel;
@property (nonatomic,retain) UIView *pingzanView;
@property (nonatomic,retain) UIButton *playButton;
@property (nonatomic,retain) NSString *videoURL;
@property (nonatomic,retain) UIButton *removeButton;

@end

//赞
@interface GBZanCell : UITableViewCell
@property (nonatomic,retain) UIImageView *xinImage;
@property (nonatomic,retain) GDComment *data;
@property (nonatomic,retain) UIImageView *zanheadimg;
@end


//评论
@interface GBPinLunCell : UITableViewCell
@property (nonatomic,retain) GDComment *data;
@property (nonatomic,retain) AsynImageView *info_headimg;
@property (nonatomic,retain) UILabel *info_headlab;
@property (nonatomic,retain) UILabel *info_contentlab;
@property (nonatomic,retain) UILabel *info_timelab;
@property (nonatomic,retain) UILabel *info_line;
@property (nonatomic,retain) NSString *info_id;
@property (nonatomic,retain) NSString *replay_id;
@end

//回复评论
@interface GBReplayCell : UITableViewCell
@property (nonatomic,retain) GDComment *data;
@property (nonatomic,retain) AsynImageView *info_headimg;
@property (nonatomic,retain) UILabel *info_headlab;
@property (nonatomic,retain) UILabel *info_contentlab;
@property (nonatomic,retain) UILabel *info_timelab;
@property (nonatomic,retain) UILabel *info_line;
@property (nonatomic,retain) NSString *replay_id;
@property (nonatomic,retain) NSString *comment_id;

@end

//输入框
@interface GBTextFieldCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,retain) UITextField * textfield;
@property (nonatomic,retain) UIButton *sendButton;
@end

//新的动态回复内容cell
@interface NewsTableViewCell : UITableViewCell
@property (nonatomic,retain) UIImageView *headImgeView;
@property (nonatomic,retain) UIImageView *photoImageView;
@property (nonatomic,retain) UILabel *headLabel;
@property (nonatomic,retain) UILabel *contentLabel;
@property (nonatomic,retain) UILabel *dateLabel;
@property (nonatomic,retain) UILabel *line;
@end

//新的动态赞cell
@interface NewsTableViewZanCell : UITableViewCell
@property (nonatomic,retain) UIImageView *headImgeView;
@property (nonatomic,retain) UIImageView *photoImageView;
@property (nonatomic,retain) UILabel *headLabel;
@property (nonatomic,retain) UIImageView *zanImageView;
@property (nonatomic,retain) UILabel *dateLabel;
@property (nonatomic,retain) UILabel *line;
@end
