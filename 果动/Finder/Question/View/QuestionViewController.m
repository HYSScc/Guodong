//
//  QuestionViewController.m
//  果动
//
//  Created by mac on 16/7/19.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "FinderPubViewController.h"
#import "QuestionViewController.h"

#import "PublishViewController.h"
#import "AppDelegate.h"
#import "FinderViewController.h"

#import "QuestionContentCell.h"
#import "QuestionReplyCell.h"
#import "QuestionCommentCell.h"

#import "QuestionContent.h"
#import "QuestionReply.h"



@interface QuestionViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIActionSheetDelegate>

@end

@implementation QuestionViewController
{
    UITableView    *_tableView;
    NSMutableArray *contentArray;
    TextFieldView  *textView;
    NSString       *comment_id;
    NSString       *reply_id;
    NSDictionary   *dataDict;
    NSString       *types;
    NSString       *talk_id;
    int page;
     CGRect tableFrame;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    
    
    _tableView.frame = CGRectMake(0, 0, viewWidth, self.view.bounds.size.height);
    
  //  [self headerRereshing];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BASECOLOR;
    contentArray = [NSMutableArray array];
    
    page = 2;
    
   [self createUIWithtableFrame:CGRectMake(0, 0, viewWidth, self.view.bounds.size.height)];
    // 2.集成刷新控件
    [self setupRefresh];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing) dateKey:@"table"];
    
    [_tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
}
#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    NSString *URL;
    if ([_type isEqualToString:@"myQuestion"]) {
        URL = [NSString stringWithFormat:@"%@api/?method=questions.personal_center&user_id=%@",BASEURL,_user_id];
    } else {
        URL = [NSString stringWithFormat:@"%@api/?method=questions.index",BASEURL];
    }
    
    [HttpTool postWithUrl:URL params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        [contentArray removeAllObjects];
        page = 2;
        if ([[data objectForKey:@"data_list"] count] != 0) {
            for (NSDictionary *dict in [data objectForKey:@"data_list"]) {
                
                QuestionContent *contentModel = [[QuestionContent alloc]
                                                 initWithDictionary:dict];
                [contentArray addObject:contentModel];
            }
           
        }
         [_tableView reloadData];
        // 结束刷新状态
        [_tableView headerEndRefreshing];
    }];
}

- (void)footerRereshing
{
    NSString *URL;
    if ([_type isEqualToString:@"myQuestion"]) {
        URL = [NSString stringWithFormat:@"%@api/?method=questions.personal_center&user_id=%@&page=%d",BASEURL,_user_id,page];
    } else {
        URL = [NSString stringWithFormat:@"%@api/?method=questions.index&page=%d",BASEURL,page];
    }
    
    [HttpTool postWithUrl:URL params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        NSDictionary *data = [responseObject objectForKey:@"data"];
        
        if ([[data objectForKey:@"data_list"] count] != 0) {
            for (NSDictionary *dict in [data objectForKey:@"data_list"]) {
                
                QuestionContent *contentModel = [[QuestionContent alloc]
                                                 initWithDictionary:dict];
                [contentArray addObject:contentModel];
            }
            [_tableView reloadData];
            page++;
        } else {
            _tableView.footerRefreshingText = @"没有新的数据了...";
        }
        // 结束刷新状态
        [_tableView footerEndRefreshing];
    }];
}

