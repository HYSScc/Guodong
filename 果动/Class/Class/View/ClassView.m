//
//  ClassView.m
//  果动
//
//  Created by mac on 16/5/18.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "ClassView.h"
#import "ClassTableViewCell.h"

#import "ClassModel.h"
@interface ClassView ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ClassView {
     UITableView *_tableView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
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
    if (indexPath.row == self.home.classArray.count ) {
        return Adaptive(60);
    } else {
        return Adaptive(125);
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.home.classArray.count + 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == self.home.classArray.count ) {
        static NSString *celllastidentifier = @"lastcell";
        
        LeftLastCell *cell = [tableView dequeueReusableCellWithIdentifier:celllastidentifier];
        if (cell == nil) {
            cell = [[LeftLastCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:celllastidentifier ];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    } else {
        static NSString *cellidentifier = @"cell";
        
        ClassTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
        if (cell == nil) {
            cell = [[ClassTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier ];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ClassModel *classModel = self.home.classArray[indexPath.row];
        
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
}

@end
