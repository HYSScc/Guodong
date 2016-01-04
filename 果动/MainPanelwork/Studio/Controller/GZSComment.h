//
//  GZSComment.h
//  果动
//
//  Created by mac on 15/4/24.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GZSComment : NSObject
@property (nonatomic, retain) NSString* class_id;
@property (nonatomic, retain) NSString* func_name;
@property (nonatomic, retain) NSString* func_id;
@property (nonatomic, retain) NSString* status;
@property (nonatomic, retain) NSString* time;
@property (nonatomic, retain) NSString* rmb;
@property (nonatomic, retain) NSString* alert;

- (instancetype)initWithDictionary:(NSDictionary*)dictionary;
@end
