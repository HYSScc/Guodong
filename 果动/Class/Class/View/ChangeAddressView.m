//
//  ChangeAddressView.m
//  果动
//
//  Created by mac on 16/6/14.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ChangeAddressView.h"
#import "ChangeAddressModel.h"
#import "ChangeAddressCell.h"
@interface ChangeAddressView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChangeAddressView
{
    UITableView    *_tableView;
    NSMutableArray *addressArray;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self startRequest];
        self.backgroundColor = BASECOLOR;
    }
    return self;
}

- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=address.list",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        addressArray =[NSMutableArray array];
        
        for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
            ChangeAddressModel *changeAddress = [[ChangeAddressModel alloc] initWithDictionary:dict];
            [addressArray addObject:changeAddress];
        }
        [_tableView reloadData];
    }];
    
}

- (void)createUI {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) style:UITableViewStylePlain];
    _tableView.backgroundColor = BASECOLOR;
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return addressArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    ChangeAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[ChangeAddressCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
    }
    ChangeAddressModel *changeAddress = addressArray[indexPath.row];
    cell.address       = changeAddress;
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChangeAddressCell *cell = (ChangeAddressCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChangeAddressModel *changeAddress = addressArray[indexPath.row];
    NSDictionary *dict = @{@"address":changeAddress.address};
    NSNotification *notification = [NSNotification notificationWithName:@"changeAddress" object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}


@end
