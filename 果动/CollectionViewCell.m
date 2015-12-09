//
//  CollectionViewCell.m
//  果动
//
//  Created by mac on 15/8/19.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "CollectionViewCell.h"


@implementation CollectionViewCell
{
    NSString *path;
    int a ;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initSubview];
    }
    return self;
    
}
-(void)initSubview
{
    self.backgroundColor = [UIColor grayColor];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    // 获取工程中某个文件的路径
  
   
       self.imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width , self.bounds.size.height)];
   
  
    
    
    self.imageView.image = [YLGIFImage imageWithContentsOfFile:path];
   

        [self addSubview:self.imageView];
        
        
   

    
    
    
}

@end
