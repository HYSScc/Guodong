//
//  LeftVBaseView.m
//  果动
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "Commonality.h"
#import "HomeController.h"
#import "LeftVBaseView.h"
#import "LocationView.h"
#import "leftModel.h"
#import "leftCollectionViewCell.h"
#define _CELL @ "acell"

@implementation LeftVBaseView {
    SDCycleScrollView* scrollView;
    UIScrollView* classScrollView;
    UIButton* changeButton;
    
    NSMutableArray* classnameArray;
    NSMutableArray* classnumberArray;
    NSMutableArray* class_idArray;
    NSMutableArray* class_imageArray;
    NSMutableArray* classArray;
    UIImageView* refushImageView;
    LocationView* locationView;
    UICollectionView *collectionClassView;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self startRequestScrollViewImage];
        [self startRequestClassNumber];
        [self createImage];
        //接收刷新左视图的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshLeftView) name:@"refreshLeftView" object:nil];
    }
    return self;
}
-(void)refreshLeftView
{
    [self startRequestScrollViewImage];
    [self startRequestClassNumber];
}
- (void)startRequestClassNumber
{
    //获取课程数量
    NSString* classnumberURL = [NSString stringWithFormat:@"%@api/?method=index.index", BASEURL];
    
    [HttpTool postWithUrl:classnumberURL params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        
        if (ResponseObject_RC == 0) {
            
            classArray = [NSMutableArray array];
            for (NSDictionary* dict in [responseObject objectForKey:@"data"]) {
                leftModel *left = [[leftModel alloc] initWithDictionary:dict];
                [classArray addObject:left];
            }
            [self createLabel];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError* error){}];
}
- (void)startRequestScrollViewImage
{
    //获取scrollView的图片
    NSString* url1 = [NSString stringWithFormat:@"%@indexImg/", BASEURL];
    [HttpTool postWithUrl:url1 params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        self.scrimgArray = responseObject;
        if (self.scrimgArray) {
            scrollView.imageURLStringsGroup = self.scrimgArray;
        }
    } fail:^(NSError* error){}];
}
- (void)createLabel
{
    UICollectionViewFlowLayout *collectFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    collectFlowLayout.minimumLineSpacing = 1;
    collectFlowLayout.minimumInteritemSpacing = 0;
    
    collectionClassView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame) , viewWidth, viewWidth+2) collectionViewLayout:collectFlowLayout];
    [collectionClassView registerClass:[leftCollectionViewCell class] forCellWithReuseIdentifier:_CELL];
    collectionClassView.backgroundColor = [UIColor whiteColor];
    collectionClassView.dataSource = self;
    collectionClassView.delegate = self;
    [self addSubview:collectionClassView];
}
- (void)createImage
{
    locationView = [LocationView sharedViewManager];
    if (IS_IPhone6plus) {
        scrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 146)];
    } else if (IS_IPHONE5S) {
        scrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 103)];
    } else {
        scrollView = [[SDCycleScrollView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, Adaptive(125))];
    }
    scrollView.backgroundColor    = [UIColor clearColor];
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    scrollView.pageControlStyle   = SDCycleScrollViewPageContolStyleAnimated;
    scrollView.autoScrollTimeInterval = 5.0;
    [self addSubview:scrollView];
}
#pragma mark --UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section
{
    return classArray.count;
}
//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath
{
    leftCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier : _CELL forIndexPath :indexPath];
    leftModel *left = [classArray objectAtIndex:indexPath.row];
    cell.classNameLabel.text = left.left_name;
    cell.classNumberLabel.text = [NSString stringWithFormat:@"%@节课被预定", left.left_num];
    if (![left.left_image isEqual:[NSNull class]]) {
        [cell.classImageView setImageWithURL:[NSURL URLWithString:left.left_image] placeholderImage:[UIImage imageNamed:@"shouye_moren"]];
    }
    return cell;
}
#pragma mark --UICollectionViewDelegate

//返回这个UICollectionViewCell是否可以被选择
-( BOOL )collectionView:( UICollectionView *)collectionView shouldSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    leftModel *left = [classArray objectAtIndex:indexPath.row];
    if (left.status) {
        return left.status == 1 ? YES : NO;
    } else {
        return YES;
    }
    
}

//UICollectionView被选中时调用的方法
-( void )collectionView:( UICollectionView *)collectionView didSelectItemAtIndexPath:( NSIndexPath *)indexPath
{
    leftCollectionViewCell * cell = ( leftCollectionViewCell *)[collectionView cellForItemAtIndexPath :indexPath];
     leftModel *left = [classArray objectAtIndex:indexPath.row];
    [UIView animateWithDuration:.3 animations:^{
        CGRect rect = cell.frame;
        rect.origin.x += 1.5;
        rect.origin.y += 1.5;
        cell.frame = rect;
    } completion:^(BOOL finished) {
        CGRect rect = cell.frame;
        rect.origin.x -= 1.5;
        rect.origin.y -= 1.5;
        cell.frame = rect;
        [UIView animateWithDuration:.3 animations:^{} completion:^(BOOL finished) {
                             HomeController* home = [HomeController sharedViewControllerManager];
                            //   home.pushClassVCBlock(left.left_name, [left.left_id intValue]);
                             if (locationView.dingwei == YES && locationView.isCitys == YES){
                                 //城市覆盖  定位成功
                                 home.pushClassVCBlock(left.left_name, [left.left_id intValue]);
                             } else if (locationView.dingwei == NO) {
                                 home.alertImageView.frame = CGRectMake(0, -viewHeight/13.34 , viewWidth, viewHeight/13.34);
                                 home.alertImageView.alpha = 1;
                                 home.alertImageBlock(@"locationing");
                             } else {
                                 home.alertImageView.frame = CGRectMake(0, -viewHeight/13.34 , viewWidth, viewHeight/13.34);
                                 home.alertImageView.alpha = 1;
                                 home.alertImageBlock(@"city_noCover");
                             }
                         }];
    }];
}
#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath
{
    return CGSizeMake ( (viewWidth - 1)/2, (viewWidth - 1)/2);
}

//定义每个UICollectionView 的边距
-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section
{
    return UIEdgeInsetsMake ( 1 , 0 , 1 , 0 );
}
@end
