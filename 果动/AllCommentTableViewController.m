//
//  AllCommentTableViewController.m
//  果动
//
//  Created by mac on 16/6/13.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "AllCommentTableViewController.h"
#import "IntroduceComment.h"
#import "IntroduceCommentCell.h"
#import "AppDelegate.h"
@interface AllCommentTableViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) NSMutableArray *commentArray;

@property (nonatomic,retain) UITableView    *tableView;
@end

@implementation AllCommentTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"所有评价" viewController:self];
    
  
    
    [self.view addSubview:navigation];
   
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, viewHeight - NavigationBar_Height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = BASECOLOR;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.separatorStyle  = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self startRequest];
}

- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=order.feeds&class_id=%@",BASEURL,_class_id];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        _commentArray = [NSMutableArray array];
        
        for (NSDictionary *dict  in [responseObject objectForKey:@"data"]) {
            IntroduceComment *comment = [[IntroduceComment alloc] initWithDictionary:dict];
            [_commentArray addObject:comment];
        }
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _commentArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    IntroduceCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[IntroduceCommentCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.selectionStyle = UITableViewCellEditingStyleNone;
    }
    IntroduceComment *comment = _commentArray[indexPath.row];
    cell.comment              = comment;
    return cell;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    IntroduceCommentCell *cell = (IntroduceCommentCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

@end
