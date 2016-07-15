//
//  NewsDetailsViewController.m
//  果动
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "NewsDetailsViewController.h"
#import "LoginViewController.h"
#import "DetailsContentView.h"
#import "DetailsLikeView.h"
#import "DetailsCommentView.h"
#import "ContentDetails.h"
#import "TextFieldView.h"

@interface NewsDetailsViewController ()<UIActionSheetDelegate>
{
    UIScrollView   *_scrollView;
    TextFieldView  *textFieldView;
    NSString       *distinguishType;
    NSString       *comment_id;
    NSString       *reply_id;
    DetailsLikeView *likeView;
    DetailsCommentView *commentView;
    DetailsContentView *contentView;
    NSString       *uid;
}
@end

@implementation NewsDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 隐藏navigation
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden = YES;
    [self createUIWithDetails];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"动态详情" viewController:self];
    [self.view addSubview:navigation];
    
    
    _scrollView       = [UIScrollView new];
    _scrollView.frame = CGRectMake(0, CGRectGetMaxY(navigation.frame), viewWidth, viewHeight - NavigationBar_Height - Adaptive(42));
    _scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _scrollView.backgroundColor = BASECOLOR;
    [self.view addSubview:_scrollView];
    
    textFieldView = [[TextFieldView alloc] initWithFrame:CGRectMake(0,
                                                                    viewHeight  - Adaptive(42),
                                                                    viewWidth,
                                                                    Adaptive(42))];
    [textFieldView.publishButton addTarget:self action:@selector(newsPublishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textFieldView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    distinguishType = @"result";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(distinguish:) name:@"distinguish" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeight:) name:@"changeHeight" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refushNewsDetails:) name:@"refushNewsDetails" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickCommentButton) name:@"clickCommentButton" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeComment:) name:@"removeComment" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeNews) name:@"removeNews" object:nil];
    
}

- (void)removeNews {
    
    if ([[HttpTool getUser_id] isEqualToString:uid]) {
         UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报",@"删除", nil];
        actionSheet.tag = 998;
        [actionSheet showInView:self.view];
        
    } else {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报", nil];
        actionSheet.tag = 999;
        [actionSheet showInView:self.view];
    }
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 998) {
        
        if (buttonIndex == 0) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不友善行为：色情、辱骂等",@"垃圾广告、推销",@"其他", nil];
            actionSheet.tag = 1000;
            [actionSheet showInView:self.view];
        } else if (buttonIndex == 1) {
            NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.deletetalk&talkid=%@",BASEURL,_talk_id];
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
    } else if (actionSheet.tag == 999)  {
        
        if (buttonIndex == 0) {
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不友善行为：色情、辱骂等",@"垃圾广告、推销",@"其他", nil];
            actionSheet.tag = 1000;
            [actionSheet showInView:self.view];

        }
        
        
    } else {
        NSString *typeid;
        if (buttonIndex <  2) {
            typeid = [NSString stringWithFormat:@"%ld",buttonIndex + 1];
            NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.report&typeid=%@&talkid=%@",BASEURL,typeid,_talk_id];
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
// 提示框消失
- (void)timerFireMethod:(NSTimer*)theTimer
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)removeComment:(NSNotification *)notification {
    
    [HttpTool postWithUrl:[notification.userInfo objectForKey:@"url"] params:nil body:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        
        [self createUIWithDetails];
    }];
}

- (void)changeHeight:(NSNotification *)notification {
    
    NSInteger height = [[notification.userInfo objectForKey:@"height"] integerValue];
    CGSize scrollViewSize   = _scrollView.contentSize;
    
    if (CGRectGetMaxY(likeView.frame) + Adaptive(10) + height > viewHeight) {
        scrollViewSize.height = CGRectGetMaxY(likeView.frame) + Adaptive(10) + height ;
    } else {
        scrollViewSize.height = viewHeight + Adaptive(5);
    }
    // 通过各部分View 重设的height 设置contentSize
    _scrollView.contentSize = scrollViewSize;
}
- (void)distinguish:(NSNotification *)notification {
    
    commentView.userInteractionEnabled = NO;
    likeView.userInteractionEnabled    = NO;
    contentView.userInteractionEnabled = NO;
    textFieldView.textField.placeholder = [NSString stringWithFormat:@"回复:%@",[notification.userInfo objectForKey:@"nickName"]];
    [textFieldView.textField becomeFirstResponder];
    
    distinguishType = [notification.userInfo objectForKey:@"distinguish"];
    comment_id      = [notification.userInfo objectForKey:@"comment_id"];
    if ([distinguishType isEqualToString:@"reply"]) {
        reply_id = [notification.userInfo objectForKey:@"reply_id"];
    }
}

