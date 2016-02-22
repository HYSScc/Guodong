//
//  LXActivity.m
//  LXActivityDemo
//
//  Created by lixiang on 15-3-17.
//  Copyright (c) 2014年 Unique. All rights reserved.
//


#import "LXActivity.h"
#import "QCheckBox.h"
#import "appointViewController.h"
#define WINDOW_COLOR [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2]
#define ACTIONSHEET_BACKGROUNDCOLOR [UIColor colorWithRed:227 / 255.0 green:227 / 255.0 blue:227 / 255.0 alpha:1]
#define ANIMATE_DURATION 0.25f

#define CORNER_RADIUS 5
#define SHAREBUTTON_BORDER_WIDTH 0.5f
#define SHAREBUTTON_BORDER_COLOR [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor
#define SHAREBUTTONTITLE_FONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]

#define CANCEL_BUTTON_COLOR [UIColor colorWithRed:53 / 255.00f green:53 / 255.00f blue:53 / 255.00f alpha:1]

#define SHAREBUTTON_WIDTH 50
#define SHAREBUTTON_HEIGHT 50
#define SHAREBUTTON_INTERVAL_WIDTH 42.5
#define SHAREBUTTON_INTERVAL_HEIGHT 35

#define SHARETITLE_WIDTH 50
#define SHARETITLE_HEIGHT 20
#define SHARETITLE_INTERVAL_WIDTH 42.5
#define SHARETITLE_INTERVAL_HEIGHT SHAREBUTTON_WIDTH + SHAREBUTTON_INTERVAL_HEIGHT
#define SHARETITLE_FONT [UIFont fontWithName:@"HiraKakuProN-W3" size:15]

#define TITLE_INTERVAL_HEIGHT 25
#define TITLE_HEIGHT 35
#define TITLE_INTERVAL_WIDTH 55
#define TITLE_WIDTH 260
#define TITLE_FONT [UIFont fontWithName:@"Helvetica-Bold" size:10]
#define SHADOW_OFFSET CGSizeMake(0, 0.8f)
#define TITLE_NUMBER_LINES 2

#define BUTTON_INTERVAL_HEIGHT 20
#define BUTTON_HEIGHT 40
#define BUTTON_INTERVAL_WIDTH 60
#define BUTTON_WIDTH 240
#define BUTTONTITLE_FONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:18]
#define BUTTON_BORDER_WIDTH 0.5f
#define BUTTON_BORDER_COLOR [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.8].CGColor

@interface UIImage (custom)

+ (UIImage*)imageWithColor:(UIColor*)color;

@end

@implementation UIImage (custom)

+ (UIImage*)imageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}
@end

@interface LXActivity () {
    BOOL ishave;
    BOOL jian;
    QCheckBox* _check1;
    QCheckBox* _check2;
    UILabel* classTimeLabel;
    UILabel* titleLabel;
    UILabel* changeLabel;
    UILabel* oldprice;
    int youhuiPrice;
    int oldPrice;
    int discontPrice;
    NSString* oldPriceString;
}

@property (nonatomic, strong) UIView* backGroundView;
@property (nonatomic, strong) NSString* actionTitle;
@property (nonatomic, assign) NSInteger postionIndexNumber;
@property (nonatomic, assign) BOOL isHadTitle;
@property (nonatomic, assign) BOOL isHadShareButton;
@property (nonatomic, assign) BOOL isHadCancelButton;
@property (nonatomic, assign) CGFloat LXActivityHeight;
@property (nonatomic, assign) id<LXActivityDelegate> delegate;

@end

@implementation LXActivity

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Public method

- (id)initWithTitle:(NSString*)title time:(NSString*)time delegate:(id<LXActivityDelegate>)delegate discont:(NSString*)discont youhuijuan:(NSString*)youhuijuan classNumber:(NSString*)classnumber isFirst:(NSString*)isFirst cancelButtonTitle:(NSString*)cancelButtonTitle ShareButtonTitles:(NSArray*)shareButtonTitlesArray withShareButtonImagesName:(NSArray*)shareButtonImagesNameArray;
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_COLOR;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];

        if (delegate) {
            self.delegate = delegate;
        }

        [self creatButtonsWithTitle:title time:(NSString*)time discont:discont youhuijuan:youhuijuan classNumber:classnumber isFirst:isFirst cancelButtonTitle:cancelButtonTitle shareButtonTitles:shareButtonTitlesArray withShareButtonImagesName:shareButtonImagesNameArray];
    }
    return self;
}

