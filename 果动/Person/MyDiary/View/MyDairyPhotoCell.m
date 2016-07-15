//
//  MyDairyPhotoCell.m
//  果动
//
//  Created by mac on 16/6/21.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "MyDairyModel.h"
#import "MyDairyPhotoCell.h"

@implementation MyDairyPhotoCell
{
    UILabel     *verticalLine;
    UIImageView *photoImageView;
    UILabel     *photoLine;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        
        self.backgroundColor = BASECOLOR;
        
        verticalLine = [UILabel new];
        verticalLine.backgroundColor = ORANGECOLOR;
        [self addSubview:verticalLine];
        
       
    }
    return self;
}


- (void)setDairy:(MyDairyModel *)dairy {
    
    CGFloat allWidth   = viewWidth - Adaptive(65.5);
    CGFloat imageWidth = (allWidth - Adaptive(20)) / 3;
    
    [photoLine removeFromSuperview];
    for (int a = 1; a < 5 * ((dairy.photoArray.count / 3) + 1); a++) {
        
       photoLine = [UILabel new];
        photoLine.frame    = CGRectMake(Adaptive(31),
                                    a * (imageWidth / 4 + Adaptive(1)),
                                   viewWidth - Adaptive(65.5),
                                   .5);
        photoLine.tag      = a + 2;
        photoLine.backgroundColor = BASEGRYCOLOR;
        [self addSubview:photoLine];
        
    }
    
    [photoImageView removeFromSuperview];
    for (int a = 0; a < dairy.photoArray.count; a++) {
        photoImageView = [UIImageView new];
        photoImageView.frame        = CGRectMake(Adaptive(31) + (imageWidth + Adaptive(10)) * (a % 3),
                                            (imageWidth + Adaptive(6)) * (a / 3),
                                            imageWidth,
                                            imageWidth);
        
        NSDictionary *imageDict = dairy.photoArray[a];
        [photoImageView sd_setImageWithURL:[NSURL URLWithString:[imageDict objectForKey:@"img"]]];
        photoImageView.backgroundColor = BASEGRYCOLOR;
        [self addSubview:photoImageView];
    }
    
    UILabel *line = (UILabel *)[self viewWithTag:5 * ((dairy.photoArray.count / 3) + 1)];
    
    UILabel *moreLine = [UILabel new];
    moreLine.frame    = CGRectMake(Adaptive(31),
                                   CGRectGetMaxY(line.frame) + Adaptive(23.5),
                                   viewWidth - Adaptive(65.5),
                                   .5);
    moreLine.backgroundColor = BASEGRYCOLOR;
    [self addSubview:moreLine];
    
    if (dairy.userContent.length == 0) {
        _addUserButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _addUserButton.frame = CGRectMake(viewWidth - Adaptive(27.5),
                                          CGRectGetMaxY(moreLine.frame) - Adaptive(17.5),
                                          Adaptive(14.5),
                                          Adaptive(17.5));
        [_addUserButton setBackgroundImage:[UIImage imageNamed:@"MyDairy_add"] forState:UIControlStateNormal];
        [self addSubview:_addUserButton];
        
    }
   
    
    
    CGRect Frame       = self.frame;
    verticalLine.frame = CGRectMake(Adaptive(18.5),
                                    0,
                                    1,
                                    CGRectGetMaxY(moreLine.frame));
    
    Frame.size.height  = CGRectGetMaxY(verticalLine.frame);
    self.frame         = Frame;
    
}
@end