- (void)refushNewsDetails:(NSNotification *)notification {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.talk&talkid=%@",BASEURL,_talk_id];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *dataDict  = [responseObject objectForKey:@"data"];
        ContentDetails *details = [[ContentDetails alloc] initWithDictionary:dataDict];
        
        contentView = [[DetailsContentView alloc] initWithFrame:CGRectMake(0,0,viewWidth,0) viewController:self];
        contentView.details = details;
        [_scrollView addSubview:contentView];
        
        // 重设contentView高度
        
        CGRect contentFrame      = contentView.frame;
        contentFrame.size.height = contentView.height;
        contentView.frame        = contentFrame;
        
        
        
        likeView = [[DetailsLikeView alloc] initWithFrame:CGRectMake(0,
                                                                     CGRectGetMaxY(contentView.frame) + Adaptive(10),
                                                                     viewWidth,
                                                                     Adaptive(40))
                                           viewController:self];
        likeView.details = details;
        [_scrollView addSubview:likeView];
        
    }];
}
- (void)createUIWithDetails {
    
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.talk&talkid=%@",BASEURL,_talk_id];
    
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *dataDict  = [responseObject objectForKey:@"data"];
        ContentDetails *details = [[ContentDetails alloc] initWithDictionary:dataDict];
        
        uid = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"uid"]];
        
        contentView = [[DetailsContentView alloc] initWithFrame:CGRectMake(0,0,viewWidth,0) viewController:self];
        contentView.details = details;
        [_scrollView addSubview:contentView];
        
        // 重设contentView高度
        
        CGRect contentFrame      = contentView.frame;
        contentFrame.size.height = contentView.height;
        contentView.frame        = contentFrame;
        
        
        
        likeView = [[DetailsLikeView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(contentView.frame) + Adaptive(10), viewWidth, Adaptive(40)) viewController:self];
        likeView.details = details;
        [_scrollView addSubview:likeView];
        
        
        // 通过各部分View 重设的height 设置contentSize
        
        if ( CGRectGetMaxY(likeView.frame) +Adaptive(10) > viewHeight) {
            _scrollView.contentSize = CGSizeMake(viewWidth - Adaptive(26), CGRectGetMaxY(likeView.frame) +Adaptive(10));
        } else {
            _scrollView.contentSize = CGSizeMake(viewWidth - Adaptive(26), viewHeight + Adaptive(5));
        }
        
        
        commentView = [[DetailsCommentView alloc] initWithFrame:CGRectMake(0,
                                                                           CGRectGetMaxY(likeView.frame) + Adaptive(10),
                                                                           viewWidth,
                                                                           Adaptive(40)) ContentDetails:details viewController:self];
        [_scrollView addSubview:commentView];
        
        
        
    }];
    
    
}
//表随键盘高度变化
-(void)keyboardShow:(NSNotification *)note
{
    
    
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    textFieldView.frame = CGRectMake(0, viewHeight  - deltaY - Adaptive(42), viewWidth, Adaptive(42));
    
    
    
}
-(void)keyboardHide:(NSNotification *)note
{
    [textFieldView.textField resignFirstResponder];
    commentView.userInteractionEnabled = YES;
    likeView.userInteractionEnabled    = YES;
    contentView.userInteractionEnabled = YES;
    textFieldView.frame = CGRectMake(0,
                                     viewHeight  - Adaptive(42),
                                     viewWidth,
                                     Adaptive(42));
}

- (void)clickCommentButton {
    if ([HttpTool judgeWhetherUserLogin]) {
        [textFieldView.textField becomeFirstResponder];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }
    
}

- (void)newsPublishButtonClick:(UIButton *)button {
    
    if ([HttpTool judgeWhetherUserLogin]) {
        NSString     *url;
        NSDictionary *dict;
        
        if ([distinguishType isEqualToString:@"comment"]) {
            url  = [NSString stringWithFormat:@"%@api/?method=gdb.replay",BASEURL];
            dict = @{@"rid":@"0",
                     @"types":@"1",
                     @"comment_id":comment_id,
                     @"content"   :textFieldView.textField.text
                     };
        } else if ([distinguishType isEqualToString:@"reply"]){
            url  = [NSString stringWithFormat:@"%@api/?method=gdb.replay",BASEURL];
            dict = @{@"rid":reply_id,
                     @"types":@"2",
                     @"comment_id":comment_id,
                     @"content"   :textFieldView.textField.text
                     };
        } else {
            url  = [NSString stringWithFormat:@"%@api/?method=gdb.comments",BASEURL];
            dict = @{@"talkid":_talk_id,
                     @"info"   :textFieldView.textField.text
                     };
        }
        
        [HttpTool postWithUrl:url params:dict body:nil progress:^(NSProgress *progress) {
            
        } success:^(id responseObject) {
            textFieldView.textField.text = @"";
            [textFieldView.textField resignFirstResponder];
            
            [self createUIWithDetails];
            distinguishType        = @"result";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alert show];
            
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
    
}
@end
