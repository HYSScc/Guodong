//
//  GBTableViewCell.m
//  果动
//
//  Created by mac on 15/9/7.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "GBTableViewCell.h"

//第一行图片
@implementation GBTableViewCell {
    UIView* contentView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:127 / 255.0 green:127 / 255.0 blue:127 / 255.0 alpha:1];
        CGRect frame = [self frame];

        //图片
        self.photoImageView = [[UIImageView alloc] init];
        self.photoImageView.frame = CGRectMake(0, 0, viewWidth, viewWidth);
        self.photoImageView.tag = 10;
        self.photoImageView.userInteractionEnabled = YES;
        [self addSubview:self.photoImageView];

        /*************内容View****************************/
        contentView = [[UIView alloc] init];
        contentView.frame = CGRectMake(0, self.photoImageView.bounds.size.height - (Adaptive(50) * 2), viewWidth, Adaptive(50));
        contentView.userInteractionEnabled = YES;
        contentView.backgroundColor = [UIColor blackColor];
        contentView.alpha = 0.5;
        [self.photoImageView addSubview:contentView];

        self.photocommentLabel = [[UILabel alloc] init];
        self.photocommentLabel.numberOfLines = 0;
        self.photocommentLabel.textColor = [UIColor whiteColor];
        self.photocommentLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        [contentView addSubview:self.photocommentLabel];

        /*****************评|赞****************************/

        self.pingzanView = [[UIView alloc] init];
        self.pingzanView.frame = CGRectMake(0, self.photoImageView.bounds.size.height - Adaptive(50), viewWidth, Adaptive(50));
        self.pingzanView.backgroundColor = [UIColor blackColor];
        self.pingzanView.alpha = .8;
        self.pingzanView.userInteractionEnabled = YES;
        [self.photoImageView addSubview:self.pingzanView];

        self.pImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GD_pinglun"]];
        self.pImage.frame = CGRectMake(Adaptive(15), (self.pingzanView.bounds.size.height - Adaptive(20)) / 2, Adaptive(20), Adaptive(20));
        [self.pingzanView addSubview:self.pImage];

        self.pingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.pingButton.frame = CGRectMake(Adaptive(15), Adaptive(15), CGRectGetMaxX(self.cnumberLabel.frame), Adaptive(20));
        [self.pingzanView addSubview:self.pingButton];

        self.cnumberLabel = [[UILabel alloc] init];
        self.cnumberLabel.textAlignment = 1;

        self.cnumberLabel.numberOfLines = 0;
        self.cnumberLabel.textColor = [UIColor whiteColor];
        self.cnumberLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
        [self.pingzanView addSubview:self.cnumberLabel];

        self.likeButton = [MCFireworksButton buttonWithType:UIButtonTypeRoundedRect];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.likeButton.particleImage = [UIImage imageNamed:@"Sparkle1"];
        self.likeButton.particleScale = 0.05;
        self.likeButton.particleScaleRange = 0.02;

        [self.pingzanView addSubview:self.likeButton];

        self.znumberLabel = [[UILabel alloc] init];
        self.znumberLabel.textAlignment = 1;
        self.znumberLabel.numberOfLines = 0;
        self.znumberLabel.textColor = [UIColor whiteColor];
        self.znumberLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
        [self.pingzanView addSubview:self.znumberLabel];

        self.removeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.removeButton setBackgroundImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
        [self.pingzanView addSubview:self.removeButton];

        self.openImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GD_xia"]];
        self.openImg.userInteractionEnabled = YES;
        self.openImg.frame = CGRectMake(self.pingzanView.bounds.size.width - Adaptive(30), (self.pingzanView.bounds.size.height - Adaptive(10)) / 2, Adaptive(15), Adaptive(7));
        [self.pingzanView addSubview:self.openImg];

        self.openButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.openButton.frame = CGRectMake(self.pingzanView.bounds.size.width - Adaptive(50), 0, Adaptive(50), Adaptive(50));
        [self.pingzanView addSubview:self.openButton];

        frame.size.height = CGRectGetMaxY(self.pingzanView.frame);
        self.frame = frame;
    }
    return self;
}
@end

