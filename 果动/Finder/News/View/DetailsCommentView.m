//
//  DetailsCommentView.m
//  果动
//
//  Created by mac on 16/5/23.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "PublishViewController.h"
#import "DetailsCommentView.h"
#import "ContentDetails.h"
#import "CommentModel.h"
#import "NewsDetailsReply.h"
#import "CommentTableViewCell.h"
#import "NewsDetailsReplyCell.h"

@interface DetailsCommentView ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@end

@implementation DetailsCommentView
{
    UITableView    *_tableView;
    NSInteger     tableHeight;
    NSMutableArray *commentArray;
    UIViewController *viewController;
    NSDictionary   *CommentDict;
    
}
- (instancetype)initWithFrame:(CGRect)frame ContentDetails:(ContentDetails *)details viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:55/255.0
                                               green:55/255.0
                                                blue:55/255.0
                                               alpha:1];
        
        viewController = controller;
        _details       = details;
        [self createUI];
        [self startRequest];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushUserPublick:) name:@"pushUserPublick" object:nil];
        
    }
    return self;
}

- (void)pushUserPublick:(NSNotification *)notification {
    PublishViewController *publish = [PublishViewController new];
    publish.user_id = [notification.userInfo objectForKey:@"user_id"];
    [viewController.navigationController pushViewController:publish animated:YES];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushUserPublick" object:nil];
}


- (void)startRequest {
    
    commentArray = [NSMutableArray array];
    for (NSDictionary *commentDict in _details.commentsArray) {
        CommentModel *commentModel = [[CommentModel alloc] initWithDictionary:commentDict];
        [commentArray addObject:commentModel];
    }
    [_tableView reloadData];
    
}
- (void)createUI {
    
    
    UIView *headView = [UIView new];
    headView.frame   = CGRectMake(0, 0, viewWidth, Adaptive(40));
    
    
    UILabel *label  = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(13),
                                                                Adaptive(13),
                                                                Adaptive(100),
                                                                Adaptive(14))];
    label.textColor = [UIColor whiteColor];
    label.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    label.text      = [NSString stringWithFormat:@"评论 %@",_details.commentNumber];
    [headView addSubview:label];
    
    UILabel *line = [UILabel new];
    line.frame    = CGRectMake(0, headView.bounds.size.height - .5, viewWidth, .5);
    line.backgroundColor = BASECOLOR;
    [headView addSubview:line];
    
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.bounds.size.height) style:UITableViewStylePlain];
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    _tableView.backgroundColor = BASEGRYCOLOR;
    _tableView.showsVerticalScrollIndicator = NO; //隐藏滑动线
    _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    _tableView.tableHeaderView = headView;
    _tableView.bounces = NO;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
    
    
    
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 重设tableView高度
    // /2 是因为8.0之后机制 heightForRowAtIndexPath 会重复2次
    CGRect tableFrame      = _tableView.frame;
    tableFrame.size.height  = tableHeight /2  + Adaptive(40);
    _tableView.frame        = tableFrame;
    
    
    CGRect selfFrame      = self.frame;
    selfFrame.size.height = tableHeight /2  + Adaptive(40);
    self.frame            = selfFrame;
    
    
    /********发通知改变scrollView高度********/
    
    NSDictionary *dict = @{@"height":[NSString stringWithFormat:@"%f",tableHeight /2  + Adaptive(40)]};
    NSNotification *notification =[NSNotification notificationWithName:@"changeHeight" object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    return commentArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CommentModel *commentModel = commentArray[section];
    NSInteger length;
    if (commentModel.replyArray.count == 0) {
        length = 1;
    } else {
        length = commentModel.replyArray.count + 1;
    }
    return length;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel *commentModel   = commentArray[indexPath.section];
    
    
    
    if (indexPath.row == 0) {
        static NSString *cellidentifier = @"CommentCell";
        CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (cell == nil)
        {
            cell = [[CommentTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
            // 单元格的选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        cell.comment = commentModel;
        return cell;
        
    } else {
        
        static NSString *cellidentifier = @"replyCell";
        NewsDetailsReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (cell == nil)
        {
            cell = [[NewsDetailsReplyCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
            // 单元格的选中样式
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        NewsDetailsReply *replyModel = commentModel.replyArray[indexPath.row - 1];
        cell.newsReply = replyModel;
        return cell;
        
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 0) {
        CommentTableViewCell *commentCell = (CommentTableViewCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        
        tableHeight = tableHeight + commentCell.frame.size.height;
        
        return commentCell.frame.size.height;
        
    } else {
        
        NewsDetailsReplyCell *replyCell = (NewsDetailsReplyCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        tableHeight = tableHeight + replyCell.frame.size.height;
        
        return replyCell.frame.size.height;
        
    }
    
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CommentModel *commentModel   = commentArray[indexPath.section];
    
    
    //
    
    if (indexPath.row != 0) {
        // 回复
        NewsDetailsReply *replyModel = commentModel.replyArray[indexPath.row - 1];
        
        CommentDict = @{@"comment_id":commentModel.comment_id,
                        @"distinguish":@"reply",
                        @"reply_id":replyModel.reply_id,
                        @"nickName":replyModel.targetName
                        };
        
        if ([[HttpTool getUser_id] isEqualToString:replyModel.user_id]) {
            // 回复 删除
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"删除", nil];
            actionSheet.tag = 996;
            [actionSheet showInView:self];
        } else {
            // 回复 举报
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复回复",@"举报回复", nil];
//            actionSheet.tag = 997;
//            [actionSheet showInView:self];
            NSNotification *notification =[NSNotification notificationWithName:@"distinguish" object:nil userInfo:CommentDict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    } else {
        // 评论
        
        CommentDict  = @{@"comment_id":commentModel.comment_id,@"distinguish":@"comment",@"nickName":commentModel.nickName};
        if ([[HttpTool getUser_id] isEqualToString:commentModel.user_id]) {
            // 回复 删除
            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复",@"删除", nil];
            actionSheet.tag = 998;
            [actionSheet showInView:self];
        } else {
            // 回复 举报
//            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"回复评论",@"举报评论", nil];
//            actionSheet.tag = 999;
//            [actionSheet showInView:self];
            NSNotification *notification =[NSNotification notificationWithName:@"distinguish" object:nil userInfo:CommentDict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            NSNotification *notification =[NSNotification notificationWithName:@"distinguish" object:nil userInfo:CommentDict];
            //通过通知中心发送通知
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
            break;
        case 1:
            if (actionSheet.tag == 996) {
                
                NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.delete&types=replay&id=%@",BASEURL,[CommentDict objectForKey:@"reply_id"]];
                NSNotification *notification =[NSNotification notificationWithName:@"removeComment" object:nil userInfo:@{@"url":url}];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
                
                NSLog(@"删除回复 %@",url);
            } else if (actionSheet.tag == 997){
                NSLog(@"举报回复");
            } else if (actionSheet.tag == 998){
               
                 NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.delete&types=comment&id=%@",BASEURL,[CommentDict objectForKey:@"comment_id"]];
                 NSLog(@"删除评论 %@",url);
                NSNotification *notification =[NSNotification notificationWithName:@"removeComment" object:nil userInfo:@{@"url":url}];
                //通过通知中心发送通知
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            } else {
                NSLog(@"举报评论");
            }
            break;
        case 2:
            NSLog(@"取消");
            break;
            
        default:
            break;
    }
}

@end
