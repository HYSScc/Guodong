//
//  SportComment.m
//  果动
//
//  Created by mac on 15/3/14.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "SportComment.h"

@implementation SportComment


-(instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    
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
    if (self = [super init])
    {
        self.info = [dictionary objectForKey:@"info"];
        self.address = [dictionary objectForKey:@"address"];
        self.mobilePhone = [dictionary objectForKey:@"mobilePhone"];
        self.number = [dictionary objectForKey:@"number"];
        self.place = [dictionary objectForKey:@"place"];
        self.support = [dictionary objectForKey:@"support"];
        self.theme = [dictionary objectForKey:@"theme"];
        self.time = [dictionary objectForKey:@"time"];
        self.contact = [dictionary objectForKey:@"contact"];
        self.image = [dictionary objectForKey:@"img"];
        self.idstr = [dictionary objectForKey:@"id"];
      
    }
    return self;
}
@end
