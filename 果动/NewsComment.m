//
//  NewsComment.m
//  果动
//
//  Created by mac on 15/12/10.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "NewsComment.h"

@implementation NewsComment


-(NewsComment *)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        self.content = [dictionary objectForKey:@"talkinfo"];
        self.replay = [dictionary objectForKey:@"content"];
        self.nickname =  [[dictionary objectForKey:@"source_user"] objectForKey:@"nickname"];
        self.headImageStr = [NSURL URLWithString:[[dictionary objectForKey:@"source_user"] objectForKey:@"headimg"]] ;
        self.phototStr = [NSURL URLWithString:[dictionary  objectForKey:@"talkphoto"]] ;
        self.type = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"types"]];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm"];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[[dictionary objectForKey:@"time"] intValue]];
        self.dateStr = [formatter stringFromDate:date];
    }
    return self;
}
+(NewsComment *)statusWithDictionary:(NSDictionary *)dictionary
{
    NewsComment *news = [[NewsComment alloc] initWithDictionary:dictionary];
    return news;
}
@end
