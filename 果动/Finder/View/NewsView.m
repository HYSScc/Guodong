//
//  NewsView.m
//  果动
//
//  Created by mac on 16/5/19.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "NewsView.h"
#import "NewsCollectionViewCell.h"

#define colletionCell 2 // 设置具体几列

@interface NewsView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSMutableArray   *cellHeightArray;
    UICollectionView *collection;
}

@end

@implementation NewsView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASECOLOR;
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
    cellHeightArray  = [NSMutableArray array];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    // 设置横向还是竖向
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, LastHeight) collectionViewLayout:flowLayout];
    collection.delegate   = self;
    collection.dataSource = self;
    [collection setBackgroundColor:[UIColor clearColor]];
    [collection registerClass:[NewsCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self addSubview:collection];
}
#pragma mark -- UICollectionViewDataSource
//定义展示UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}
//定义展示section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionViewCell的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *identifier  = @"UICollectionViewCell";
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

    
     cell.contentLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    return cell;
    
    
}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height=Adaptive(260);
    [cellHeightArray addObject:[NSString stringWithFormat:@"%f",height]];
    return  CGSizeMake(viewWidth/colletionCell-8, height);  //设置cell宽高
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

#pragma mark --UICollectionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCollectionViewCell * cell = (NewsCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor greenColor];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

@end