- (void)showInView:(UIView*)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];
}

#pragma mark - Praviate method

- (void)creatButtonsWithTitle:(NSString*)title time:(NSString*)time discont:(NSString*)discont youhuijuan:(NSString*)youhuijuan classNumber:(NSString*)classnumber isFirst:(NSString*)isFirst cancelButtonTitle:(NSString*)cancelButtonTitle shareButtonTitles:(NSArray*)shareButtonTitlesArray withShareButtonImagesName:(NSArray*)shareButtonImagesNameArray
{
    //初始化
    self.isHadTitle = NO;
    self.isHadShareButton = NO;
    self.isHadCancelButton = NO;

    //初始化LXACtionView的高度为0
    self.LXActivityHeight = 0;

    //初始化IndexNumber为0;
    self.postionIndexNumber = 0;

    //生成LXActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    self.backGroundView.backgroundColor = ACTIONSHEET_BACKGROUNDCOLOR;
    youhuiPrice = [youhuijuan intValue];
    oldPrice = [title intValue];
    discontPrice = [discont intValue];
    [self addSubview:self.backGroundView];

    if (title) {
        self.isHadTitle = YES;
        //价格变化的动画Label
        changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth / 2, 25, 50, 17)];
        changeLabel.textColor = [UIColor orangeColor];
        changeLabel.text = [NSString stringWithFormat:@"- %d", youhuiPrice];
        changeLabel.font = [UIFont fontWithName:FONT size:16];
        //  [self.backGroundView addSubview:changeLabel];
        NSString* nowPrise = [NSString stringWithFormat:@"%d", oldPrice - discontPrice];
        titleLabel = [self creatTitleLabelWith:nowPrise];

        if ([classnumber intValue] == 1) {

            oldPriceString = [NSString stringWithFormat:@"原价:%d元", oldPrice];
        }
        else {
            NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
            formatter.numberStyle = kCFNumberFormatterRoundHalfDown;
            NSString* string = [formatter stringFromNumber:[NSNumber numberWithInt:[classnumber intValue]]];
            if ([string isEqualToString:@"二"]) {
                oldPriceString = [NSString stringWithFormat:@"原价:%d元/双人", oldPrice];
            }
            else {
                oldPriceString = [NSString stringWithFormat:@"原价:%d元/%@人", oldPrice, string];
            }
        }
        NSMutableAttributedString* attri = [[NSMutableAttributedString alloc] initWithString:oldPriceString];
        [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, oldPriceString.length)];
        oldprice = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame) - 20, CGRectGetMaxY(titleLabel.frame) - 15, 120, 15)];
        oldprice.attributedText = attri;
        oldprice.textColor = [UIColor lightGrayColor];
        oldprice.font = [UIFont fontWithName:FONT size:14];
        oldprice.textAlignment = 1;
        //折扣价为0的话不显示原价格
        if (discontPrice != 0) {
            NSString* nowPrise = [NSString stringWithFormat:@"%d", oldPrice - discontPrice];
            NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"会员价格: %@元", nowPrise]];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:16] range:NSMakeRange(0, 5)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:23] range:NSMakeRange(5, nowPrise.length + 2)];
            titleLabel.attributedText = str;
            [self.backGroundView addSubview:oldprice];
        }

        classTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth - 200) / 2, CGRectGetMaxY(titleLabel.frame) + 13, 200, 15)];
        classTimeLabel.textColor = [UIColor lightGrayColor];
        classTimeLabel.font = [UIFont fontWithName:FONT size:14];
        classTimeLabel.textAlignment = 1;
        classTimeLabel.text = [NSString stringWithFormat:@"课程总%@分钟", time];
        [self.backGroundView addSubview:classTimeLabel];

        UIImageView* lineImage = [[UIImageView alloc] init];
        lineImage.backgroundColor = [UIColor lightGrayColor];
        lineImage.alpha = .5;
        lineImage.frame = CGRectMake(0, CGRectGetMaxY(classTimeLabel.frame) + 12, self.backGroundView.frame.size.width, 1);
        [self.backGroundView addSubview:lineImage];
        //没有优惠劵或者用户首次课  不允许使用优惠劵
        if ([youhuijuan intValue] == 0 || [isFirst intValue] == 1) {
            self.LXActivityHeight = self.LXActivityHeight + 2 * TITLE_INTERVAL_HEIGHT + TITLE_HEIGHT + 30;
        }
        else {
            UILabel* remarkLabe = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(lineImage.frame) + 20, self.backGroundView.frame.size.width, 16)];
            remarkLabe.textAlignment = NSTextAlignmentCenter;
            remarkLabe.font = [UIFont fontWithName:FONT size:15];
            remarkLabe.textColor = [UIColor grayColor];
            remarkLabe.numberOfLines = TITLE_NUMBER_LINES;
            remarkLabe.text = [NSString stringWithFormat:@"您有%@元的私房钱可以使用,是否使用?", youhuijuan];
            [self.backGroundView addSubview:remarkLabe];

            _check1 = [[QCheckBox alloc] initWithDelegate:self];
            _check1.frame = CGRectMake(self.backGroundView.frame.size.width / 2 - 100, CGRectGetMaxY(remarkLabe.frame) + 20, 80, 40);
            [_check1 setTitle:@"使用" forState:UIControlStateNormal];
            _check1.titleLabel.font = SHARETITLE_FONT;
            _check1.tag = 1000;
            [_check1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            [self.backGroundView addSubview:_check1];

            _check2 = [[QCheckBox alloc] initWithDelegate:self];
            _check2.tag = 2000;
            _check2.frame = CGRectMake(CGRectGetMaxX(_check1.frame) + 25, CGRectGetMaxY(remarkLabe.frame) + 20, 140, 40);
            [_check2 setTitle:@"下次再说" forState:UIControlStateNormal];
            _check2.titleLabel.font = SHARETITLE_FONT;
            [_check2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
            [_check2 setChecked:YES];
            [self.backGroundView addSubview:_check2];

            UIImageView* lineImage1 = [[UIImageView alloc] init];
            lineImage1.backgroundColor = [UIColor lightGrayColor];
            lineImage1.alpha = 0.5;
            lineImage1.frame = CGRectMake(0, CGRectGetMaxY(_check2.frame) + 20, self.backGroundView.frame.size.width, 1);
            [self.backGroundView addSubview:lineImage1];

            self.LXActivityHeight = self.LXActivityHeight + 2 * TITLE_INTERVAL_HEIGHT + TITLE_HEIGHT + 2 + 35 + 40 + 3 + 30 + 20;
        }

        [self.backGroundView addSubview:titleLabel];
    }

    if (shareButtonImagesNameArray) {
        if (shareButtonImagesNameArray.count > 0) {
            self.isHadShareButton = YES;
            for (int i = 1; i < shareButtonImagesNameArray.count + 1; i++) {
                //计算出行数，与列数
                int column = (int)ceil((float)(i) / 3); //行
                int line = (i) % 3; //列
                if (line == 0) {
                    line = 3;
                }
                UIButton* shareButton = [self creatShareButtonWithColumn:column andLine:line];
                shareButton.tag = self.postionIndexNumber;
                shareButton.tag = i - 1;
                [shareButton addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];
                shareButton.backgroundColor = [UIColor clearColor];
                [shareButton setBackgroundImage:[UIImage imageNamed:[shareButtonImagesNameArray objectAtIndex:i - 1]] forState:UIControlStateNormal];

                //有Title的时候   三中支付方式
                if (line == 1) {
                    [shareButton setFrame:CGRectMake(SHAREBUTTON_INTERVAL_WIDTH + ((line - 1) * (SHAREBUTTON_INTERVAL_WIDTH + SHAREBUTTON_WIDTH + 20)) - 15, self.LXActivityHeight + ((column - 1) * (SHAREBUTTON_INTERVAL_HEIGHT + SHAREBUTTON_HEIGHT)), 62, 68)];
                }
                if (line == 2) {
                    [shareButton setFrame:CGRectMake(SHAREBUTTON_INTERVAL_WIDTH + ((line - 1) * (SHAREBUTTON_INTERVAL_WIDTH + SHAREBUTTON_WIDTH + 20)) - 15, self.LXActivityHeight + ((column - 1) * (SHAREBUTTON_INTERVAL_HEIGHT + SHAREBUTTON_HEIGHT)) + 1.5, 71.5, 66.5)];
                }
                if (line == 3) {
                    [shareButton setFrame:CGRectMake(SHAREBUTTON_INTERVAL_WIDTH + ((line - 1) * (SHAREBUTTON_INTERVAL_WIDTH + SHAREBUTTON_WIDTH + 20)) - 15, self.LXActivityHeight + ((column - 1) * (SHAREBUTTON_INTERVAL_HEIGHT + SHAREBUTTON_HEIGHT)) + 10.5, 99, 57.5)];
                }
                [self.backGroundView addSubview:shareButton];
            }
        }
    }
    //再次计算加入shareButtons后LXActivity的高度
    if (shareButtonImagesNameArray && shareButtonImagesNameArray.count > 0) {
        int totalColumns = (int)ceil((float)(shareButtonImagesNameArray.count) / 3);
        if (self.isHadTitle == YES) {
            self.LXActivityHeight = self.LXActivityHeight + totalColumns * (SHAREBUTTON_INTERVAL_HEIGHT + SHAREBUTTON_HEIGHT);
        }
        else {
            self.LXActivityHeight = SHAREBUTTON_INTERVAL_HEIGHT + totalColumns * (SHAREBUTTON_INTERVAL_HEIGHT + SHAREBUTTON_HEIGHT);
        }
    }

    if (cancelButtonTitle) {
        self.isHadCancelButton = YES;
        UIButton* cancelButton = [self creatCancelButtonWith:cancelButtonTitle];
        cancelButton.tag = 4;
        [cancelButton addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];

        //当没title destructionButton otherbuttons时
        if (self.isHadTitle == NO && self.isHadShareButton == NO) {
            self.LXActivityHeight = self.LXActivityHeight + cancelButton.frame.size.height + (2 * BUTTON_INTERVAL_HEIGHT);
        }
        //当有title或destructionButton或otherbuttons时
        if (self.isHadTitle == YES || self.isHadShareButton == YES) {
            [cancelButton setFrame:CGRectMake(cancelButton.frame.origin.x, self.LXActivityHeight, cancelButton.frame.size.width, cancelButton.frame.size.height)];
            self.LXActivityHeight = self.LXActivityHeight + cancelButton.frame.size.height + BUTTON_INTERVAL_HEIGHT;
        }
        [self.backGroundView addSubview:cancelButton];
    }

    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.LXActivityHeight, [UIScreen mainScreen].bounds.size.width, self.LXActivityHeight)];
    }
        completion:^(BOOL finished){
        }];
}

