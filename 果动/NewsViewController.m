//
//  NewsViewController.m
//  果动
//
//  Created by mac on 15/12/10.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "NewsViewController.h"
#import "Commonality.h"
#import "GBTableViewCell.h"
#import "NewsComment.h"
#import "GBViewController.h"
@interface NewsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *classBaseView;
    CGFloat height;
}
@property (nonatomic,retain) NSMutableArray *newsMutableArray;
@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    [self createUI];
    [self startRequest];

}
-(void)startRequest
{
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.irelated",BASEURL];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            self.newsMutableArray = [NSMutableArray array];
            for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
                NewsComment *news = [[NewsComment alloc] initWithDictionary:dict];
                [self.newsMutableArray addObject:news];
            }
            [_tableView reloadData];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError *error) {}];
}
-(void)createUI
{
    BackView *backView = [[BackView alloc] initWithbacktitle:@"果吧" viewController:self];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backView];
    self.navigationItem.leftBarButtonItem = backItem;
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight - NavigationBar_Height ) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.newsMutableArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsTableViewCell *cell = (NewsTableViewCell *)[self tableView:_tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsComment *news = [self.newsMutableArray objectAtIndex:indexPath.row];
    if ([news.type isEqualToString:@"2"]) {
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell"];
        if (!cell) {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newsCell"];
        }
        CGRect frame = [cell frame];
        
        cell.headImgeView.frame = CGRectMake(viewHeight/51.308, viewHeight/39.235, viewHeight/15.159, viewHeight/15.159);
        [cell.headImgeView setImageWithURL:news.headImageStr placeholderImage:[UIImage imageNamed:@"person_nohead"]];
        
        
        
        cell.headLabel.frame = CGRectMake(CGRectGetMaxX(cell.headImgeView.frame) + viewHeight/51.308, viewHeight/35.105, viewHeight/4.447, viewHeight/39.235);
        cell.headLabel.text = news.nickname;
        
        
        CGFloat contentWidth = viewWidth - CGRectGetMaxX(cell.headImgeView.frame) - viewHeight/51.308 - viewHeight/51.308 - viewHeight/13.34;
        
        cell.contentLabel.text = news.replay;
        cell.contentLabel.frame = CGRectMake(CGRectGetMaxX(cell.headImgeView.frame) + viewHeight/51.308, CGRectGetMaxY(cell.headLabel.frame) + viewHeight/190.571, contentWidth, viewHeight/39.235);
        height = CGRectGetMaxY(cell.contentLabel.frame);
        [cell addSubview:cell.contentLabel];
        
        
        cell.dateLabel.frame = CGRectMake(CGRectGetMaxX(cell.headImgeView.frame) + viewHeight/51.308, height +1, viewHeight/4.447, viewHeight/47.643);
        cell.dateLabel.text = news.dateStr;
        
        cell.photoImageView.frame = CGRectMake(viewWidth - viewHeight/13.34 - viewHeight/51.308, viewHeight/39.235, viewHeight/13.34, viewHeight/13.34);
        
        [cell.photoImageView setImageWithURL:news.phototStr placeholderImage:[UIImage imageNamed:@"base_logo"]];
        
        cell.line.frame = CGRectMake(viewHeight/51.308, CGRectGetMaxY(cell.dateLabel.frame) + viewHeight/60.636, viewWidth - viewHeight/25.654, .5);
        frame.size.height = CGRectGetMaxY(cell.line.frame);
        cell.frame = frame;
        return cell;
    } else {
        NewsTableViewZanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"newszanCell"];
        if (!cell) {
            cell = [[NewsTableViewZanCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"newszanCell"];
        }
        CGRect frame = [cell frame];
        
    
        cell.headImgeView.frame = CGRectMake(viewHeight/51.308, viewHeight/39.235, viewHeight/15.159, viewHeight/15.159);
        [cell.headImgeView setImageWithURL:news.headImageStr placeholderImage:[UIImage imageNamed:@"person_nohead"]];
        
        cell.headLabel.frame = CGRectMake(CGRectGetMaxX(cell.headImgeView.frame) + viewHeight/51.308, viewHeight/35.105, viewHeight/4.447, viewHeight/39.235);
        cell.headLabel.text = news.nickname;
        
        cell.zanImageView.image = [UIImage imageNamed:@"news_zan"];
        cell.zanImageView.frame = CGRectMake(CGRectGetMaxX(cell.headImgeView.frame) + viewHeight/51.308, CGRectGetMaxY(cell.headLabel.frame) + viewHeight/190.571, viewHeight/51.308, viewHeight/60.636);
        height = CGRectGetMaxY(cell.zanImageView.frame);
        [cell addSubview:cell.zanImageView];
        
        
        
        cell.dateLabel.frame = CGRectMake(CGRectGetMaxX(cell.headImgeView.frame) + viewHeight/51.308, height +1, viewHeight/4.447, viewHeight/47.643);
        cell.dateLabel.text = news.dateStr;
        
        cell.photoImageView.frame = CGRectMake(viewWidth - viewHeight/13.34 - viewHeight/51.308, viewHeight/39.235, viewHeight/13.34, viewHeight/13.34);
        
        [cell.photoImageView setImageWithURL:news.phototStr placeholderImage:[UIImage imageNamed:@"base_logo"]];
        
        cell.line.frame = CGRectMake(viewHeight/51.308, CGRectGetMaxY(cell.dateLabel.frame) + viewHeight/60.636, viewWidth - viewHeight/25.654, .5);
        frame.size.height = CGRectGetMaxY(cell.line.frame);
        cell.frame = frame;

        return cell;
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   NewsComment *news = [self.newsMutableArray objectAtIndex:indexPath.row];
    GBViewController *gbView = [GBViewController new];
    gbView.news_talkid = news.talk_id;
    gbView.isNews = @"news";
    [self.navigationController pushViewController:gbView animated:YES];
    
}
@end
