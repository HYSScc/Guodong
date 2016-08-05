//
//  DataViewController.m
//  果动
//
//  Created by mac on 16/5/27.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "MyDataModel.h"
#import "DataViewController.h"
#import "DataCollectionViewCell.h"
#import "LoginViewController.h"
#import "ImgScrollerView.h"
#import "TapImageView.h"
@interface DataViewController ()<UIScrollViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,assign) int page;
@property (nonatomic,retain) UICollectionView *collectionView;
@end

@implementation DataViewController
{
    UIScrollView     *titleScrollView;
    UIScrollView     *dataScrollView;
    NSMutableArray   *dataArray;
    NSMutableArray   *imageArray;
    UIScrollView *myScrollView;
    NSInteger     currentIndex;
    UIView       *markView;
    UIView       *scrollPanel;
    int   tagNumber;
    float   contentOffset_Y;
    float   contentOffset_X;
    UIButton *jtxlButton;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    // 隐藏navigationBar
    self.navigationController.navigationBarHidden = YES;
    // 隐藏tabbar
    self.tabBarController.tabBar.hidden           = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    
    NavigationView *navigation = [[NavigationView alloc] initWithtitle:@"我的数据" viewController:self];
    [self.view addSubview:navigation];
    contentOffset_Y = 0;
    contentOffset_X = 0;
    _page = 1;
    dataArray = [NSMutableArray array];
    
    [self createUI];

    if ([HttpTool judgeWhetherUserLogin]) {
        [self startRequest];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您还没有登录，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录",nil];
        
        [alert show];
    }

}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:[LoginViewController new] animated:YES];
    }
}