//第一行视频
@implementation GBMovieCell {
    UIView* contentView;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:127 / 255.0 green:127 / 255.0 blue:127 / 255.0 alpha:1];
        CGRect frame = [self frame];

        self.SLTImageView = [[UIImageView alloc] init];
        self.SLTImageView.userInteractionEnabled = YES;
        self.SLTImageView.frame = CGRectMake(0, 0, viewWidth, viewWidth);
        [self addSubview:self.SLTImageView];

        /*************内容View****************************/
        contentView = [[UIView alloc] init];
        contentView.frame = CGRectMake(0, self.SLTImageView.bounds.size.height - (Adaptive(50) * 2), viewWidth, Adaptive(50));
        contentView.userInteractionEnabled = YES;
        contentView.backgroundColor = [UIColor blackColor];
        contentView.alpha = 0.5;
        [self.SLTImageView addSubview:contentView];

        self.photocommentLabel = [[UILabel alloc] init];
        self.photocommentLabel.numberOfLines = 0;
        self.photocommentLabel.textColor = [UIColor whiteColor];
        self.photocommentLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
        [contentView addSubview:self.photocommentLabel];

        /*****************评|赞****************************/

        self.pingzanView = [[UIView alloc] init];
        self.pingzanView.frame = CGRectMake(0, self.SLTImageView.bounds.size.height - Adaptive(50), viewWidth, Adaptive(50));
        self.pingzanView.backgroundColor = [UIColor blackColor];
        self.pingzanView.alpha = .8;
        self.pingzanView.userInteractionEnabled = YES;
        [self.SLTImageView addSubview:self.pingzanView];

        self.pImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GD_pinglun"]];
        self.pImage.frame = CGRectMake(Adaptive(15), (self.pingzanView.bounds.size.height - Adaptive(20)) / 2, Adaptive(20), Adaptive(20));
        [self.pingzanView addSubview:self.pImage];

        self.pingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.pingButton.frame = CGRectMake(Adaptive(15), Adaptive(15), CGRectGetMaxX(self.cnumberLabel.frame), Adaptive(20));
        [self.pingzanView addSubview:self.pingButton];

        self.cnumberLabel = [[UILabel alloc] init];
        self.cnumberLabel.textAlignment = 1;

        self.cnumberLabel.numberOfLines = 0;
        self.cnumberLabel.textColor = [UIColor whiteColor];
        self.cnumberLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
        [self.pingzanView addSubview:self.cnumberLabel];

        self.likeButton = [MCFireworksButton buttonWithType:UIButtonTypeRoundedRect];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.likeButton.particleImage = [UIImage imageNamed:@"Sparkle1"];
        self.likeButton.particleScale = 0.05;
        self.likeButton.particleScaleRange = 0.02;

        [self.pingzanView addSubview:self.likeButton];

        self.znumberLabel = [[UILabel alloc] init];
        self.znumberLabel.textAlignment = 1;
        self.znumberLabel.numberOfLines = 0;
        self.znumberLabel.textColor = [UIColor whiteColor];
        self.znumberLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];
        [self.pingzanView addSubview:self.znumberLabel];

        self.removeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.removeButton setBackgroundImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
        [self.pingzanView addSubview:self.removeButton];

        self.openImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GD_xia"]];
        self.openImg.userInteractionEnabled = YES;
        self.openImg.frame = CGRectMake(self.pingzanView.bounds.size.width - Adaptive(30), (self.pingzanView.bounds.size.height - Adaptive(10)) / 2, Adaptive(15), Adaptive(7));
        [self.pingzanView addSubview:self.openImg];

        self.openButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.openButton.frame = CGRectMake(self.pingzanView.bounds.size.width - Adaptive(50), 0, Adaptive(50), Adaptive(50));
        [self.pingzanView addSubview:self.openButton];

        self.playButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"bofang"] forState:UIControlStateNormal];
        self.playButton.bounds = CGRectMake(0, 0, Adaptive(60), Adaptive(60));
        self.playButton.center = self.SLTImageView.center;

        //  [self.playButton addTarget:self action:@selector(playButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.playButton];

        frame.size.height = CGRectGetMaxY(self.pingzanView.frame);
        self.frame = frame;
    }
    return self;
}
@end

//赞
@implementation GBZanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
        self.bounds = CGRectMake(0, 0, viewWidth, viewHeight / 15.159);
        self.xinImage = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(15), (self.bounds.size.height - Adaptive(14.5)) / 2, Adaptive(17.5), Adaptive(14.5))];
        [self.xinImage setImage:[UIImage imageNamed:@"GD_baixin"]];
        [self addSubview:self.xinImage];

        for (int a = 0; a < 6; a++) {

            self.zanheadimg = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.xinImage.frame) + Adaptive(15) + a * Adaptive(35), Adaptive(7), Adaptive(30), Adaptive(30))];
            self.zanheadimg.tag = a + 100;
            self.zanheadimg.hidden = YES;
            self.zanheadimg.layer.cornerRadius = self.zanheadimg.bounds.size.width / 2;
            self.zanheadimg.layer.masksToBounds = YES;
            [self addSubview:self.zanheadimg];
        }
        
        self.reportButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];

        self.reportButton.frame = CGRectMake(viewWidth - Adaptive(13) - Adaptive(30), (self.bounds.size.height - Adaptive(13)) / 2, Adaptive(30), Adaptive(13));

        [self.reportButton setTitle:@"更多" forState:UIControlStateNormal];
        [self.reportButton setTintColor:[UIColor whiteColor]];
        self.reportButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
        [self addSubview:self.reportButton];

        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0, Adaptive(43), viewWidth, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1];
        [self addSubview:line];
    }
    return self;
}
@end

