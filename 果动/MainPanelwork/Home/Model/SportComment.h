//
//  SportComment.h
//  果动
//
//  Created by mac on 15/3/14.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface SportComment : NSObject
@property (nonatomic,retain)NSString *info,*mobilePhone,*support,*contact;
@property (nonatomic,retain)NSString *number,*address,*theme,*place;
@property (nonatomic,retain)NSString *image;
@property (nonatomic,retain)NSString * time;
@property (nonatomic,retain)NSString *idstr;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
/*responseObject  {
 data =     {
 button = "http://10.0.1.20/static/image/activity_button.png";
 data =         (
 {
 id = 1;
 info = 64646434313131;
 introduce = "\U679c\U52a8\U7f51\U7edc\U4f1a\U6240";
 mobilePhone = 18289245331;
 number = 120;
 place = "\U9999\U5c71";
 support = "\U679c\U52a8\U7f51\U7edc";
 theme = "\U722c\U5c71";
 time = 1427234400;
 }
 );
 status = 1;
 };
 rc = 0;
 st = 1426314448;
 }
 */
