//
//  AddressView.m
//  果动
//
//  Created by mac on 16/5/25.
//  Copyright © 2016年 Unique. All rights reserved.
//
#import "AppDelegate.h"
#import "AddressView.h"
#import "AddressTableViewCell.h"
#import "InformationAddress.h"
@interface AddressView ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

@end

@implementation AddressView
{
    UITableView    *_tableView;
    NSMutableArray *_addressArray;
    UIButton       *addButton;
    BOOL            isStartEdit;
    NSIndexPath    *cellIndex;
    NSString       *addressString;
    UILabel        *BMILabel;
    UILabel        *statusLabel;
    CGFloat        offset;
    CGFloat        textHeight;
    TextFieldView  *SHtextView;
    UIView         *alphaView;
    AppDelegate    *app;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = BASEGRYCOLOR;
        [self createUI];
        
        [self startRequest];
        app = [UIApplication sharedApplication].delegate;
        alphaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
        alphaView.backgroundColor = BASECOLOR;
        alphaView.alpha = .6;
        
        UITapGestureRecognizer *tapLeftDouble  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(magnifyImage:)];
        [alphaView addGestureRecognizer:tapLeftDouble];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tongzhi:) name:@"BMI" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
        
        SHtextView = [[TextFieldView alloc] initWithFrame:CGRectMake(0, viewHeight, viewWidth, Adaptive(42))];
        SHtextView.backgroundColor = [UIColor colorWithRed:201/255.0
                                                     green:205/255.0
                                                      blue:211/255.0
                                                     alpha:1];
        SHtextView.textField.placeholder = @"新增地址";
        SHtextView.textField.backgroundColor = [UIColor colorWithRed:187/255.0
                                                               green:194/255.0
                                                                blue:201/255.0
                                                               alpha:1];
        [SHtextView.publishButton setTitle:@"保存" forState:UIControlStateNormal];
        [SHtextView.publishButton addTarget:self action:@selector(saveNewAddress:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)tongzhi:(NSNotification *)notification {
    
    if ([[notification.userInfo objectForKey:@"height"] length] != 0) {
         _heightTextField.text = [NSString stringWithFormat:@"%@cm",[notification.userInfo objectForKey:@"height"]];
    }
    if ([[notification.userInfo objectForKey:@"weight"] length] != 0) {
        _weightTextField.text = [NSString stringWithFormat:@"%@kg",[notification.userInfo objectForKey:@"weight"]];
    }
    
    [self countBMI];
}

- (void)startRequest {
    
    
    NSString *url = [NSString stringWithFormat:@"%@api/?method=address.list",BASEURL];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        _addressArray = [NSMutableArray array];
        for (NSDictionary *dict in [responseObject objectForKey:@"data"]) {
            InformationAddress *address = [[InformationAddress alloc] initWithDictionary:dict];
            [_addressArray addObject:address];
        }
        [_tableView reloadData];
    }];
    
}

