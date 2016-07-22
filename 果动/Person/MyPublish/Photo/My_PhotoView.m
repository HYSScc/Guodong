//
//  My_PhotoView.m
//  果动
//
//  Created by mac on 16/5/28.
//  Copyright © 2016年 Unique. All rights reserved.
//

#define colletionCell 4  //设置具体几列
#import "My_PhotoView.h"
#import "ImgScrollerView.h"
#import "TapImageView.h"
#import "AppDelegate.h"
@interface My_PhotoView ()<UICollectionViewDataSource,UICollectionViewDelegate,TapImageViewDelegate,ImgScrollViewDelegate,UIScrollViewDelegate>
{
    NSMutableArray *cellHeightArray;
    UICollectionView *collection;
    NSString    *user_id;
    NSMutableArray *dataArray;
    
    TapImageView *contentImageView;
    UIScrollView *myScrollView;
    UIView       *markView;
    UIView       *scrollPanel;
    NSInteger     currentIndex;
    AppDelegate *app;
    
}
@end

@implementation My_PhotoView

- (instancetype)initWithFrame:(CGRect)frame user_id:(NSString *)user
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = BASECOLOR;
        [self createUI];
        user_id = user;
        [self startRequest];
    }
    return self;
}

- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.photos&uid&user_id=%@",BASEURL,user_id];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        dataArray = [NSMutableArray array];
        dataArray = [responseObject objectForKey:@"data"];
        
       
        
        [collection reloadData];
    }];
}

- (void)createUI {
    
    cellHeightArray = [NSMutableArray array];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置横向还是竖向
    
    collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, self.bounds.size.height) collectionViewLayout:flowLayout];
    collection.delegate   = self;
    collection.dataSource = self;
    [collection setBackgroundColor:[UIColor clearColor]];
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self addSubview:collection];
    
    
    app = [UIApplication sharedApplication].delegate;
    
    scrollPanel = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    scrollPanel.alpha = 0;
    scrollPanel.backgroundColor = [UIColor clearColor];
    
    [app.window addSubview:scrollPanel];
    
    markView = [[UIView alloc] initWithFrame:scrollPanel.bounds];
    
    
    [scrollPanel addSubview:markView];
    
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    [scrollPanel addSubview:myScrollView];
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    
    
}

#pragma mark -- UICollectionViewDataSource
//定义展示UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CGSize contentSize = myScrollView.contentSize;
    contentSize.height = viewHeight;
    contentSize.width  = viewWidth * dataArray.count;
    myScrollView.contentSize = contentSize;
    
    return dataArray.count;
}
//定义展示section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionViewCell的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"UICollectionViewCell";
    UICollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    //移除cell
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    NSInteger remainder     = indexPath.row % colletionCell;
    NSInteger currentRow    = indexPath.row / colletionCell;
    CGFloat   currentHeight = [cellHeightArray[indexPath.row] floatValue];
    
    CGFloat positonX  = (viewWidth / colletionCell - 8) * remainder + 5 * (remainder + 1);
    CGFloat positionY = (currentRow + 1) * 5;
    for (NSInteger i = 0; i < currentRow; i++) {
        NSInteger position =  remainder + i * colletionCell;
        positionY          += [cellHeightArray[position] floatValue];
    }
    cell.frame = CGRectMake(positonX,
                            positionY,
                            viewWidth / colletionCell - 8,
                            currentHeight) ;//重新定义cell位置、宽高
    
    NSDictionary *dict     = dataArray[indexPath.row];
    
    UILabel *lineLabel = [UILabel new];
    lineLabel.frame    = CGRectMake(0, 0, viewWidth, Adaptive(10));
    lineLabel.backgroundColor = BASECOLOR;
    [self addSubview:lineLabel];
    
    contentImageView    = [TapImageView new];
    contentImageView.backgroundColor = BASEGRYCOLOR;
    contentImageView.tag = 10 + indexPath.row;
    contentImageView.frame           = CGRectMake(0, CGRectGetMaxY(lineLabel.frame),cell.frame.size.width , cell.frame.size.height);
    [contentImageView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"img"]]];
    contentImageView.tap_delegate = self;
    [cell.contentView addSubview:contentImageView];
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict     = dataArray[indexPath.row];
    CGFloat imageWidth     = [[dict objectForKey:@"width"]  floatValue] / 2;
    CGFloat imageHeight    = [[dict objectForKey:@"height"] floatValue] / 2;
    
    
    
    
    CGFloat height = (((viewWidth - 8 * colletionCell) / colletionCell) * imageHeight) / imageWidth;
    [cellHeightArray addObject:[NSString stringWithFormat:@"%f",height]];
    return  CGSizeMake(viewWidth / colletionCell - 8, height);  //设置cell宽高
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}



