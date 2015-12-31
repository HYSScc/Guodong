//
//  page.m
//  果动
//
//  Created by mac on 15/10/10.
//  Copyright © 2015年 Unique. All rights reserved.
//

#import "page.h"

@implementation page

- (void)setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 4;
        size.width = 4;
        // NSLog(@"xxx  %f  yyy  %f",subview.frame.origin.x,subview.frame.origin.y);
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                              size.width, size.height)];
    }
}

@end
