//
//  Dock.m
//  果动
//
//  Created by Mac on 15-2-8.
//  Copyright (c) 2015年 Unique. All rights reserved.
//

#import "Dock.h"
#import "Commonality.h"
@interface DockItem : UIButton

@end

@implementation DockItem


-(void)setHighlighted:(BOOL)highlighted{}

@end


@interface Dock ()

{
    DockItem * _selectItem;
}

@end

@implementation Dock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:35.00/255 green:30.00/255 blue:15.00/255 alpha:1];;
    }
    return self;
}


-(void)addItemWithTitle:(NSString *)title Icon:(NSString *)icon selectedIcon:(NSString *)selectedIcon
{
    
    DockItem * item=[DockItem buttonWithType:UIButtonTypeCustom];
    
    [item setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    
    [item setBackgroundImage:[UIImage imageNamed:selectedIcon] forState:UIControlStateSelected];
    
    [item addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:item];
    
    NSArray * array=self.subviews;
    
    NSInteger count=array.count;
    CGFloat itemWidth=[UIScreen mainScreen].applicationFrame.size.width / count;
    for (int i=0; i<count; i++) {
        DockItem * item=array[i];
        
        if (IS_IPhone6) {
            item.frame=CGRectMake(itemWidth * i - viewHeight/111.167, 0, itemWidth+viewHeight/53.36, 51);
        }
        
        else
        {
            item.frame=CGRectMake(itemWidth * i - viewHeight/111.167, 0, itemWidth+viewHeight/53.36, viewHeight/13.34);
        }
        item.tag=i;
    }
    if (count==1) {
        [self click:item];
    }
}
/*  375   125
 6s   1.7777778
 6    1.7786667
 5s   1.775
 4s   1.5
 */

-(void)click:(DockItem *)sender
{
    if ([_delegate respondsToSelector:@selector(dock:selectedItemFrom:to:)]) {
        [_delegate dock:self selectedItemFrom:_selectItem.tag to:sender.tag];
    }
    _selectItem.selected=NO;
    sender.selected=YES;
    _selectItem=sender;
    
}


-(void)setFrame:(CGRect)frame
{
    frame.size.width=[UIScreen mainScreen].applicationFrame.size.width;
   
    if (IS_IPhone6) {
         frame.size.height = 51;
    }
    else
    {
         frame.size.height = viewHeight/13.34;
    }
    [super setFrame:frame];
}

@end