#pragma mark -
#pragma mark - custom method
- (void) addSubImgView
{
    for (UIView *tmpView in myScrollView.subviews)
    {
        [tmpView removeFromSuperview];
    }
    for (int i = 0; i < dataArray.count; i ++)
    {
        if (i == currentIndex)
        {
            continue;
        }
        
        TapImageView *tmpView = (TapImageView *)[self viewWithTag: 10+i];
        
        //转换后的rect
        CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:app.window];
        
        ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){i*myScrollView.bounds.size.width,0,myScrollView.bounds.size}];
        [tmpImgScrollView setContentWithFrame:convertRect];
        [tmpImgScrollView setImage:tmpView.image];
        [myScrollView addSubview:tmpImgScrollView];
        tmpImgScrollView.i_delegate = self;
        
        [tmpImgScrollView setAnimationRect];
    }
}

- (void) setOriginFrame:(ImgScrollView *) sender
{
    [UIView animateWithDuration:0.4 animations:^{
        [sender setAnimationRect];
        markView.alpha = 1.0;
    }];
}

#pragma mark -
#pragma mark - custom delegate
- (void)tappendWithObject:(id)sender
{
    
    markView.alpha = 0.0;
    markView.backgroundColor = [UIColor blackColor];
    
    [self bringSubviewToFront:scrollPanel];
    scrollPanel.alpha = 1.0;
    
    TapImageView *tmpView = sender;
    currentIndex = tmpView.tag - 10;
     NSLog(@"currentIndex %ld",(long)currentIndex);
    
    
    //转换后的rect
    CGRect convertRect = [[tmpView superview] convertRect:tmpView.frame toView:app.window];
    
    
    
    CGPoint contentOffset = myScrollView.contentOffset;
    contentOffset.x = currentIndex * viewWidth;
    myScrollView.contentOffset = contentOffset;
    NSLog(@"contentOffset %f",contentOffset.x);
    //添加
    [self addSubImgView];
    
    ImgScrollView *tmpImgScrollView = [[ImgScrollView alloc] initWithFrame:(CGRect){contentOffset,myScrollView.bounds.size}];
    [tmpImgScrollView setContentWithFrame:convertRect];
    [tmpImgScrollView setImage:tmpView.image];
    [myScrollView addSubview:tmpImgScrollView];
    tmpImgScrollView.i_delegate = self;
    
    [self performSelector:@selector(setOriginFrame:) withObject:tmpImgScrollView afterDelay:0.1];
}

- (void) tapImageViewTappedWithObject:(id)sender
{
    
    ImgScrollView *tmpImgView = sender;
    
    [UIView animateWithDuration:0.5 animations:^{
        markView.alpha = 0;
        [tmpImgView rechangeInitRdct];
    } completion:^(BOOL finished) {
        scrollPanel.alpha = 0;
    }];
    
}

#pragma mark -
#pragma mark - scroll delegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    currentIndex = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    NSLog(@"currentIndex %ld",(long)currentIndex);
}
@end
