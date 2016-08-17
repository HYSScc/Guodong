//
//  SHPickerView.m
//  果动
//
//  Created by mac on 16/6/14.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "addMessageCourse.h"
#import "SHPickerView.h"
#import "addCoachCollectCell.h"
#import "addCoachModel.h"
#define colletionCellNumber 4

@interface SHPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate>



@end

@implementation SHPickerView
{
    NSMutableArray *coachArray;
    UIDatePicker *datePicker;
    UIPickerView *pickerView;
    NSString     *elsePickerString;
    NSArray      *dataArray;
    NSString     *typeString;
    NSString     *func_id;
    NSString     *class_id;
    NSInteger    index;
    NSString     *coachName;
    NSString     *coach_id;
}
- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag pickerType:(NSString *)type pickerArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag   = tag;
        dataArray  = array;
        coachArray = [NSMutableArray array];
        typeString = type;
        index      = 0;
        
        _button       = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _button.frame = CGRectMake(0, 0, viewWidth, Adaptive(40));
        _button.backgroundColor = ORANGECOLOR;
        _button.tag   = tag*10;
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button setTitle:@"完成" forState:UIControlStateNormal];
        [self addSubview:_button];
        
        if ([type isEqualToString:@"date"]) {
            datePicker       = [UIDatePicker new];
            datePicker.frame = CGRectMake(0,
                                          CGRectGetMaxY(_button.frame),
                                          viewWidth,
                                          Adaptive(216));
            datePicker.backgroundColor = [UIColor whiteColor];
            
            datePicker.minimumDate = [NSDate date];
            
            datePicker.datePickerMode  = UIDatePickerModeDate;
            [datePicker addTarget:self action:@selector(changeReturnString) forControlEvents:UIControlEventValueChanged];
            [self addSubview:datePicker];
        } else if ([type isEqualToString:@"coach"]) {
            
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            _collection = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                             CGRectGetMaxY(_button.frame),
                                                                             viewWidth,
                                                                             Adaptive(284))
                                             collectionViewLayout:flowLayout];
            flowLayout.headerReferenceSize = CGSizeMake(viewWidth, Adaptive(20));
            flowLayout.itemSize = CGSizeMake(viewWidth / colletionCellNumber, Adaptive(133));
            flowLayout.minimumLineSpacing      = 0;
            flowLayout.minimumInteritemSpacing = 0;
            flowLayout.sectionInset            = UIEdgeInsetsMake(0, 0, 0, 0);
            
          
            [_collection registerClass:[addCoachCollectCell class] forCellWithReuseIdentifier:@"collection"];
            [_collection registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
            _collection.delegate   = self;
            _collection.dataSource = self;
            _collection.backgroundColor  = BASECOLOR;
            _collection.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
            
            [self addSubview:_collection];
            
            
            for (NSDictionary *dict in dataArray) {
                addCoachModel *coachModel = [[addCoachModel alloc] initWithDictionary:dict];
                [coachArray addObject:coachModel];
            }
            // 不选择的话 默认第一个教练名字
            addCoachModel *coachModel = coachArray[0];
            coachName = coachModel.coachName;
            
        } else {
            
            pickerView       = [UIPickerView new];
            pickerView.frame = CGRectMake(0,
                                          CGRectGetMaxY(_button.frame),
                                          viewWidth,
                                          Adaptive(216));
            pickerView.backgroundColor = [UIColor whiteColor];
            pickerView.delegate   = self;
            pickerView.dataSource = self;
            [self addSubview:pickerView];
            // 不选择的话默认选中第一个
            
            if ([type isEqualToString:@"class"]) {
                addMessageCourse *course = dataArray[0];
                elsePickerString = course.name;
                func_id = course.func_id;
                class_id = course.class_id;
            } else {
                elsePickerString      = [dataArray objectAtIndex:0];
            }
        }
    }
    return self;
}

// 选择datePicker 并返回值
- (NSString *)changeReturnString
{
    if ([typeString isEqualToString:@"date"]) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSString* dateString = [formatter stringFromDate:datePicker.date];
        return dateString;
    }  else {
        return elsePickerString;
    }
}

- (NSString *)changeReturnFunc_id {
    return func_id;
}
- (NSString *)changeReturnClass_id {
    return class_id;
}
#pragma mark - picker的协议方法
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return dataArray.count;
}
// 设置某一列中的某一行的标题
- (NSString*)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    
    if ([typeString isEqualToString:@"class"]) {
        addMessageCourse *course = dataArray[row];
        return course.name;
        
    } else {
        return [dataArray objectAtIndex:row];
    }
    
}
// 选中某一列中的某一行时会调用
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    addMessageCourse *course = dataArray[row];
    
    if ([typeString isEqualToString:@"class"]) {
        
        func_id  = course.func_id;
        class_id = course.class_id;
        elsePickerString = course.name;
        
    } else {
        elsePickerString = [dataArray objectAtIndex:row];
    }
}

#pragma mark -- UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return coachArray.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:
                                          UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"
                                                                                   forIndexPath:indexPath];
    UIView *head = [UIView new];
    head.backgroundColor = BASECOLOR;
    [headView addSubview:head];
    return headView;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"collection";
    addCoachCollectCell *cell  = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell sizeToFit];
  
    if (index == indexPath.row) {
       
        cell.coachChooseView.layer.borderWidth = 1.0;
        
        cell.coachChooseView.layer.borderColor = ORANGECOLOR.CGColor;
    } else {
        
        cell.coachChooseView.layer.borderWidth = 0.f;
        cell.coachChooseView.layer.borderColor = BASECOLOR.CGColor;
    }
    
    addCoachModel *coachModel = coachArray[indexPath.row];
    
    if (coachModel.has_course) {
         cell.coachNameLabel.textColor = [UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
        cell.coachButton.userInteractionEnabled = NO;
        [cell addSubview:cell.gryView];
    } else {
         cell.coachNameLabel.textColor = [UIColor whiteColor];
        cell.coachButton.userInteractionEnabled = YES;
        [cell.gryView removeFromSuperview];
    }
    
    [cell.coachImageView sd_setImageWithURL:[NSURL URLWithString:coachModel.coachImageName] placeholderImage:[UIImage imageNamed:@"person_nohead"]];
    cell.coachNameLabel.text = coachModel.coachName;
    [cell.coachButton addTarget:self action:@selector(coachButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
      return cell;
}

- (void)coachButtonClick:(UIButton *)button {
    
    addCoachCollectCell *cell = (addCoachCollectCell *)button.superview;
    NSIndexPath *indexPath    = [_collection indexPathForCell:cell];
    
    NSLog(@"选择 %ld",indexPath.row);
     addCoachModel *coachModel = coachArray[indexPath.row];
    coach_id  = coachModel.coach_id;
    coachName = coachModel.coachName;
    index = indexPath.row;
    [_collection reloadData];
}

- (NSString *)returnCoach_id {
    return coach_id;
}
- (NSString *)returnCoachName {
    return coachName;
}
@end
