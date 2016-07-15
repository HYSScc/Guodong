//
//  SHPickerView.m
//  果动
//
//  Created by mac on 16/6/14.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "addMessageCourse.h"
#import "SHPickerView.h"

@interface SHPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@end

@implementation SHPickerView
{
    UIDatePicker *datePicker;
    UIPickerView *pickerView;
    NSString     *elsePickerString;
    NSArray      *dataArray;
    NSString     *typeString;
    NSString     *func_id;
}
- (instancetype)initWithFrame:(CGRect)frame tag:(NSInteger)tag pickerType:(NSString *)type pickerArray:(NSArray *)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tag   = tag;
        dataArray  = array;
        typeString = type;
        
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
        }  else {
            
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
        
        NSLog(@"picker.func_id %@",course.func_id);
        func_id = course.func_id;
        elsePickerString = course.name;
        
    } else {
        elsePickerString = [dataArray objectAtIndex:row];
    }
}

@end