- (void)startRequest {
    NSString *url = [NSString stringWithFormat:@"%@api/?method=user.mybody",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        
        dataArray = [NSMutableArray array];
        _page = 1;
        for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
            MyDataModel *dataModel = [[MyDataModel alloc] initWithDictionary:dict];
            [dataArray addObject:dataModel];
            
           
        }
        [_collectionView reloadData];
    }];
}
- (void)createUI {
    
    /******************添加左边的标题*******************/
    NSArray* titleArray = @[@"身高", @"体重", @"腰围", @"臀围", @"右大腿", @"左大腿", @"右小腿", @"左小腿", @"右上臂-放松", @"右上臂-屈曲", @"左上臂-放松", @"左上臂-屈曲", @"胸围-放松", @"胸围-扩张", @"肱三头肌", @"髋嵴上缘", @"肩胛下缘", @"腹部", @"大腿", @"总和", @"脂肪百分比", @"腰臀比例", @"BMI", @"静态心率", @"血压", @"目标心率" ];
    
    
    titleScrollView               = [UIScrollView new];
    titleScrollView.frame         = CGRectMake(0, NavigationBar_Height, Adaptive(70), LastHeight + Tabbar_Height);
   
    titleScrollView.showsVerticalScrollIndicator   = NO;//竖直方向的
   // titleScrollView.backgroundColor = ORANGECOLOR;
    titleScrollView.delegate      = self;
    titleScrollView.bounces = NO;
    [self.view addSubview:titleScrollView];
    
//    UILabel *topLine = [UILabel new];
//    topLine.frame    = CGRectMake(0, 0, Adaptive(70), .5);
//    topLine.alpha = .8;
//    topLine.backgroundColor = [UIColor whiteColor];
//    [titleScrollView addSubview:topLine];
    
    
    UILabel * timelabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Adaptive(70), Adaptive(40))];
    timelabel.backgroundColor = ORANGECOLOR;
    timelabel.text = @"时间";
    timelabel.textAlignment = 1;
    timelabel.textColor = [UIColor whiteColor];
    timelabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    [titleScrollView addSubview:timelabel];
    
    UILabel* timeline = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(timelabel.frame),
                                                                  Adaptive(70),
                                                                  0.5)];
    timeline.backgroundColor = [UIColor whiteColor];
    timeline.alpha = .8;
    [titleScrollView addSubview:timeline];
    
    CGFloat imageWidth  = (viewWidth - Adaptive(70)) / 4;
    CGFloat imageHeight = imageWidth * (4 / 3);
    
    
    UILabel* photolabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(timeline.frame), Adaptive(70), imageHeight)];
    photolabel.backgroundColor = ORANGECOLOR;
    photolabel.text = @"照片";
    photolabel.textAlignment = 1;
    photolabel.textColor = [UIColor whiteColor];
    photolabel.font = [UIFont fontWithName:FONT size:Adaptive(12)];
    [titleScrollView addSubview:photolabel];
    
    UILabel* photoline = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                   CGRectGetMaxY(photolabel.frame),
                                                                   Adaptive(70),
                                                                   0.5)];
    photoline.backgroundColor = [UIColor whiteColor];
    photoline.alpha = .8;
    [titleScrollView addSubview:photoline];
    
    
    for (int a = 0; a < titleArray.count; a++) {
        UILabel *label = [UILabel new];
        label.frame    = CGRectMake(0,
                                    CGRectGetMaxY(photoline.frame) + Adaptive(40.5)*a ,
                                    Adaptive(70),
                                    Adaptive(40));
        label.text      = titleArray[a];
        label.textAlignment = 1;
        label.backgroundColor = ORANGECOLOR;
        label.numberOfLines = 0;
        label.tag = 2 + a;
        label.textColor = [UIColor whiteColor];
        label.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        [titleScrollView addSubview:label];
        
        UILabel* line = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                  CGRectGetMaxY(label.frame),
                                                                  viewWidth,
                                                                  0.5)];
        line.backgroundColor = [UIColor whiteColor];
        line.alpha           = .8;
        [titleScrollView addSubview:line];
        
        if (a == 20) {
           
            UILabel *remarkLabel = [UILabel new];
            remarkLabel.frame    = CGRectMake(0,
                                              CGRectGetMaxY(photoline.frame) + Adaptive(40.5)*a + Adaptive(25),
                                              Adaptive(70),
                                              Adaptive(15));
            remarkLabel.textColor = [UIColor whiteColor];
            remarkLabel.textAlignment = 1;
            remarkLabel.font      = [UIFont fontWithName:FONT size:Adaptive(9)];
             remarkLabel.text     = @"(标准:12%-18%)";
            [titleScrollView addSubview:remarkLabel];
        }
        if (a == 21) {
            
            UILabel *remarkLabel = [UILabel new];
            remarkLabel.frame    = CGRectMake(0,
                                              CGRectGetMaxY(photoline.frame) + Adaptive(40.5)*a + Adaptive(25),
                                              Adaptive(70),
                                              Adaptive(15));
            remarkLabel.textColor = [UIColor whiteColor];
            remarkLabel.textAlignment = 1;
            remarkLabel.font      = [UIFont fontWithName:FONT size:Adaptive(9)];
            remarkLabel.text      = @"(标准:<0.9)";
            [titleScrollView addSubview:remarkLabel];
        }
        if (a == 22) {
            UILabel *remarkLabel = [UILabel new];
            remarkLabel.frame    = CGRectMake(0,
                                              CGRectGetMaxY(photoline.frame) + Adaptive(40.5)*a + Adaptive(25),
                                              Adaptive(70),
                                              Adaptive(15));
            remarkLabel.textColor = [UIColor whiteColor];
            remarkLabel.textAlignment = 1;
            remarkLabel.font      = [UIFont fontWithName:FONT size:Adaptive(9)];
            remarkLabel.text      = @"(标准:18.5-22.9)";
            [titleScrollView addSubview:remarkLabel];
        }
        if (a == 23) {
            UILabel *remarkLabel = [UILabel new];
            remarkLabel.frame    = CGRectMake(0,
                                              CGRectGetMaxY(photoline.frame) + Adaptive(40.5)*a + Adaptive(25),
                                              Adaptive(70),
                                              Adaptive(15));
            remarkLabel.textColor = [UIColor whiteColor];
            remarkLabel.textAlignment = 1;
            remarkLabel.font      = [UIFont fontWithName:FONT size:Adaptive(9)];
            remarkLabel.text      =  @"(标准:60-70)";
            [titleScrollView addSubview:remarkLabel];
            
        }
        if (a == 24) {
            UILabel *remarkLabel = [UILabel new];
            remarkLabel.frame    = CGRectMake(0,
                                              CGRectGetMaxY(photoline.frame) + Adaptive(40.5)*a + Adaptive(25),
                                              Adaptive(70),
                                              Adaptive(15));
            remarkLabel.textColor = [UIColor whiteColor];
            remarkLabel.textAlignment = 1;
            remarkLabel.font      = [UIFont fontWithName:FONT size:Adaptive(9)];
            remarkLabel.text      = @"(标准:80-120)";
            [titleScrollView addSubview:remarkLabel];
        }
    }
    UILabel *lastLabel = (UILabel *)[self.view viewWithTag:titleArray.count + 1];
     titleScrollView.contentSize   = CGSizeMake(Adaptive(70), CGRectGetMaxY(lastLabel.frame));
    
    /******************添加数据************************/
    
   

    
    dataScrollView       = [UIScrollView new];
    // dataScrollView.bounces = NO;
    dataScrollView.frame = CGRectMake(Adaptive(70),
                                      NavigationBar_Height,
                                      viewWidth - Adaptive(70),
                                      LastHeight + Tabbar_Height);
    dataScrollView.showsHorizontalScrollIndicator = NO; // 水平方向的
    dataScrollView.showsVerticalScrollIndicator   = NO; // 竖直方向的
    dataScrollView.contentSize     = CGSizeMake(0, CGRectGetMaxY(lastLabel.frame));
    dataScrollView.backgroundColor = ORANGECOLOR;
    dataScrollView.delegate        = self;
    [self.view addSubview:dataScrollView];
    
