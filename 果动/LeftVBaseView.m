//
//  LeftVBaseView.m
//  果动
//
//  Created by mac on 15/10/28.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "LeftVBaseView.h"
#import "Commonality.h"
#import "LocationView.h"
#import "HomeController.h"
@implementation LeftVBaseView
{
    SDCycleScrollView *scrollView;
    UIScrollView *classScrollView;
    UIButton *changeButton;
    NSMutableArray *classnameArray;
    NSMutableArray *classnumberArray;
    NSMutableArray *class_idArray;
    UIImageView *refushImageView;
    LocationView *locationView;
    // UIImageView *alertImageView;
}
- (id)init
{
    self = [super init];
    if (self) {
        [self startRequestScrollViewImage];
        [self startRequestClassNumber];
        [self startRequestPerson];
        [self createImage];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refush) name:@"refushData" object:nil];
    }
    return self;
}
-(void)refush
{
    [self startRequestPerson];
}
-(void)startRequestPerson
{
    //获取个人资料
    NSString *personurl = [NSString stringWithFormat:@"%@api/?method=user.get_userinfo",BASEURL];
    [HttpTool postWithUrl:personurl params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if ([[responseObject objectForKey:@"rc"] intValue] == 0) {
            
            self.isVIP = [NSString stringWithFormat:@"%@",[[responseObject objectForKey:@"data"] objectForKey:@"is_vip"]];
            NSLog(@"self.isvip %@",self.isVIP);
            
        }
    } fail:^(NSError *error) {
        NSLog(@"error  %@",error);
    }];
    
}
-(void)startRequestClassNumber
{
    //获取课程数量
    NSString *classnumberURL = [NSString stringWithFormat:@"%@api/?method=index.index",BASEURL];
   
    [HttpTool postWithUrl:classnumberURL params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"rc"] intValue] == 0) {
            class_idArray = [[NSMutableArray alloc] initWithCapacity:0];
            classnameArray = [[NSMutableArray alloc] initWithCapacity:0];
            classnumberArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dict in [responseObject objectForKey:@"data"])
            {
                NSString *name = [dict objectForKey:@"name"];
                [classnameArray addObject:name];
                NSString *number = [dict objectForKey:@"num"];
                [classnumberArray addObject:number];
                NSString *class_id =[dict objectForKey:@"class_id"];
                [class_idArray addObject:class_id];
            }
            [self createLabel];
        }
    } fail:^(NSError *error) {
        NSLog(@"error  %@",error);
    }];
    
}
-(void)startRequestScrollViewImage
{
    //获取scrollView的图片
    NSString *url1 = [NSString stringWithFormat:@"%@indexImg/",BASEURL];
    [HttpTool postWithUrl:url1 params:nil contentType:CONTENTTYPE success:^(id responseObject)
     {
         //  NSLog(@"滚动图片 %@",responseObject);
         self.scrimgArray = responseObject;
         if (self.scrimgArray) {
             scrollView.imageURLStringsGroup = self.scrimgArray;
         }
     } fail:^(NSError *error) {
         NSLog(@"error  %@",error);
     }];
}
-(void)createLabel
{
    for (int a = 0; a< 2; a++) {
        UIImageView *image = (UIImageView *)[classScrollView viewWithTag:(a+1)*1000];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth/2, viewHeight/33.35)];
        label.center = image.center;
        label.textAlignment = 1;
        label.text = classnameArray[a];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
    
        [classScrollView addSubview:label];
        
        
        UILabel *classtop = [[UILabel alloc] initWithFrame:CGRectMake((classScrollView.frame.size.width/2)*a, CGRectGetMaxY(label.frame), image.bounds.size.width, viewHeight/66.7)];
        if (classnumberArray.count !=0) {
            classtop.text =[NSString stringWithFormat:@"%@节课被预定",classnumberArray[a]];
        }
        classtop.textAlignment = 1;
        classtop.tag = a+3;
        classtop.textColor = [UIColor whiteColor];
        classtop.font = [UIFont fontWithName:FONT size:viewHeight/66.7];
        [classScrollView addSubview: classtop];
        
        UIImageView *image1 = (UIImageView *)[classScrollView viewWithTag:(a+3)*1000];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth/2, viewHeight/33.35)];
        label1.center = image1.center;
        label1.textAlignment = 1;
        
        if (classnameArray.count > 2) {
            label1.text = classnameArray[a+2];
        }
        label1.tag = a + 5;
        label1.textColor = [UIColor whiteColor];
        label1.font = [UIFont fontWithName:FONT size:viewHeight/37.056];
        [classScrollView addSubview:label1];
        
        
        UILabel *classbuttom = [[UILabel alloc] initWithFrame:CGRectMake((classScrollView.frame.size.width/2)*a, CGRectGetMaxY(label1.frame), image.bounds.size.width, viewHeight/66.7)];
        if (classnumberArray.count>2)
        {
            if (![classnameArray[a+2] isEqualToString:@"敬请期待"]) {
                classbuttom.text = [NSString stringWithFormat:@"%@节课被预定",classnumberArray[a+2]];
            }
        }
        classbuttom.tag = a+7;
        classbuttom.textAlignment = 1;
        classbuttom.textColor = [UIColor whiteColor];
        classbuttom.font = [UIFont fontWithName:FONT size:viewHeight/66.7];
        [classScrollView addSubview: classbuttom];
        
    }
}
-(void)createImage
{
    locationView = [LocationView sharedViewManager];
    if (IS_IPhone6plus){
        
        scrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, viewWidth,146)];
    }else if (IS_IPHONE5S){
        scrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, viewWidth,103)];
    }else{
        scrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, viewWidth,viewHeight/5.336)];
    }
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    scrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    scrollView.autoScrollTimeInterval = 5.0;
    [self addSubview:scrollView];
    
    classScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame)+0.5, viewWidth, viewHeight)];
    classScrollView.backgroundColor = [UIColor whiteColor];
    classScrollView.contentOffset = CGPointZero;
    classScrollView.contentSize = CGSizeMake(classScrollView.bounds.size.width,classScrollView.bounds.size.width);
    classScrollView.pagingEnabled = YES;
    classScrollView.showsVerticalScrollIndicator = NO;
    classScrollView.showsHorizontalScrollIndicator = NO;
    
    [self addSubview:classScrollView];
    
    for (int a = 0; a< 2; a++) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((classScrollView.frame.size.width/2+0.5)*a, 1, classScrollView.frame.size.width/2-0.5, classScrollView.frame.size.width/2-0.5)];
        [image setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shouye_class%d.jpg",a+1]]];
        image.tag = (a + 1)*1000;
        [classScrollView addSubview:image];
        
        changeButton  = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        changeButton.frame = image.frame;
        changeButton.tag = (a+1)*10;
        [changeButton addTarget:self action:@selector(buttonChangeClass:) forControlEvents:UIControlEventTouchUpInside];
        [classScrollView addSubview:changeButton];
        
        UIImageView *image1 = [[UIImageView alloc] initWithFrame:CGRectMake((classScrollView.frame.size.width/2+0.5)*a, CGRectGetMaxY(image.frame)+1, classScrollView.frame.size.width/2-0.5, classScrollView.frame.size.width/2-0.5)];
        image1.tag = (a + 3)*1000;
        [image1 setImage:[UIImage imageNamed:[NSString stringWithFormat:@"shouye_class%d.jpg",a+3]]];
        [classScrollView addSubview:image1];
        
        UIButton *buttonbuttom = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        buttonbuttom.frame = image1.frame;
        buttonbuttom.tag = 30+a*10;
        [buttonbuttom addTarget:self action:@selector(buttonChangeClass:) forControlEvents:UIControlEventTouchUpInside];
        [classScrollView addSubview:buttonbuttom];
    }
}
-(void)buttonChangeClass:(UIButton *)button
{
   // if (button.tag == 40) return;
    UIImageView *imagetop = (UIImageView *)[classScrollView viewWithTag:1000*(button.tag/10)];
    
    [UIView animateWithDuration:.3  animations:^{
        CGRect rect = imagetop.frame;
        rect.origin.x += 3;
        rect.origin.y += 3;
        rect.size.width -= 6;
        rect.size.height -= 6;
        imagetop.frame = rect;
    } completion:^(BOOL finished) {
        CGRect rect = imagetop.frame;
        rect.origin.x -= 3;
        rect.origin.y -= 3;
        rect.size.width += 6;
        rect.size.height += 6;
        imagetop.frame = rect;
        
        [UIView animateWithDuration:.3 animations:^{
            //nil
        } completion:^(BOOL finished) {
            
            HomeController *home = [HomeController sharedViewControllerManager];
            if (locationView.dingwei == YES && locationView.isCitys == YES){
                //城市覆盖  定位成功
            //    if (button.tag == 40)return;
                home.pushClassVCBlock(classnameArray[button.tag/10 - 1],(int)button.tag/10,class_idArray[button.tag/10 - 1]);
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
@end