- (void)createUI {
    
    UILabel *titleLabel  = [UILabel new];
    titleLabel.frame     = CGRectMake(Adaptive(13), Adaptive(13), Adaptive(35), Adaptive(15));
    titleLabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text      = @"地址";
    [self addSubview:titleLabel];
    
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame),
                                                               0,
                                                               viewWidth - CGRectGetMaxX(titleLabel.frame) - Adaptive(39),
                                                               Adaptive(142) - Adaptive(40))
                                              style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor colorWithRed:55/255.0 green:55/255.0 blue:55/255.0 alpha:1];
    _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.rowHeight  = Adaptive(70);
    _tableView.delegate   = self;
    _tableView.dataSource = self;
    [self addSubview:_tableView];
    
    
    addButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    addButton.frame     = CGRectMake(viewWidth - Adaptive(39) - Adaptive(64),
                                     CGRectGetMaxY(_tableView.frame) + Adaptive(5),
                                     Adaptive(64),
                                     Adaptive(24));
    addButton.backgroundColor = ORANGECOLOR;
    addButton.titleLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
    [addButton setTitle:@"新增地址" forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(addButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTintColor:[UIColor blackColor]];
    [self addSubview:addButton];
    
    
    UILabel *blackLabel = [UILabel new];
    blackLabel.frame    = CGRectMake(0,
                                     CGRectGetMaxY(addButton.frame) + Adaptive(5),
                                     viewWidth - Adaptive(26),
                                     .5);
    blackLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:blackLabel];
    
    UILabel *baseLabel = [UILabel new];
    baseLabel.frame    = CGRectMake(0,
                                    CGRectGetMaxY(blackLabel.frame),
                                    viewWidth - Adaptive(26),
                                    9);
    baseLabel.backgroundColor = BASECOLOR;
    [self addSubview:baseLabel];
    
    UILabel *blackbottomLabel = [UILabel new];
    blackbottomLabel.frame    = CGRectMake(0,
                                           CGRectGetMaxY(baseLabel.frame),
                                           viewWidth - Adaptive(26),
                                           .5);
    blackbottomLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:blackbottomLabel];
    
    
    /***********BMI***************/
    NSArray *array = @[@"身高",@"体重",@"BMI"];
    for (int a = 0; a < array.count; a++) {
        UILabel *label  = [UILabel new];
        label.frame     = CGRectMake(0, CGRectGetMaxY(blackbottomLabel.frame) + a*40, Adaptive(50), Adaptive(40));
        label.textColor = [UIColor whiteColor];
        label.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
        label.text      = array[a];
        label.textAlignment = 1;
        [self addSubview:label];
    }
    
    _heightTextField       = [UITextField new];
    _heightTextField.frame = CGRectMake(Adaptive(60),CGRectGetMaxY(blackbottomLabel.frame) + Adaptive(11) , Adaptive(150), Adaptive(20));
    _heightTextField.font  = [UIFont fontWithName:FONT size:Adaptive(12)];
    _heightTextField.tag   = 1;
    _heightTextField.delegate     = self;
    _heightTextField.placeholder  = @"单位(mm)";
    _heightTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_heightTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _heightTextField.textColor = [UIColor grayColor];
    [self addSubview:_heightTextField];
    
    _weightTextField       = [UITextField new];
    _weightTextField.frame = CGRectMake(Adaptive(60),
                                        CGRectGetMaxY(_heightTextField.frame) + Adaptive(20),
                                        Adaptive(150),
                                        Adaptive(20));
    _weightTextField.font  = [UIFont fontWithName:FONT size:Adaptive(12)];
    _weightTextField.tag   = 2;
    _weightTextField.delegate     = self;
    _weightTextField.placeholder  = @"单位(kg)";
    _weightTextField.keyboardType = UIKeyboardTypeNumberPad;
    [_weightTextField setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    _weightTextField.textColor = [UIColor grayColor];
    [self addSubview:_weightTextField];
    
    BMILabel       = [UILabel new];
    BMILabel.frame = CGRectMake(Adaptive(60),
                                CGRectGetMaxY(_weightTextField.frame) + Adaptive(20),
                                Adaptive(100),
                                Adaptive(20));
    BMILabel.textColor = [UIColor grayColor];
    BMILabel.font      = [UIFont fontWithName:FONT size:Adaptive(12)];
    [self addSubview:BMILabel];
    
    
    statusLabel       = [UILabel new];
    statusLabel.frame = CGRectMake(viewWidth - Adaptive((39 + 60)),
                                   CGRectGetMinY(BMILabel.frame),
                                   Adaptive(60),
                                   Adaptive(20));
    statusLabel.font = [UIFont fontWithName:FONT size:Adaptive(13)];
    [self addSubview:statusLabel];
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addressArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellidentifier = @"cell";
    
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellidentifier];
    if (cell == nil)
    {
        cell = [[AddressTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier:cellidentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    InformationAddress *address   = _addressArray[indexPath.row];
    cell.addressTextView.delegate = self;
    cell.addressTextView.text     = address.address;
    
    if (address.isDefault == 1) {
        cell.resultImageView.image = [UIImage imageNamed:@"addressImg_result"];
        [cell.resultButton setTitle:@"默认地址" forState:UIControlStateNormal];
        [cell.resultButton setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
    } else {
        cell.resultImageView.image = [UIImage imageNamed:@"addressImg_else"];
        [cell.resultButton setTitle:@"设为默认" forState:UIControlStateNormal];
        [cell.resultButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    cell.resultButton.tag = (indexPath.row + 1) * 10;
    [cell.resultButton addTarget:self action:@selector(resultButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.editButton addTarget:self action:@selector(editButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.removeButton addTarget:self action:@selector(removeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    //
    return cell;
    
}
- (void)resultButtonClick:(UIButton *)button {
    InformationAddress *address = _addressArray[(button.tag /10) - 1];
    NSString *url = [NSString stringWithFormat:@"%@api/?method=address.default&address_id=%d",BASEURL,address.address_id];
    [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress *progress) {
        
    } success:^(id responseObject) {
        
        [self startRequest];
        
    }];
}

- (void)editButtonClick:(UIButton *)button {

    isStartEdit = !isStartEdit;
    AddressTableViewCell *cell = ( AddressTableViewCell *)button.superview;
    [cell.addressTextView becomeFirstResponder];
    
    [addButton setTitle:@"保存" forState:UIControlStateNormal];
    cellIndex  = [_tableView indexPathForCell:cell];
    
    NSIndexPath *selectIndexPath = [NSIndexPath indexPathForRow:cellIndex.row inSection:cellIndex.section];
    // 让table滚动到对应的indexPath位置
    [_tableView scrollToRowAtIndexPath:selectIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)textViewDidChangeSelection:(UITextView *)textView {
    addressString = textView.text;
}

- (void)removeButtonClick:(UIButton *)button {
    AddressTableViewCell *cell  = ( AddressTableViewCell *)button.superview;
    cellIndex                   = [_tableView indexPathForCell:cell];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确认要删除此地址吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        InformationAddress *address = _addressArray[cellIndex.row];
        NSString *url = [NSString stringWithFormat:@"%@api/?method=address.delete&address_id=%d",BASEURL,address.address_id];
        [HttpTool postWithUrl:url params:nil body:nil progress:^(NSProgress * progress) {
            
        } success:^(id responseObject) {
            [self startRequest];
        }];
    }
    
}

// 新增地址
- (void)addButtonClick:(UIButton *)button {
    
    if (isStartEdit) {
        InformationAddress *address = _addressArray[cellIndex.row];
        NSString *url = [NSString stringWithFormat:@"%@api/?method=address.modify",BASEURL];
        NSString *address_id = [NSString stringWithFormat:@"%d",address.address_id];
        NSDictionary *dict   = @{@"address_id":address_id,
                                 @"address":addressString};
        [HttpTool postWithUrl:url params:dict body:nil progress:^(NSProgress * progress) {
            
        } success:^(id responseObject) {
            [self startRequest];
        }];
    } else {
        NSLog(@"新增状态");
        [SHtextView.textField becomeFirstResponder];
        [app.window addSubview:alphaView];
        [app.window addSubview:SHtextView];
    }
}

// 保存新的地址
- (void)saveNewAddress:(UIButton *)button {
    NSLog(@"新的地址");
    NSString *url      = [NSString stringWithFormat:@"%@api/?method=address.add&default=0",BASEURL];
    NSDictionary *dict = @{@"address":SHtextView.textField.text};
    
    [HttpTool postWithUrl:url params:dict body:nil progress:^(NSProgress * progress) {
        
    } success:^(id responseObject) {
        [self startRequest];
        [SHtextView removeFromSuperview];
        [self endEditing:YES];
    }];
    
    
    
}

-(void)magnifyImage:(UIGestureRecognizer *)gesture
{
    self.superview.superview.transform = CGAffineTransformIdentity;
    SHtextView.frame = CGRectMake(0, viewHeight, viewWidth, Adaptive(42));
    [SHtextView removeFromSuperview];
    [alphaView removeFromSuperview];
}

//表随键盘高度变化
-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY      = keyBoardRect.size.height;
    CGFloat  height     = self.superview.superview.frame.size.height  - (offset + textHeight + deltaY + NavigationBar_Height);
    if (height <=0) {
        [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            
            self.superview.superview.transform = CGAffineTransformMakeTranslation(0, height);
            
        }];
    }
        CGRect textFrame   = SHtextView.frame;
        textFrame.origin.y = viewHeight  - deltaY - Adaptive(42);
        SHtextView.frame   = textFrame;
}
-(void)keyboardHide:(NSNotification *)note {
    self.superview.superview.transform = CGAffineTransformIdentity;
    SHtextView.frame = CGRectMake(0, viewHeight, viewWidth, Adaptive(42));
    [SHtextView removeFromSuperview];
    [alphaView removeFromSuperview];
   
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    offset     = Adaptive(53) * 5 + Adaptive(10) + Adaptive(120);
    textHeight = 0;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [addButton setTitle:@"新增地址" forState:UIControlStateNormal];
    
    isStartEdit = !isStartEdit;
    return YES;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    offset     = textField.frame.origin.y + (Adaptive(53) * 5 + Adaptive(10));
    textHeight = textField.bounds.size.height;
    
    if (textField.text.length > 2) {
        NSString *string = [textField.text substringToIndex:textField.text.length - 2];
        textField.text   = string;
    }
    
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    
    if (textField.text.length > 0) {
        if (textField.tag == 1) {
            textField.text = [NSString stringWithFormat:@"%@cm",textField.text];
        }
        if (textField.tag == 2) {
            textField.text = [NSString stringWithFormat:@"%@kg",textField.text];
        }
    }
    [self countBMI];
    return YES;
}

- (void)countBMI {
    
    if (_heightTextField.text.length !=0 && _weightTextField.text.length !=0) {
        
        NSString *heightString = [_heightTextField.text substringToIndex:_heightTextField.text.length - 2];
        NSString *weightString = [_weightTextField.text substringToIndex:_weightTextField.text.length - 2];
        
        CGFloat height = [heightString floatValue] * 0.01;
        CGFloat weight = [weightString floatValue];
        
        CGFloat height2 = height * height;
        CGFloat BMI     = weight / height2;
        
        BMILabel.text = [NSString stringWithFormat:@"%.2f",BMI];
        
        if (BMI < 18.50) {
            statusLabel.textColor = UIColorFromRGB(0xe74c3c);
            statusLabel.text      = @"偏低";
        } else if (BMI > 22.90) {
            statusLabel.textColor = UIColorFromRGB(0xe74c3c);
            statusLabel.text      = @"偏高";
        } else {
            statusLabel.textColor = [UIColor colorWithRed:0 green:206/255.0 blue:185/255.0 alpha:1];
            statusLabel.text      = @"正常";
        }
        
        
        
    } else {
        BMILabel.text    = @"";
        statusLabel.text = @"";
    }
}

@end
