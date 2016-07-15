//
//  NewsView.m
//  果动
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "NewsView.h"
#import "NewsCollectionViewCell.h"
#import "FinderViewController.h"

#import "ContentModel.h"

#define colletionCell 2 // 设置具体几列

@interface NewsView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray   *cellHeightArray;
    
}
@property (nonatomic,retain)  NSMutableArray  *contentArray;
@property (nonatomic,retain) UICollectionView *collection;
@property (nonatomic,assign) int page;
@end

@implementation NewsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASECOLOR;
        _contentArray = [NSMutableArray array];
        
        _page = 2;
        [self createUI];
        
    }
    return self;
}

- (void)createUI {
    
    cellHeightArray  = [NSMutableArray array];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置横向还是竖向
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, LastHeight - Adaptive(10)) collectionViewLayout:flowLayout];
    _collection.delegate   = self;
    _collection.dataSource = self;
    [_collection setBackgroundColor:[UIColor clearColor]];
    [_collection registerClass:[NewsCollectionViewCell class] forCellWithReuseIdentifier:@"NewsCollectionViewCell"];
    [self addSubview:_collection];
    
    
    
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    publishButton.frame     = CGRectMake(Adaptive(13),
                                         LastHeight - Adaptive(84),
                                         Adaptive(40),
                                         Adaptive(40));
    [publishButton addTarget:self action:@selector(publishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [publishButton setBackgroundImage:[UIImage imageNamed:@"find_newsPublish"] forState:UIControlStateNormal];
    [self addSubview:publishButton];
    
    
    // 2.集成刷新控件
    [self addHeader];
    [self addFooter];
}
- (void)addHeader
{
    __unsafe_unretained typeof(self) vc = self;
    // 添加下拉刷新头部控件
    [vc.collection addHeaderWithCallback:^{
        // 进入刷新状态就会回调这个Block
        NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.index",BASEURL];
        [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
            
        } success:^(id responseObject) {
            
            [vc.contentArray removeAllObjects];
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"data_list"] count] != 0) {
                for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"data_list"]) {
                    ContentModel *content = [[ContentModel alloc] initWithDictionary:dict];
                    [vc.contentArray addObject:content];
                }
                [vc.collection reloadData];
            }
            // 结束刷新
            [vc.collection headerEndRefreshing];
        }];
        
    } dateKey:nil];
    
    // 自动刷新(一进入程序就下拉刷新)
    [_collection headerBeginRefreshing];
}
- (void)addFooter
{
    __unsafe_unretained typeof(self) vc = self;
    
    
    // 添加上拉刷新尾部控件
    [vc.collection addFooterWithCallback:^{
        // 进入刷新状态就会回调这个Block
        
        NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.index&page=%d",BASEURL,vc.page];
        [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
            
        } success:^(id responseObject) {
            
            if ([[[responseObject objectForKey:@"data"] objectForKey:@"data_list"] count] != 0) {
                for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"data_list"]) {
                    ContentModel *content = [[ContentModel alloc] initWithDictionary:dict];
                    [vc.contentArray addObject:content];
                }
                [vc.collection reloadData];
                vc.page ++;
            }
            // 结束刷新
            [vc.collection footerEndRefreshing];
        }];
    }];
}

- (void)publishButtonClick:(UIButton *)button {
    
    if ([HttpTool judgeWhetherUserLogin]) {
        FinderViewController *finder = [FinderViewController sharedViewControllerManager];
        [finder pushPublishViewWithName:@"动态"];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }
    
    
   
}

#pragma mark -- UICollectionViewDataSource
//定义展示UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _contentArray.count;
}
//定义展示section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionViewCell的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier  = @"NewsCollectionViewCell";
    NewsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //移除cell
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    NSInteger remainder   = indexPath.row%colletionCell;
    NSInteger currentRow  = indexPath.row/colletionCell;
    CGFloat currentHeight = [cellHeightArray[indexPath.row] floatValue];
    
    CGFloat positonX  = (viewWidth / colletionCell - 8) * remainder + 5 * (remainder + 1);
    CGFloat positionY = (currentRow + 1) * 5;
    for (NSInteger i = 0; i < currentRow; i++) {
        NSInteger position = remainder + i * colletionCell;
        positionY += [cellHeightArray[position] floatValue];
    }
    cell.frame = CGRectMake(positonX,
                            positionY,
                            viewWidth / colletionCell - 8,
                            currentHeight) ;//重新定义cell位置、宽高
    
    ContentModel *contentModel = _contentArray[indexPath.row];
    cell.talk_id               = contentModel.tail_id;
    [cell.headerImage  sd_setImageWithURL:[NSURL URLWithString:contentModel.headImgUrl] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    [cell.contentImage sd_setImageWithURL:[NSURL URLWithString:contentModel.conetntImgArray[0]]];
    cell.nameLabel.text     = contentModel.nameString;
    cell.contentLabel.text  = contentModel.contentString;
    cell.likeLabel.text     = contentModel.likeNumber;
    cell.commentLabel.text  = contentModel.commentNumber;
    [cell.likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    if ([contentModel.isPraise intValue]== 0) {
        [cell.likeButton setImage:[UIImage imageNamed:@"find_nolike"] forState:UIControlStateNormal];
        
    } else {
        [cell.likeButton setImage:[UIImage imageNamed:@"find_like"] forState:UIControlStateNormal];
    }
    
    return cell;
}

- (void)likeButtonClick:(UIButton *)button
{
    
    if ([HttpTool judgeWhetherUserLogin]) {
        
        NSIndexPath *indexPath     = [_collection indexPathForCell:(NewsCollectionViewCell *)button.superview];
        ContentModel *contentModel = _contentArray[indexPath.row];
        NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.praise&talkid=%@",BASEURL,contentModel.tail_id];
        [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
            
        } success:^(id responseObject) {
            NSString *url = [NSString stringWithFormat:@"%@api/?method=gdb.index",BASEURL];
            [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
                
            } success:^(id responseObject) {
                
                [_contentArray removeAllObjects];
                if ([[[responseObject objectForKey:@"data"] objectForKey:@"data_list"] count] != 0) {
                    for (NSDictionary *dict in [[responseObject objectForKey:@"data"] objectForKey:@"data_list"]) {
                        ContentModel *content = [[ContentModel alloc] initWithDictionary:dict];
                        [_contentArray addObject:content];
                    }
                    [_collection reloadData];
                }
            }];
            
        }];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }
    
   
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSNotification *notification =[NSNotification notificationWithName:@"pushLoginView" object:nil userInfo:nil];
        
        //通过通知中心发送通知
        [[NSNotificationCenter defaultCenter] postNotification:notification];
        
    }
    
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = Adaptive(260);
    [cellHeightArray addObject:[NSString stringWithFormat:@"%f",height]];
    return  CGSizeMake(viewWidth/colletionCell-8, height);  //设置cell宽高
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0,0,0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FinderViewController *finder = [FinderViewController sharedViewControllerManager];
    ContentModel *contentModel = _contentArray[indexPath.row];
    [finder pushNewsDetailsViewWithindex:[contentModel.tail_id integerValue]];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