//评论
@implementation GBPinLunCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    }
    return self;
}
- (void)setInfo_id:(NSString*)info_id
{
    _info_id = info_id;
}
- (void)setReplay_id:(NSString*)replay_id
{
    _replay_id = replay_id;
}
@end

//回复评论
@implementation GBReplayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    }
    return self;
}
- (void)setComment_id:(NSString*)comment_id
{
    _comment_id = comment_id;
}
- (void)setReplay_id:(NSString*)replay_id
{
    _replay_id = replay_id;
}
@end

//输入框

@implementation GBTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:113 / 255.0 green:113 / 255.0 blue:113 / 255.0 alpha:1];
        self.bounds = CGRectMake(0, 0, viewWidth, Adaptive(44));
        _textfield = [[UITextField alloc] initWithFrame:CGRectMake(Adaptive(15), (self.bounds.size.height - Adaptive(30)) / 2, viewWidth - Adaptive(70), Adaptive(30))];
        _textfield.borderStyle = UITextBorderStyleNone;
        _textfield.layer.cornerRadius = 3;
        _textfield.layer.masksToBounds = YES;
        _textfield.backgroundColor = [UIColor colorWithRed:131 / 255.0 green:131 / 255.0 blue:131 / 255.0 alpha:1];
        _textfield.textColor = [UIColor whiteColor];
        _textfield.font = [UIFont fontWithName:FONT size:Adaptive(14)];
        [self addSubview:_textfield];

        _sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _sendButton.frame = CGRectMake(CGRectGetMaxX(_textfield.frame) + Adaptive(5), (self.bounds.size.height - Adaptive(25)) / 2, Adaptive(50), Adaptive(25));
        [_sendButton setTitle:@"留言" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_sendButton];
    }
    return self;
}
@end

//新的动态回复cell
@implementation NewsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.headImgeView = [UIImageView new];
        self.headImgeView.layer.cornerRadius = self.headImgeView.bounds.size.width / 2;
        self.headImgeView.layer.masksToBounds = YES;
        [self addSubview:self.headImgeView];

        self.headLabel = [UILabel new];
        self.headLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:125 / 255.0 blue:40 / 255.0 alpha:1];
        self.headLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];

        [self addSubview:self.headLabel];

        self.contentLabel = [UILabel new];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];

        self.dateLabel = [UILabel new];
        self.dateLabel.textColor = [UIColor lightGrayColor];
        self.dateLabel.font = [UIFont fontWithName:FONT size:Adaptive(10)];
        [self addSubview:self.dateLabel];

        self.photoImageView = [UIImageView new];
        self.photoImageView.layer.cornerRadius = 3;
        self.photoImageView.layer.masksToBounds = YES;
        [self addSubview:self.photoImageView];

        self.line = [UILabel new];
        self.line.backgroundColor = [UIColor colorWithRed:94 / 255.0 green:94 / 255.0 blue:94 / 255.0 alpha:1];
        [self addSubview:self.line];
    }

    return self;
}
@end
//新的动态回复cell
@implementation NewsTableViewZanCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString*)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.headImgeView = [UIImageView new];
        self.headImgeView.layer.cornerRadius = self.headImgeView.bounds.size.width / 2;
        self.headImgeView.layer.masksToBounds = YES;
        [self addSubview:self.headImgeView];

        self.headLabel = [UILabel new];
        self.headLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:125 / 255.0 blue:40 / 255.0 alpha:1];
        self.headLabel.font = [UIFont fontWithName:FONT size:Adaptive(17)];

        [self addSubview:self.headLabel];

        self.zanImageView = [UIImageView new];
        [self addSubview:self.zanImageView];

        self.dateLabel = [UILabel new];
        self.dateLabel.textColor = [UIColor lightGrayColor];
        self.dateLabel.font = [UIFont fontWithName:FONT size:Adaptive(10)];
        [self addSubview:self.dateLabel];

        self.photoImageView = [UIImageView new];
        self.photoImageView.layer.cornerRadius = 3;
        self.photoImageView.layer.masksToBounds = YES;
        [self addSubview:self.photoImageView];

        self.line = [UILabel new];
        self.line.backgroundColor = [UIColor colorWithRed:94 / 255.0 green:94 / 255.0 blue:94 / 255.0 alpha:1];
        [self addSubview:self.line];
    }

    return self;
}
@end
