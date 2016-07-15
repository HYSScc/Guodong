//
//  AddressTableViewCell.m
//  果动
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Unique. All rights reserved.
//

#import "AddressTableViewCell.h"
#import "InformationModel.h"


@interface AddressTableViewCell ()

@end

@implementation AddressTableViewCell
{
    
    UIImageView *editImageView;
    UILabel     *editLabel;
    UIImageView *removeImageView;
    UILabel     *removeLabel;
    UILabel     *line;
    
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 把自定义的控件 变成了单元格的属性
        self.backgroundColor = BASEGRYCOLOR;
       

        _addressTextView           = [UITextView new];
        _addressTextView.frame     = CGRectMake(0,
                                               Adaptive(7),
                                               viewWidth - Adaptive(82),
                                               Adaptive(35));
        _addressTextView.textColor = [UIColor grayColor];
        _addressTextView.font      = [UIFont fontWithName:FONT size:Adaptive(11)];
       
        _addressTextView.userInteractionEnabled = NO;
        _addressTextView.backgroundColor = BASEGRYCOLOR;
        [self addSubview:_addressTextView];
        
       // 编辑
        editImageView              = [UIImageView new];
        editImageView.frame        = CGRectMake(viewWidth - Adaptive((26 + 60 + 20 + 60)),
                                                CGRectGetMaxY(_addressTextView.frame) + Adaptive(5),
                                                Adaptive(13), Adaptive(13));
        editImageView.image        = [UIImage imageNamed:@"address_edit"];
        [self addSubview:editImageView];
        
        editLabel          = [UILabel new];
        editLabel.frame    = CGRectMake(CGRectGetMaxX(editImageView.frame),
                                       CGRectGetMaxY(_addressTextView.frame) + Adaptive(6),
                                        Adaptive(30), Adaptive(13));
        editLabel.font      = [UIFont fontWithName:FONT size:Adaptive(11)];
        editLabel.textColor = [UIColor grayColor];
        editLabel.text      = @"编辑";
        [self addSubview:editLabel];
        
        _editButton           = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _editButton.frame     = CGRectMake(CGRectGetMinX(editImageView.frame),
                                          CGRectGetMinY(editImageView.frame),
                                          Adaptive(45),
                                          Adaptive(13));
        
        [self addSubview:_editButton];
        
        // 删除
        removeImageView              = [UIImageView new];
        removeImageView.frame        = CGRectMake(CGRectGetMaxX(_editButton.frame),
                                                CGRectGetMaxY(_addressTextView.frame) + Adaptive(5),
                                                Adaptive(10), Adaptive(13));
        removeImageView.image        = [UIImage imageNamed:@"address_remove"];
        [self addSubview:removeImageView];
        
        removeLabel          = [UILabel new];
        removeLabel.frame    = CGRectMake(CGRectGetMaxX(removeImageView.frame) + Adaptive(1),
                                        CGRectGetMaxY(_addressTextView.frame) + Adaptive(6),
                                        Adaptive(30), Adaptive(13));
        removeLabel.font      = [UIFont fontWithName:FONT size:Adaptive(11)];
        removeLabel.textColor = [UIColor grayColor];
        removeLabel.text      = @"删除";
        [self addSubview:removeLabel];
        
        _removeButton           = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _removeButton.frame     = CGRectMake(CGRectGetMinX(removeImageView.frame),
                                          CGRectGetMinY(removeImageView.frame),
                                          Adaptive(45),
                                          Adaptive(13));
        
        [self addSubview:_removeButton];
        
        // 是否默认
        _resultImageView       = [UIImageView new];
        _resultImageView.frame = CGRectMake(Adaptive(3),
                                           CGRectGetMaxY(_addressTextView.frame) + Adaptive(5),
                                           Adaptive(12),
                                           Adaptive(12));
        
        [self addSubview:_resultImageView];
        
        _resultButton       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _resultButton.frame = CGRectMake(Adaptive(3),
                                       CGRectGetMaxY(_addressTextView.frame) + Adaptive(5),
                                       Adaptive(76),
                                       Adaptive(12));
        _resultButton.titleLabel.font  = [UIFont fontWithName:FONT size:Adaptive(11)];
        
        [self addSubview:_resultButton];
        
        line = [UILabel new];
        line.backgroundColor = BASECOLOR;
        line.frame = CGRectMake(0, CGRectGetMaxY(_resultButton.frame) + Adaptive(7), viewWidth, .5);
        [self addSubview:line];
        
    }
    return self;
}


@end
