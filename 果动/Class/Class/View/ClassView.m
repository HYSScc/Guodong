//
//  ClassView.m
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "RechargeViewController.h"
#import "ClassView.h"
#import "ClassTableViewCell.h"
#import "ClassViewController.h"

#import "ClassModel.h"
@interface ClassView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ClassView {
     UITableView     *_tableView;
    UIViewController *viewController;
}
- (instancetype)initWithFrame:(CGRect)frame viewController:(UIViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        viewController = controller;
    }
    return self;
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                               0,
                                                               self.bounds.size.width,
                                                               self.bounds.size.height)
                                              style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    _tableView.backgroundColor = BASECOLOR;
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _home.classArray.count + 1) {
        return Adaptive(20);
    } else {
        return Adaptive(125);
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.home.classArray.count + 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"index.row %ld",(long)indexPath.row);
    
    if (indexPath.row == 0) {
        
         static NSString *celllastidentifier = @"celllastidentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:celllastidentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:celllastidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        UILabel *line = [UILabel new];
        line.frame    = CGRectMake(0, 0, viewWidth, Adaptive(5));
        line.backgroundColor = BASECOLOR;
        [cell addSubview:line];
        
        UIImageView *contentImageView = [UIImageView new];
        contentImageView.frame        = CGRectMake(0, CGRectGetMaxY(line.frame), viewWidth, Adaptive(120));
        [contentImageView sd_setImageWithURL:[NSURL URLWithString:_home.rechargeImg]];
        [cell addSubview:contentImageView];
        
       
        return cell;
        
      
    } else if (indexPath.row - 1 == _home.classArray.count ) {
        
        NSLog(@"最后一行");
        static NSString *celllastidentifier = @"lastcell";
        
        LeftLastCell *cell = [tableView dequeueReusableCellWithIdentifier:celllastidentifier];
        if (cell == nil) {
            cell = [[LeftLastCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:celllastidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
        
        
        
       
    } else {
        
        static NSString *cellidentifier = @"cell";
        
        ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (cell == nil) {
            cell = [[ClassTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
       // NSLog(@"index   index  %d",indexPath.row - 1);
                ClassModel *classModel = self.home.classArray[indexPath.row - 1];
        
                [cell.baseImageView sd_setImageWithURL:[NSURL URLWithString:classModel.class_imageUrl]];
                cell.titleLabel.text       = classModel.class_name;
                cell.classNumberLabel.text = [NSString stringWithFormat:@"%@节课被预定",classModel.class_number];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.row == 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        RechargeViewController *rechargeVC = [RechargeViewController new];
        [viewController.navigationController pushViewController:rechargeVC animated:YES];
        viewController.hidesBottomBarWhenPushed = NO;
    } else {
        ClassModel *classModel    = self.home.classArray[indexPath.row - 1];
        ClassViewController *class = [ClassViewController sharedViewControllerManager];
        [class pushClassIntroduceView:classModel.class_id className:classModel.class_name classOrShip:@"class"];
    }
    
  
    
    
}

@end
