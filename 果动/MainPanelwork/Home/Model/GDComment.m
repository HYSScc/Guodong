//
//  GDComment.m
//  果动
//
//  Created by z on 15/2/11.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "GDComment.h"


@implementation GDComment

-(GDComment *)initWithDictionary:(NSDictionary *)dictionary
{
    if (self = [super init]) {
        
        self.photos = [dictionary objectForKey:@"photos"];
        self.content = [dictionary objectForKey:@"content"];
        
        NSString *time = [dictionary objectForKey:@"time"];
        NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"MM-dd  HH:mm"];
        
        
        self.hour=[formatter stringFromDate:confromTimesp];
        self.nickname = [dictionary objectForKey:@"nickname"];
        
        self.comments = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"comments"]];
        self.headimg = [dictionary objectForKey:@"headimg"];
        self.praises =  [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"praises"]];
        self.ipraises =  [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"ipraises"]];
        self.video = [dictionary objectForKey:@"video"];
        self.type = [dictionary objectForKey:@"type"];
        self.talkid = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"talkid"]] ;
        self.course = [dictionary objectForKey:@"course"];
        
        
        //有关评论和回复
        self.comments_list = [NSMutableArray array];
        self.comments_list = [dictionary objectForKey:@"comments_list"];
        
        self.infoArray        = [NSMutableArray array];
        self.timeArray        = [NSMutableArray array];
        self.heaimgArray      = [NSMutableArray array];
        self.nicknameArray    = [NSMutableArray array];
        self.replay_listArray = [NSMutableArray array];
        self.info_idArray     = [NSMutableArray array];
        for (NSDictionary *infidict in self.comments_list) {
            
            //评论内容
            NSString *info = [infidict objectForKey:@"info"];
            [self.infoArray addObject:info];
            
            //评论时间
            NSString *time = [infidict objectForKey:@"time"];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
            NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"MM-dd  HH:mm"];
            NSString *date = [formatter stringFromDate:confromTimesp];
            [self.timeArray addObject:date];
            
            //评论头像
            NSString *headimg = [infidict objectForKey:@"headimg"];
            [self.heaimgArray addObject:headimg];
            
            //呢称
            NSString *nickname = [infidict objectForKey:@"nickname"];
             [self.nicknameArray addObject:nickname];
            
          
            

            
            //有关回复的
            NSArray *array = [infidict objectForKey:@"replay_list"];
            for (NSDictionary * reply_listDict in array) {
                if (reply_listDict != nil && [reply_listDict count] != 0) {
                    [self.replay_listArray addObject:reply_listDict];
                    NSLog(@"self.replayArray %lu",(unsigned long)self.replay_listArray.count);
                }
                
                //回复头像（暂时没用到）
                NSString *headimg = [[reply_listDict objectForKey:@"source_user"] objectForKey:@"headimg"];
                [self.heaimgArray addObject:headimg];
                
                //发起者名字
                NSString *source_name = [[reply_listDict objectForKey:@"source_user"] objectForKey:@"nickname"];
                [self.nicknameArray addObject:source_name];
                
                //如果是回复就将replay_id、回复内容、接受者名字添加到字典中 传出
                NSString *content = [reply_listDict objectForKey:@"content"];
                NSString *target_name = [[reply_listDict objectForKey:@"target_user"] objectForKey:@"nickname"];
                
                 NSDictionary *contentDict = @{@"content":content,@"target_name":target_name,@"replay_id":[reply_listDict objectForKey:@"replay_id"]};
                [self.infoArray addObject:contentDict];
                
                //时间
                NSString *time = [reply_listDict objectForKey:@"time"];
                NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
                NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
                [formatter setDateFormat:@"MM-dd  HH:mm"];
                NSString *date = [formatter stringFromDate:confromTimesp];
                [self.timeArray addObject:date];
                
                NSString *comment_id = [reply_listDict objectForKey:@"comment_id"];
                [self.info_idArray addObject:comment_id];
                
                }
            //评论id
            NSString *info_id = [infidict objectForKey:@"id"];
            [self.info_idArray addObject:info_id];
            
        }
        
        //点赞
        self.praise_listArray = [NSMutableArray array];
        
        for (NSDictionary *praise in [dictionary objectForKey:@"praise_list"]) {
            NSString *headimg = [praise objectForKey:@"headimg"];
            [self.praise_listArray addObject:headimg];
        }
    }
    return self;
}
+(GDComment *)statusWithDictionary:(NSDictionary *)dictionary
{
    
    GDComment * gdccomment = [[GDComment alloc]initWithDictionary:dictionary];
    
    return gdccomment;
    
}

@end
