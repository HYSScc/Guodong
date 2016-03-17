//
//  RightVBaseView.m
//  果动
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 Unique. All rights reserved.
//


#import "HomeController.h"
#import "RightCell.h"
#import "RightModel.h"
#import "RightVBaseView.h"
@implementation RightVBaseView {
    UITableView* _tableView;
}

- (id)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame]; // 先调用父类的initWithFrame方法
    if (self) {
        [self createUI];
        [self startrequest];
    }
    return self;
}
- (void)startrequest
{
    NSString* url = [NSString stringWithFormat:@"%@api/?method=gdcourse.gdstore", BASEURL];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            self.modelArray = [NSMutableArray array];
            for (NSDictionary* dict in [responseObject objectForKey:@"data"]) {
                RightModel* rightModel = [[RightModel alloc] initWithDictionary:dict];
                [self.modelArray addObject:rightModel];
            }
            [_tableView reloadData];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    }fail:^(NSError* error){}];
}
- (void)createUI
{

    _tableView                 = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                               0,
                                                                               viewHeight,
                                                                               viewHeight - NavigationBar_Height - Tabbar_Height - Adaptive(50))
                                                                               style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.delegate        = self;
    _tableView.dataSource      = self;
    [self addSubview:_tableView];
}

- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    NSLog(@"asdfadsfasf");
    UIView* footView        = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(80))];

    UILabel* footLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                        (footView.frame.size.height - Adaptive(15)) / 2,
                                                                        viewWidth,
                                                                        Adaptive(15))];
    footLabel.text          = @"我们正在努力扩大中...";
    footLabel.textAlignment = 1;
    footLabel.font          = [UIFont fontWithName:@"Arial-BoldMT" size:Adaptive(15)];
    footLabel.textColor     = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1];
    [footView addSubview:footLabel];
    return footView;
}
- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return Adaptive(80);
}
- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.modelArray.count;
}
- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    static NSString* cellIdentifier = @"cell";
    RightCell* cell                 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell     = [[RightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    CGRect frame = [cell frame];

    RightModel* rightModel = [self.modelArray objectAtIndex:indexPath.row];
    
    // 分线程处理耗时的逻辑事件
   [GCDQueue executeInGlobalQueue:^{
       
       NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:rightModel.image]];
       UIImage *image = [UIImage imageWithData:imageData];
       
       // 主线程更新UI
       [GCDQueue executeInMainQueue:^{
         cell.backgroundImageView.image = image;
    }];
}];

    CGSize titleSize     = [rightModel.name sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(17)] }];
    cell.titleName.frame = CGRectMake(Adaptive(13), (cell.alphaView.frame.size.height - Adaptive(17)) / 2, titleSize.width, Adaptive(17));
    cell.titleName.text  = rightModel.name;

    CGSize branchSize     = [rightModel.place sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(15)] }];
    cell.branchName.frame = CGRectMake(viewWidth - Adaptive(13) - branchSize.width, (cell.alphaView.frame.size.height - Adaptive(15)) / 2, branchSize.width, Adaptive(15));
    cell.branchName.text  = rightModel.place;

    frame.size.height     = CGRectGetMaxY(cell.alphaView.frame) + Adaptive(5);
    cell.frame            = frame;
    return cell;
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    RightModel* rightModel = [self.modelArray objectAtIndex:indexPath.row];
    HomeController* home = [HomeController sharedViewControllerManager];
    NSString* titleString = @"体验店";
    
    home.pushShopVCBlock(rightModel.number, titleString); //跳转到体验店界面
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    RightCell* cell = (RightCell*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
@end
