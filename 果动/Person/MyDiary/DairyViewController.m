//
//  DairyViewController.m
//  果动
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "MyDairyModel.h"
#import "MyDairyCoachCell.h"
#import "MyDairyPhotoCell.h"
#import "MyDairyUserCell.h"
#import "DairyViewController.h"
#import "LoginViewController.h"
#import "TextFieldView.h"

@interface DairyViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation DairyViewController
{
    NSMutableArray *dataArray;
    UITableView    *_tableView;
    TextFieldView  *textFieldView;
    NSString       *dairy_id;
    int page;
     UIView         *noDataView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"健身日记" viewController:self];
    [self.view addSubview:navigation];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
    
    textFieldView       = [[TextFieldView alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, Adaptive(42))];
    textFieldView.backgroundColor = [UIColor colorWithRed:201/255.0
                                                    green:205/255.0
                                                     blue:211/255.0
                                                    alpha:1];
    textFieldView.textField.backgroundColor = [UIColor colorWithRed:187/255.0
                                                              green:194/255.0
                                                               blue:201/255.0
                                                              alpha:1];
    [textFieldView.publishButton addTarget:self action:@selector(CommentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    page = 1;
    dataArray = [NSMutableArray array];
    
    
    [self createUI];
    
    
    if ([HttpTool judgeWhetherUserLogin]) {
        
        // 2.集成刷新控件
        [self setupRefresh];
         _tableView.bounces = YES;
    } else {
        _tableView.bounces = NO;
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
- (void)addNoDataView {
      // person_data_ring
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
    NSString *url = [NSString stringWithFormat:@"%@api/?method=diary.index",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        [dataArray removeAllObjects];
        page = 1;
        if ([[responseObject objectForKey:@"data"] count] != 0) {
            _tableView.bounces = YES;
            [noDataView removeFromSuperview];
            for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
                MyDairyModel *dairyModel = [[MyDairyModel alloc] initWithDictionary:dict];
                [dataArray addObject:dairyModel];
            }
        } else {
            _tableView.bounces = NO;
        }
        [_tableView reloadData];
        [_tableView headerEndRefreshing];
    }];
}

- (void)footerRereshing
{
    NSString *url = [NSString stringWithFormat:@"%@api/?method=diary.index&page=%d",BASEURL,page];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"data"] count] != 0) {
            for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
                MyDairyModel *dairyModel = [[MyDairyModel alloc] initWithDictionary:dict];
                [dataArray addObject:dairyModel];
            }
            [_tableView reloadData];
            page++;
        } else {
            _tableView.footerRefreshingText = @"没有新的数据了...";
        }
        [_tableView footerEndRefreshing];
    }];
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight - NavigationBar_Height) style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = BASECOLOR;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:_tableView];
    
    
    noDataView = [UIView new];
    noDataView.frame = CGRectMake(0, 0, viewWidth, viewHeight - NavigationBar_Height);
    [_tableView addSubview:noDataView];
    
    UILabel *orangeLabel = [UILabel new];
    orangeLabel.frame = CGRectMake(Adaptive(13), 0, 1, viewHeight - NavigationBar_Height);
    orangeLabel.backgroundColor = ORANGECOLOR;
    [noDataView addSubview:orangeLabel];
    
    
    UIImageView *ring = [UIImageView new];
    ring.frame        = CGRectMake(Adaptive(6), Adaptive(20), Adaptive(14), Adaptive(14));
    ring.image        = [UIImage imageNamed:@"person_data_ring"];
    [noDataView addSubview:ring];
    
    UILabel  *titleLabel = [UILabel new];
    titleLabel.frame     = CGRectMake(CGRectGetMaxX(ring.frame) + Adaptive(6),
                                      Adaptive(20),
                                      Adaptive(100),
                                      Adaptive(15));
    titleLabel.text      = @"暂无日记";
    titleLabel.textColor = ORANGECOLOR;
    titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(14)];
    [noDataView addSubview:titleLabel];
    
    UILabel *bigLine = [UILabel new];
    bigLine.frame    = CGRectMake(CGRectGetMaxX(ring.frame) + Adaptive(6), CGRectGetMaxY(titleLabel.frame) + Adaptive(2),
                                  viewWidth - (CGRectGetMaxX(ring.frame) + Adaptive(6))*2,
                                  Adaptive(2.5));
    bigLine.backgroundColor = BASEGRYCOLOR;
    [noDataView addSubview:bigLine];
    
    int lineNumber = (viewHeight - NavigationBar_Height - CGRectGetMaxY(bigLine.frame)) / 25;
    
    for (int a = 0; a < lineNumber; a++) {
        UILabel *line = [UILabel new];
        line.frame    = CGRectMake(CGRectGetMaxX(ring.frame) + Adaptive(6),
                                   CGRectGetMaxY(bigLine.frame) + 25 * (a + 1),
                                   viewWidth - (CGRectGetMaxX(ring.frame) + Adaptive(6))*2,
                                   .5);
        line.backgroundColor = BASEGRYCOLOR;
        [noDataView addSubview:line];
    }

    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MyDairyModel *dairyModel = dataArray[section];
    if (dairyModel.userContent.length == 0 && dairyModel.photoArray.count == 0)
    {
        return 1;
        
    } else if (dairyModel.userContent.length == 0 || dairyModel.photoArray.count == 0)
    {
        return 2;
        
    } else {
        
        return 3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyDairyModel *dairyModel = dataArray[indexPath.section];
    if (indexPath.row == 0) {
        static NSString *cellidentifier = @"coachCell";
        
        MyDairyCoachCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (cell == nil)
        {
            cell = [[MyDairyCoachCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
             cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dairy    = dairyModel;
       
        cell.nickName = _nickName;
        [cell.addUserButton addTarget:self action:@selector(addUserContentClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.row == 1) {
        
        if (dairyModel.photoArray.count != 0) {
            static NSString *cellidentifier = @"photoCell";
            
            MyDairyPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
            if (cell == nil)
            {
                cell = [[MyDairyPhotoCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.dairy = dairyModel;
            [cell.addUserButton addTarget:self action:@selector(addUserContentClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        } else {
            static NSString *cellidentifier = @"userCell";
            
            MyDairyUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
            if (cell == nil)
            {
                cell = [[MyDairyUserCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.dairy = dairyModel;
            [cell.addUserButton addTarget:self action:@selector(addUserContentClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        
    } else {
        static NSString *cellidentifier = @"userCell";
        
        MyDairyUserCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (cell == nil)
        {
            cell = [[MyDairyUserCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.dairy = dairyModel;
        [cell.addUserButton addTarget:self action:@selector(addUserContentClick:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    MyDairyModel *dairyModel = dataArray[indexPath.section];
    if (indexPath.row == 0) {
        MyDairyCoachCell *cell = (MyDairyCoachCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
        
    } else if (indexPath.row == 1) {
        
        if (dairyModel.photoArray.count != 0) {
            MyDairyPhotoCell *cell = (MyDairyPhotoCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
            
        } else {
            MyDairyUserCell *cell = (MyDairyUserCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
            return cell.frame.size.height;
        }
        
    } else {
        MyDairyUserCell *cell = (MyDairyUserCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
        return cell.frame.size.height;
    }
}
//表随键盘高度变化
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY = keyBoardRect.size.height;
    
    
    CGRect textFrame   = textFieldView.frame;
    
    textFrame.origin.y = viewHeight - NavigationBar_Height - deltaY - Adaptive(42);
    textFieldView.frame     = textFrame;
    
}
-(void)keyboardHide:(NSNotification *)note
{
    textFieldView.frame = CGRectMake(0, viewHeight  - NavigationBar_Height, viewWidth, Adaptive(42));
    [textFieldView.textField resignFirstResponder];
    [textFieldView removeFromSuperview];
}

- (void)addUserContentClick:(UIButton *)button {
    
    
    NSIndexPath *indexPath       = [_tableView indexPathForCell:(UITableViewCell *)button.superview];
    MyDairyModel *dairyModel     = dataArray[indexPath.section];
    dairy_id                     = dairyModel.dairy_id;
    textFieldView.textField.text = dairyModel.userContent;
    
    [textFieldView.textField becomeFirstResponder];
    [self.view addSubview:textFieldView];
}

- (void)CommentButtonClick:(UIButton *)button {
    [textFieldView.textField resignFirstResponder];
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=diary.update",BASEURL];
    NSDictionary *dict = @{@"id":dairy_id,
                           @"content":textFieldView.textField.text};
    [HttpTool postWithUrl:url params:dict body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        [self headerRereshing];
    }];
    
}
@end
