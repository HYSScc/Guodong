//
//  DetailMoreLikeViewController.m
//  果动
//
//  Created by mac on 16/6/28.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "ContentDetails.h"
#import "DetailMoreLikeViewController.h"
#import "PublishViewController.h"
@interface DetailMoreLikeViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *_tableView;
}
@end

@implementation DetailMoreLikeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"加油" viewController:self];
    [self.view addSubview:navigation];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavigationBar_Height, viewWidth, LastHeight) style:UITableViewStylePlain];
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.rowHeight  = Adaptive(50);
    _tableView.backgroundColor = BASECOLOR;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _details.likeHeadImgArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.backgroundColor = BASECOLOR;
        cell.selectionStyle  = UITableViewCellEditingStyleNone;
    }
    
    NSDictionary *priseDict = _details.likeHeadImgArray[indexPath.row];
    NSURL *priseURL         = [NSURL URLWithString:[priseDict objectForKey:@"headimg"]];
    
    UIImageView *headImageView = [UIImageView new];
    headImageView.frame        = CGRectMake(Adaptive(13), Adaptive(9), Adaptive(32), Adaptive(32));
    headImageView.layer.cornerRadius  = headImageView.bounds.size.width / 2;
    headImageView.layer.masksToBounds = YES;
    [headImageView sd_setImageWithURL:priseURL placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    [cell addSubview:headImageView];
    
    
    UILabel *nickName = [UILabel new];
    nickName.frame    = CGRectMake(CGRectGetMaxX(headImageView.frame) + Adaptive(10),
                                   Adaptive(17.5),
                                   viewWidth - CGRectGetMaxX(headImageView.frame) - Adaptive(31),
                                   Adaptive(15));
    nickName.textColor = [UIColor whiteColor];
    nickName.font      = [UIFont fontWithName:FONT size:Adaptive(13)];
    nickName.text      = [priseDict objectForKey:@"nickname"];
    [cell addSubview:nickName];
    
    UILabel *line = [UILabel new];
    line.frame    = CGRectMake(0, Adaptive(49.5), viewWidth, .5);
    line.backgroundColor = BASEGRYCOLOR;
    [cell addSubview:line];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     NSDictionary *priseDict = _details.likeHeadImgArray[indexPath.row];
    NSString *user_id = [NSString stringWithFormat:@"%@",[priseDict objectForKey:@"uid"]];
    PublishViewController *publish = [PublishViewController new];
    publish.user_id = user_id;
    [self.navigationController pushViewController:publish animated:YES];
}




@end