//    UILabel *topDataLine = [UILabel new];
//    topDataLine.frame    = CGRectMake(0, 0, viewWidth - Adaptive(70), .5);
//    topDataLine.backgroundColor = [UIColor whiteColor];
//    topDataLine.alpha = .8;
//    [dataScrollView addSubview:topDataLine];
    
    
    UICollectionViewFlowLayout *flowLayout = [UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];//设置横向
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, viewWidth - Adaptive(70), viewHeight*2) collectionViewLayout:flowLayout];
    //  _collectionView.bounces = NO;
    _collectionView.pagingEnabled = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = BASECOLOR;
    [_collectionView registerClass:[DataCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [dataScrollView addSubview:_collectionView];
    
    
}





#pragma mark -- UICollectionViewDataSource
//定义展示UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
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
    DataCollectionViewCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    //移除cell
    for (id subView in cell.contentView.subviews) {
        [subView removeFromSuperview];
    }
    MyDataModel *dataModel = dataArray[indexPath.row];
    cell.dataModel = dataModel;
    
    
    
    return cell;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return  CGSizeMake((viewWidth - Adaptive(70)) / 2,viewHeight * 2);  //设置cell宽高
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // 只要偏移量有改变  就会调用
     CGPoint point = scrollView.contentOffset;
    
    if (point.y == 0) {
        // 横向滑动
        titleScrollView.contentOffset = CGPointMake(0, contentOffset_Y);
        dataScrollView.contentOffset  = CGPointMake(0, contentOffset_Y);
    } else {
        // 纵向滑动
        contentOffset_Y = point.y;
        titleScrollView.contentOffset = CGPointMake(0, point.y);
        dataScrollView.contentOffset  = CGPointMake(0, point.y);
    }
    
    
    CGFloat collectWidth = (viewWidth - Adaptive(70)) * 2;
    
    if (point.x > collectWidth * _page) {
        
        NSString *url = [NSString stringWithFormat:@"%@api/?method=user.mybody&pages=%d",BASEURL,_page];
        _page++;
        [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
            
        } success:^(id responseObject) {
            
            NSArray *array = [responseObject objectForKey:@"data"];
            if (array.count > 0) {
                for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
                    MyDataModel *dataModel = [[MyDataModel alloc] initWithDictionary:dict];
                    
                    [dataArray addObject:dataModel];
                  
                    
                }
                [_collectionView reloadData];
            }
        }];
    }
}


@end