- (void)createUIWithtableFrame:(CGRect )frame {
    
    
  
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
//    textView = [[TextFieldView alloc] initWithFrame:CGRectMake(0, viewHeight - NavigationBar_Height, viewWidth, Adaptive(42))];
//   // [textView.publishButton addTarget:self action:@selector(CommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    textView.backgroundColor = [UIColor colorWithRed:201/255.0
//                                               green:205/255.0
//                                                blue:211/255.0
//                                               alpha:1];
//    textView.textField.backgroundColor = [UIColor colorWithRed:187/255.0
//                                                         green:194/255.0
//                                                          blue:201/255.0
//                                                         alpha:1];
//  
    
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tableView.backgroundColor = BASECOLOR;
    
    [self.view addSubview:_tableView];
    
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    publishButton.frame     = CGRectMake(Adaptive(13),
                                         LastHeight - Adaptive(84),
                                         Adaptive(40),
                                         Adaptive(40));
    [publishButton addTarget:self action:@selector(publishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setBackgroundImage:[UIImage imageNamed:@"find_questionPublish"] forState:UIControlStateNormal];
    [self.view addSubview:publishButton];
    
}
- (void)publishButtonClick:(UIButton *)button {
    
    if ([HttpTool judgeWhetherUserLogin]) {
        FinderPubViewController *publish = [FinderPubViewController new];
        publish.className = @"答疑";
        [self.navigationController pushViewController:publish animated:YES];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        alert.tag = 999;
        [alert show];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return Adaptive(0.001);
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return Adaptive(0.001);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return contentArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QuestionContent *contentModel = contentArray[section];
    // 内容 + 评论 + 回复数组长度
    NSInteger length;
    
    if ([contentModel.commentdict count] == 0) {
        length = 1 ;
    } else if (contentModel.replyArray.count == 0) {
        length = 2 ;
    } else {
        length = 1 + 1 + contentModel.replyArray.count ;
    }
    return length;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        
        // 答疑的内容cell
        QuestionContent *content = contentArray[indexPath.section];
        static NSString *contentCellidentifier   = @"contentcell";
        
        QuestionContentCell *questionCell = [tableView dequeueReusableCellWithIdentifier:contentCellidentifier];
        if (!questionCell)
        {
            questionCell = [[QuestionContentCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:contentCellidentifier];
            questionCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        questionCell.contentModel = content;
        
        return questionCell;
    } else if (indexPath.row == 1) {
        
        // 答疑的评论cell
        static NSString *commentCellidentifier = @"commentcell";
        
        QuestionCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCellidentifier];
        if (!cell)
        {
            cell = [[QuestionCommentCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:commentCellidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        QuestionContent *content = contentArray[indexPath.section];
        cell.contentModel = content;
        
        return cell;
        
    } else  {
        // 答疑的回复cell
        
        
        static NSString *replycellidentifier = @"replycell";
        
        QuestionReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:replycellidentifier];
        if (!cell)
        {
            cell = [[QuestionReplyCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:replycellidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        QuestionContent *content  = contentArray[indexPath.section];
        QuestionReply *replyModel = content.replyArray[indexPath.row - 2];
        cell.reply                = replyModel;
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *blackView = [UIView new];
    blackView.backgroundColor = BASECOLOR;
    return blackView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /**
     *
     *  不追问  点击直接删除
     */
    
    QuestionContent *content = contentArray[indexPath.section];
    
   // NSLog(@"user_id %@  talkid %@",content.user_id,content.talk_id);
    talk_id = content.talk_id;
    if ([[HttpTool getUser_id] isEqualToString:content.user_id]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"删除", nil];
        [actionSheet showInView:self.view];
        
    }
//    
//    
//    if (indexPath.row > 2) {
//        
//        QuestionReply   *reply   = content.replyArray[indexPath.row - 2];
//        
//        if ([reply.isClick isEqualToString:@"1"]) {
//            [textView.textField becomeFirstResponder];
//            [self.view addSubview:textView];
//            NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//            
//            // 让table滚动到对应的indexPath位置
//            [_tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//            comment_id = content.comment_id;
//            reply_id   = reply.reply_id;
//            types      = @"2";  // 回复的是回复
//        }
//    }
//    if ([content.isClick isEqualToString:@"1"] && indexPath.row == 1) {
//        [textView.textField becomeFirstResponder];
//        [self.view addSubview:textView];
//        
//        NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
//        // 让table滚动到对应的indexPath位置
//        [_tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//        
//        comment_id = content.comment_id;
//        types      = @"1";// 回复的是评论
//    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSString *url = [NSString stringWithFormat:@"%@api/?method=questions.deletetalk&talkid=%@",BASEURL,talk_id];
            [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress *progress) {
                
            } success:^(id responseObject) {
                [self headerRereshing];
                
                NSNotification *notification =[NSNotification notificationWithName:@"refushAllUI" object:nil userInfo:nil];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }];
        }
            break;
        case 1:
    
            break;
       
        default:
            break;
    }
}

//#pragma mark - 回复按钮点击事件
//- (void)CommentButtonClick:(UIButton *)button {
//    
//    [textView.textField resignFirstResponder];
//    
//    if ([types isEqualToString:@"1"]) {
//        dataDict = @{@"comment_id":comment_id,
//                     @"types":types,
//                     @"content":textView.textField.text,
//                     };
//    } else {
//        dataDict = @{@"comment_id":comment_id,
//                     @"types":types,
//                     @"content":textView.textField.text,
//                     @"rid":reply_id
//                     };
//    }
//    
//    NSString *url = [NSString stringWithFormat:@"%@api/?method=questions.replay",BASEURL];
//    
//    
//    [HttpTool postWithUrl:url params:dataDict body:nil progress:^(NSProgress * progress) {
//        
//    } success:^(id responseObject) {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[responseObject objectForKey:@"msg"] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
//        
//        [alert show];
//    }];
//    
//}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999) {
        
        if (buttonIndex == 1) {
            NSNotification *notification =[NSNotification notificationWithName:@"pushLoginView" object:nil userInfo:nil];
            
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    } else{
        if (buttonIndex == 0) {
            //重新请求数据
            textView.textField.text = @"";
            [self headerRereshing];
            
        }
    }
}

////表随键盘高度变化
//-(void)keyboardShow:(NSNotification *)note
//{
//    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat deltaY = keyBoardRect.size.height;
//    
//    if ([_type isEqualToString:@"myQuestion"]) {
//        textView.frame = CGRectMake(0, LastHeight - deltaY - Adaptive(22) - Adaptive(130), viewWidth, Adaptive(42));
//    } else {
//        textView.frame = CGRectMake(0, LastHeight - deltaY - Adaptive(22), viewWidth, Adaptive(42));
//    }
//    
//    
//}
//-(void)keyboardHide:(NSNotification *)note
//{
//    [textView.textField resignFirstResponder];
//    textView.frame = CGRectMake(0, viewHeight - NavigationBar_Height, viewWidth, Adaptive(42));
//    [textView removeFromSuperview];
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0) {
        QuestionContentCell *contentCell = (QuestionContentCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return contentCell.frame.size.height;
    } else if (indexPath.row == 1){
        QuestionCommentCell *commentCell = (QuestionCommentCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return commentCell.frame.size.height;
    } else  {
        QuestionReplyCell *replyCell = (QuestionReplyCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return replyCell.frame.size.height;
    }
    
    
}


@end
