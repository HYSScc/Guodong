//
//  ChatModel.h
//  DEMO
//
//  Created by mac on 15/8/6.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface ChatModel : NSObject
@property (nonatomic, retain) NSString *headimgstr;
@property (nonatomic, retain) NSString *nickname;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic) BOOL isGroupChat;
///////
- (void)populateRandomDataSource;

- (void)addRandomItemsToDataSource:(NSInteger)number;

- (void)addSpecifiedItem:(NSDictionary *)dic type:(NSString *)type;

@end