//取消按钮
- (UIButton*)creatCancelButtonWith:(NSString*)cancelButtonTitle
{
    UIButton* cancelButton = [[UIButton alloc] init];

    cancelButton.frame = CGRectMake((viewWidth - 26.4) / 2, BUTTON_INTERVAL_HEIGHT, 26.4, 26.4);

    cancelButton.layer.masksToBounds = YES;
    cancelButton.layer.cornerRadius = CORNER_RADIUS;
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"pay_cancel"] forState:UIControlStateNormal];

    return cancelButton;
}

- (UIButton*)creatShareButtonWithColumn:(int)column andLine:(int)line
{
    UIButton* shareButton = [[UIButton alloc] init];
    //    shareButton.frame = CGRectMake(SHAREBUTTON_INTERVAL_WIDTH+((line-1)*(SHAREBUTTON_INTERVAL_WIDTH+SHAREBUTTON_WIDTH+18)), SHAREBUTTON_INTERVAL_HEIGHT+((column-1)*(SHAREBUTTON_INTERVAL_HEIGHT+SHAREBUTTON_HEIGHT)), 150, 150);
    return shareButton;
}

- (UILabel*)creatShareLabelWithColumn:(int)column andLine:(int)line
{
    UILabel* shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(SHARETITLE_INTERVAL_WIDTH + ((line - 1) * (SHARETITLE_INTERVAL_WIDTH + SHARETITLE_WIDTH)), SHARETITLE_INTERVAL_HEIGHT + ((column - 1) * (SHARETITLE_INTERVAL_HEIGHT)), SHARETITLE_WIDTH, SHARETITLE_HEIGHT)];

    shareLabel.backgroundColor = [UIColor redColor];
    shareLabel.textAlignment = NSTextAlignmentCenter;
    shareLabel.font = TITLE_FONT;
    shareLabel.textColor = [UIColor blackColor];
    return shareLabel;
}
//标题
- (UILabel*)creatTitleLabelWith:(NSString*)title
{

    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格: %@元", title]];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:16] range:NSMakeRange(0, 5)];
    [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:23] range:NSMakeRange(5, 5)];

    titleLabel = [[UILabel alloc] init];
    NSString* string = [NSString stringWithFormat:@"当前价格: %@元", title];
    CGSize stringSize = [string sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:24] }];
    NSLog(@"width %f", stringSize.width);
    titleLabel.frame = CGRectMake((viewWidth - stringSize.width) / 2, TITLE_INTERVAL_HEIGHT, stringSize.width, stringSize.height);
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    //  titleLabel.font = [UIFont fontWithName:FONT  size:23];
    titleLabel.attributedText = str;
    titleLabel.textColor = [UIColor orangeColor];
    titleLabel.numberOfLines = TITLE_NUMBER_LINES;
    return titleLabel;
}

