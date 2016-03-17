//
//  changeNumberView.m
//  果动
//
//  Created by mac on 16/3/3.
//  Copyright © 2016年 Unique. All rights reserved.
//
#define TEXT
#import "changeNumberView.h"
#import "changeView.h"
@implementation changeNumberView
{
    NSMutableArray *changeViewArray;
    NSDictionary   *moneyDict;
    NSString       *price_one;
    NSMutableArray *viewArray;
    NSInteger      personNumber;
    NSInteger      reduceNumber;
    UIImageView    *topLogo;
    NSString       *onepersonNumber;
}


- (instancetype)initWithFrame:(CGRect)frame
                  classNumber:(NSInteger)chassNumber
              changeViewArray:(NSMutableArray *)array
                    price_one:(NSString *)one
              onePersonNumber:(NSString *)onePersonNumber
            classPersonNumber:(NSString *)number
{
    self = [super initWithFrame:frame];
    if (self) {
        changeViewArray   = [NSMutableArray array];
        viewArray         = [NSMutableArray array];
        personNumber      = [number integerValue];
        _imageStyleNumber = chassNumber;
        changeViewArray   = array;
        price_one         = one;
        onepersonNumber   = onePersonNumber;
        self.backgroundColor = BASECOLOR;
        
         moneyDict = @{@"money":price_one,@"package_id":@"",@"types":@"gdcourse"}; //默认传单次课支付数据
        [self createUI];
    }
    return self;
}

- (void)createUI {
    NSArray *topTitleArray = @[ @"fitness_image2", @"yoga_image2", @"fat_image2", @"core_image2",@"shop_image2"];
     NSArray *topTitleArrayTwo = @[ @"fitness_image3", @"yoga_image3", @"fat_image3", @"core_image3",@"shop_image1"];
    NSArray *topLogoArray = @[ @"fitness_image1", @"yoga_image1", @"fat_image1", @"core_image1",@"shop_image1"];
    
    /*顶部小图标*/
    topLogo = [[UIImageView alloc] init];
    if (personNumber == 1) {
        
        switch (_imageStyleNumber) {
            case 1:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(38.4)) / 2, Adaptive(15), Adaptive(38.4), Adaptive(40.4));
                break;
            case 2:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(52)) / 2, Adaptive(15), Adaptive(52), Adaptive(36));
                break;
            case 3:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(46)) / 2, Adaptive(15), Adaptive(46), Adaptive(43.6));
                break;
            case 4:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(46)) / 2, Adaptive(15), Adaptive(46), Adaptive(43.6));
                
                break;
            case 5:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(46)) / 2, Adaptive(15), Adaptive(46), Adaptive(43.6));
                
                break;
                
            default:
                break;
        }
        
        [topLogo setImage:[UIImage imageNamed:topLogoArray[_imageStyleNumber - 1]]];
        
    } else {
        switch (_imageStyleNumber) {
            case 1:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(88)) / 2, Adaptive(15), Adaptive(88), Adaptive(40.4));
                break;
            case 2:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(114)) / 2, Adaptive(15), Adaptive(114), Adaptive(36));
                break;
            case 3:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(98)) / 2, Adaptive(15), Adaptive(98), Adaptive(43.6));
                break;
            case 4:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(105)) / 2, Adaptive(15), Adaptive(105), Adaptive(43.6));
                
                break;
            case 5:
                topLogo.frame = CGRectMake((viewWidth - Adaptive(46)) / 2, Adaptive(15), Adaptive(46), Adaptive(43.6));
                
                break;
                
            default:
                break;
        }
        
        [topLogo setImage:[UIImage imageNamed:topTitleArrayTwo[_imageStyleNumber - 1]]];
    }
    [self addSubview:topLogo];
    
    
    /*顶部大图标*/
    UIImageView* topTitle = [[UIImageView alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(135)) / 2, CGRectGetMaxY(topLogo.frame) + Adaptive(12), Adaptive(135), Adaptive(42.5))];
   
        [topTitle setImage:[UIImage imageNamed:topTitleArray[_imageStyleNumber - 1]]];
    
    
    [self addSubview:topTitle];
    
    /**
     *  根据上课人数来决定布局
     */
    
    if (personNumber == 1) {
        for (int a = 1; a < changeViewArray.count + 2; a++) {
            
            if (a == 1) {
                changeView *change = [[changeView alloc] initWithFrame:CGRectMake(viewWidth / 7,
                                                                                  CGRectGetMaxY(topTitle.frame)  + a*Adaptive(40),
                                                                                  viewWidth * .8,
                                                                                  Adaptive(35))
                                                           moneyString:price_one classNumber:@"1"];
                change.tag              = a * 10;
                change.ringImage.image  = [UIImage imageNamed:@"pay_ring_orange"];
                change.kuangImage.image = [UIImage imageNamed:@"pay_kuang_orange"];
                [change.changeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                change.changeBtn.tag    = a*100;
                [self addSubview:change];
                [viewArray addObject:change];
                
                
            } else {
                
                NSDictionary *dataDict = [changeViewArray objectAtIndex:a - 2];
                NSString     *price    = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"price"]];
                NSString     *number   = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"number"]];
                changeView *change = [[changeView alloc] initWithFrame:CGRectMake(viewWidth / 7,
                                                                                  CGRectGetMaxY(topTitle.frame)  + a*Adaptive(40),
                                                                                  viewWidth * .8,
                                                                                  Adaptive(35))
                                                           moneyString:price classNumber:number];
                change.tag         = a * 10;
                [change.changeBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
                change.juanLabel.text = [dataDict objectForKey:@"publicity_code"];
                change.changeBtn.tag = a*100;
                [self addSubview:change];
                
                [viewArray addObject:change];
            }
        }
        
        
        UIButton *introduceBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        introduceBtn.frame = CGRectMake((viewWidth - Adaptive(60)) / 2,self.bounds.size.height - Adaptive(20) , Adaptive(60), Adaptive(14));
        [introduceBtn addTarget:self action:@selector(introduceClick) forControlEvents:UIControlEventTouchUpInside];
        [introduceBtn setTintColor:[UIColor lightGrayColor]];
        introduceBtn.titleLabel.font = [UIFont fontWithName:FONT size:11.5];
        [introduceBtn setTitle:@"体验卷说明" forState:UIControlStateNormal];
        [self addSubview:introduceBtn];
        
        UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake((viewWidth - Adaptive(60)) / 2,CGRectGetMaxY(introduceBtn.frame) , Adaptive(60), .5)];
        line.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:line];
    } else {
        // 双人课
       
        NSString *reduceString = [NSString stringWithFormat:@"%d",[onepersonNumber intValue] * 2 - [price_one intValue]];
        NSLog(@"reduce  %@",reduceString);
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@元/课时（立省%@元）",price_one,reduceString]];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(0,price_one.length)];
        
        UILabel *twoPerson = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topTitle.frame) + Adaptive(30), viewWidth, Adaptive(20))];
        twoPerson.textAlignment = 1;
        twoPerson.textColor = [UIColor lightGrayColor];
        twoPerson.attributedText = str;
        [self addSubview:twoPerson];
        
        
        UIImageView *kuangImage = [[UIImageView alloc] initWithFrame:CGRectMake(Adaptive(20), CGRectGetMaxY(twoPerson.frame) + Adaptive(20), viewWidth - Adaptive(40), Adaptive(100))];
        kuangImage.image = [UIImage imageNamed:@"pay_twoPerson_kuang"];
        [self addSubview:kuangImage];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(Adaptive(10), 0, kuangImage.bounds.size.width - Adaptive(20), kuangImage.bounds.size.height)];
        textLabel.numberOfLines = 0;
        textLabel.text = @"因为每个人的身体条件与运动能力存在差异，针对性的授课尤为重要，某些环节的双人互动也会增加锻炼的趣味性。";
        textLabel.font = [UIFont fontWithName:FONT size:18];
        textLabel.textColor = [UIColor grayColor];
        [kuangImage addSubview:textLabel];
        
    }
}

