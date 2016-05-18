//
//  ShopView.m
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ShopView.h"
#import "ShopModel.h"
#import "ShopTableViewCell.h"

@interface ShopView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ShopView
{
    UITableView    *_tableView;
    NSMutableArray *modelArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASECOLOR;
        [self createUI];
        [self startRequest];
    }
    return self;
}

- (void)startRequest {
    
    NSString* url = [NSString stringWithFormat:@"%@api/?method=gdcourse.gdstore", BASEURL];
    [HttpTool postWithUrl:url params:nil success:^(id responseObject) {
        modelArray = [NSMutableArray array];
        for (NSDictionary* dict in [responseObject objectForKey:@"data"]) {
            ShopModel* rightModel = [[ShopModel alloc] initWithDictionary:dict];
            [modelArray addObject:rightModel];
        }
        [_tableView reloadData];
    }];
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
- (UIView*)tableView:(UITableView*)tableView viewForFooterInSection:(NSInteger)section
{
    
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    ShopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[ShopTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    CGRect frame = [cell frame];
    ShopModel *shopModel = modelArray[indexPath.row];
    [cell.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:shopModel.image]];
    CGSize titleSize     = [shopModel.name sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(17)] }];
    cell.titleName.frame = CGRectMake(Adaptive(13), (cell.alphaView.frame.size.height - Adaptive(17)) / 2, titleSize.width, Adaptive(17));
    cell.titleName.text  = shopModel.name;
    
    CGSize branchSize     = [shopModel.place sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:FONT size:Adaptive(15)] }];
    cell.branchName.frame = CGRectMake(viewWidth - Adaptive(13) - branchSize.width, (cell.alphaView.frame.size.height - Adaptive(15)) / 2, branchSize.width, Adaptive(15));
    cell.branchName.text  = shopModel.place;
    
    frame.size.height     = CGRectGetMaxY(cell.alphaView.frame) + Adaptive(5);
    cell.frame            = frame;
    
    return cell;
    
}
- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // ShopModel* rightModel = [self.modelArray objectAtIndex:indexPath.row];
    // HomeController* home = [HomeController sharedViewControllerManager];
    // NSString* titleString = @"体验店";
    
    //home.pushShopVCBlock(rightModel.number, titleString); //跳转到体验店界面
}
- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    ShopTableViewCell * cell = (ShopTableViewCell*)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

@end