- (void)didClickOnImageIndex:(UIButton*)button
{
    NSLog(@"button  %ld", (long)button.tag);
    // UIButton *cancel =   (UIButton *)[self viewWithTag:4];

    if (self.delegate) {
        if (button.tag != self.postionIndexNumber - 1) {
            if ([self.delegate respondsToSelector:@selector(didClickOnImageIndex:)] == YES) {
                [self.delegate didClickOnImageIndex:(int)button.tag];
                NSLog(@"进方法1");
            }
        }
        else {
            if ([self.delegate respondsToSelector:@selector(didClickOnCancelButton)] == YES) {
                [self.delegate didClickOnCancelButton];
                NSLog(@"进方法2");
            }
        }
    }
    [self tappedCancel];
}

- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.alpha = 0;
    }
        completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
}

- (void)didSelectedCheckBox:(QCheckBox*)checkbox checked:(BOOL)checked
{

    NSNotificationCenter* ncyes = [NSNotificationCenter defaultCenter];
    NSNotificationCenter* ncno = [NSNotificationCenter defaultCenter];

    if (checkbox.tag == 1000) {
        if (checked) {
            [(QCheckBox*)[self.backGroundView viewWithTag:2000] setChecked:NO];
            [_check1 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];

            ishave = YES;
            changeLabel.frame = CGRectMake(viewWidth / 2, 25, 50, 17);
            changeLabel.alpha = 1;
            [self.backGroundView addSubview:changeLabel];
            [UIView animateWithDuration:2 animations:^{

                changeLabel.frame = CGRectMake(viewWidth / 3, -17, 50, 17);
                changeLabel.alpha = 0;
            }
                completion:^(BOOL finished) {
                    [changeLabel removeFromSuperview];

                }];

            NSString* nowPrise = [NSString stringWithFormat:@"%d", oldPrice - discontPrice - youhuiPrice];
            NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"折扣价格: %@元", nowPrise]];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:16] range:NSMakeRange(0, 5)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:23] range:NSMakeRange(5, nowPrise.length + 2)];
            titleLabel.attributedText = str;
            [self.backGroundView addSubview:oldprice];
            [ncyes postNotificationName:@"ishaveyes" object:nil];
        }
        else {
            ishave = NO;
            [_check1 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            NSString* nowPrise = [NSString stringWithFormat:@"%d", oldPrice - discontPrice];
            NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格: %@元", nowPrise]];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:16] range:NSMakeRange(0, 5)];
            [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:23] range:NSMakeRange(5, nowPrise.length + 2)];
            titleLabel.attributedText = str;
            if (discontPrice == 0) {
                [oldprice removeFromSuperview];
            }

            [ncno postNotificationName:@"ishaveno" object:nil];
        }
    }
    if (checkbox.tag == 2000) {
        if (checked) {
            [(QCheckBox*)[self.backGroundView viewWithTag:1000] setChecked:NO];
            [_check2 setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        }
        else {
            [_check2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }
        ishave = NO;
        NSString* nowPrise = [NSString stringWithFormat:@"%d", oldPrice - discontPrice];
        NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前价格: %@元", nowPrise]];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:16] range:NSMakeRange(0, 5)];
        [str addAttribute:NSFontAttributeName value:[UIFont fontWithName:FONT size:23] range:NSMakeRange(5, nowPrise.length + 2)];
        titleLabel.attributedText = str;
        if (discontPrice == 0) {
            [oldprice removeFromSuperview];
        }
        [ncno postNotificationName:@"ishaveno" object:nil];
    }
}

@end