- (void)introduceClick {
    NSLog(@"体验卷说明");
    NSString *url = [NSString stringWithFormat:@"%@api/?method=gdmoney.introduce",BASEURL];
    [HttpTool postWithUrl:url params:nil contentType:CONTENTTYPE success:^(id responseObject) {
        if (ResponseObject_RC == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:[[responseObject objectForKey:@"data"] objectForKey:@"info"] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            
            [alert show];
        } else {
            [HeadComment message:[responseObject objectForKey:@"msg"] delegate:nil witchCancelButtonTitle:@"确定" otherButtonTitles:nil];
        }
    } fail:^(NSError *error) {}];
    
    
   
}

- (void)buttonClick:(UIButton *)button {
   
    
    for (changeView *change in viewArray) {
       
        if (change == (changeView *)button.superview) {
            change.ringImage.image  = [UIImage imageNamed:@"pay_ring_orange"];
            change.kuangImage.image = [UIImage imageNamed:@"pay_kuang_orange"];
        } else {
            change.ringImage.image  = [UIImage imageNamed:@"pay_ring_gry"];
            change.kuangImage.image = [UIImage imageNamed:@"pay_kuang_gry"];
        }
    }
    if (button.tag == 100) {
        moneyDict = @{@"money":price_one,@"package_id":@"",@"types":@"gdcourse"};
    } else {
        NSString *price      = [NSString stringWithFormat:@"%@",[[changeViewArray objectAtIndex:button.tag / 100 - 2] objectForKey:@"price"]];
        NSString *package_id = [NSString stringWithFormat:@"%@",[[changeViewArray objectAtIndex:button.tag / 100 - 2] objectForKey:@"id"]];
        moneyDict = @{@"money":price,@"package_id":package_id,@"types":@"package"};
    }
    
   
    
 //   NSLog(@"money %@",moneyDict);
    NSNotification *notification =[NSNotification notificationWithName:@"changeMoney" object:nil userInfo:moneyDict];
    
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
}

@end
