//
//  Commonality.h
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#ifndef ___Commonality_h
#define ___Commonality_h

// 1.打印输出
#ifdef DEBUG
#define MyLog(...) NSLog(__VA_ARGS__)
#else
#define MyLog(...)
#endif

/*
 * 0:  'ok',
 * 1:  u'参数错误',
 * 2:    u'签名错误',
 * 3: u'登录过期,请重新登录',
 * 4:  '未知错误，请联系系统管理员。',
 * 5:    '登陆超时，请重新登陆',
 * 6: u'内容不能为空,请重新输入',
 * 8:           '接口不存在',
 *
 */

//登陆接口
//
#define BASEURL @"http://www.guodongwl.com:8065/"
//#define BASEURL @"http://192.168.1.90:8080/"
//#define BASEURL @"http://192.168.1.5/"
#define XiaZaiConnent @"http://itunes.apple.com/cn/app/guo-dong/id998425416?l=en&mt=8"
#define CHECKURL @"http://itunes.apple.com/lookup?id=998425416"
#define APPID 998425416
#define IS_IPHONE4S (480 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define IS_IPHONE5S (568 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)

#define IS_IPhone6 (667 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)

#define IS_IPhone6plus (736 == [[UIScreen mainScreen] bounds].size.height ? YES : NO)
#define FILENAME @"fileName"
//#define    FONT                                                                 @"Arial-BoldMT"
#define FONT @"HiraKakuProN-W3"
#import "BackView.h"
#import "HeadComment.h"
#import "MJRefresh.h"
#import "SVPullToRefresh.h"
#import "Masonry.h"
#import "HttpTool.h"
#import "GCD.h"
#import <QuartzCore/QuartzCore.h>
#define BASECOLOR [UIColor colorWithRed:43 / 255.0 green:43 / 255.0 blue:43 / 255.0 alpha:1]

#define kSelf_SelectedColor [UIColor colorWithWhite:0 alpha:0.4]
#define kUserName_SelectedColor [UIColor colorWithWhite:0 alpha:0.25]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

//基于iPhone6 的大小 计算比例 适配各个尺寸
#define Adaptive(number) [UIScreen mainScreen].bounds.size.height / (667.000000 / number)
#define viewWidth [UIScreen mainScreen].bounds.size.width
#define viewHeight [UIScreen mainScreen].bounds.size.height

#define kUrlScheme @"uniqueguodong117"
#define CONTENTTYPE @"application/json"
#define widthScale 18
#define heightScale 30
#define btnToLabel 10
#define TableHeader 50
#define ShowImage_H 80
#define offSet_X 20
#define kDistance 20
#define kReplyBtnDistance 30
#define limitline 4

#define EmotionItemPattern @"\\[em:(\\d+):\\]"
#define AttributedImageNameKey @"ImageName"

#define HEADERPULLTOREFRESH @"下拉可以刷新了"
#define HEADERRELEASETOREFRESH @"松开马上刷新了"
#define HEADERREFRESHING @"刷新中...."
#define FOOTERPULLTOREFRESH @"上拉可以加载更多数据了"
#define FOOTERRELEASETOREFRESH @"松开马上加载更多数据了"
#define FOOTERREFRESHING @"加载中...."

#define SMS_REGISTERAPP @"568fef5c64c0"
#define SMS_SECRET @"49efe7385ce5da8d805a8175c85e48c0"

#define TJHWD 39.928712
#define TJHJD 116.468007
#define JGMWD 39.914505
#define JGMJD 116.441689
#define DWLWD 39.918395
#define DWLJD 116.478171
#define SJWD 39.895686
#define SJJD 116.464453
#define ZIDONGWD 39.912505
#define ZIDONGJD 116.459689

#define KEFU @"010-65460058"

#define Question_Head_Width 40
#define Question_Head_Height 40
#define TextNumber 30
#define NavigationBar_Height Adaptive(64)
#define Tabbar_Height viewHeight / 13.34
#define NotLogin_RC_Number 24
#define ResponseObject_RC [[responseObject objectForKey:@"rc"] intValue]
#endif
