//
//  PickerView.m
//  Gama
//
//  Created by Paul on 16/1/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "PickerAddView.h"
#import "Masonry.h"
#import "AppUtils.h"
#import "AddView.h"


@interface PickerAddView ()
<UIPickerViewDataSource, UIPickerViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_mainButtonLc;
}
- (IBAction)_cancelAction:(UIButton *)sender;
- (IBAction)_finishAction:(UIButton *)sender;

- (IBAction)_deleteKeyAction:(UIButton *)sender;
@end

@implementation PickerAddView
@synthesize delegate = _delegate;

- (void) awakeFromNib
{
    [super awakeFromNib];
    _addText = @"";
    [_mainButtonLc setConstant:-200 * SCREEN_WIDTH_RATIO];
}

- (void) loadData:(NSArray *)arr addText:(NSString *)text
{
    _list = [[NSMutableArray alloc] initWithArray:arr];
    if (![text isEqualToString:@""])
    {
        _addText = text;
        [_list insertObject:text atIndex:0];
    }
    
    [_pickerView reloadAllComponents];
    [self _checkFinishBt:text];
    [self _showView];
}

#pragma mark - create
+ (instancetype) createPickView:(UIViewController *)vc
{
    PickerAddView *view = [PickerAddView nodeFormClass];
    [vc.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(vc.view);
     }];
    return view;
}

#pragma makrk -
- (void) resetList:(NSArray *)list inComponent:(NSInteger)component
{
    _list = [[NSMutableArray alloc] initWithArray:list];
    [_pickerView reloadComponent:component];
}

- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [_pickerView selectRow:row inComponent:component animated:NO];
}

- (void) selectRowObject:(NSString *)object
             inComponent:(NSInteger)component
{
    NSArray *arr = _list[component];
    NSInteger row = [arr indexOfObject:object];
    if (row >= [arr count])
    {
        return;
    }
    [_pickerView selectRow:row inComponent:component animated:NO];
}

#pragma mark - show hide
- (void) _showView
{
    [self performSelector:@selector(_showDeley)
               withObject:nil
               afterDelay:0.05];
}

- (void) _showDeley
{
    _mainButtonLc.constant = 0;
    [UIView animateWithDuration:.3 animations:^{
        [_mainView layoutIfNeeded];
        [_bgIV setAlpha:0.6];
    }];
}

- (void) _hideView:(BOOL)finish
{
    NSInteger height = self.bounds.size.height;
    _mainButtonLc.constant = -height;
    [UIView animateWithDuration:.3 animations:^{
        [_mainView layoutIfNeeded];
        [_bgIV setAlpha:0.0];
        
    } completion:^(BOOL finished)
     {
         [self _isFinish:finish];
         [self removeFromSuperview];
     }];
}

- (void) _isFinish:(BOOL)finish
{
    NSString *text = @"";
    if (finish)
    {
        NSInteger row = [_pickerView selectedRowInComponent:0];
        if ([_list count] > row)
        {
            text = _list[row];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(pickerAddView:didBack:)])
    {
        [_delegate pickerAddView:self didBack:text];
    }
}

#pragma mark - AddView
- (void) _showAddView
{
    AddView *view = [AddView nodeFormClass];
    [view setList:_list];
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.edges.equalTo(self);
    }];
    
    __weak PickerAddView *weakSelf = self;
    [view finish:^(NSString *text)
     {
         [weakSelf _addText:text];
     }];
}

- (void) _addText:(NSString *)text
{
    [_list addObject:text];
    if (_delegate && [_delegate respondsToSelector:@selector(pickerAddView:didAddText:key:)])
    {
        [_delegate pickerAddView:self didAddText:text key:_key];
    }
    [_pickerView reloadAllComponents];
    [self _checkFinishBt:text];
    
    [_pickerView selectRow:[_list count] - 1 inComponent:0 animated:true];
}

- (void) _checkFinishBt:(NSString *)text
{
    NSString *finishText = @"完成";
    BOOL isAdd = [text isEqualToString:_addText] && ![_addText isEqualToString:@""];
    if (isAdd)
    {
        finishText = @"添加";
    }
    [_deleteBt setHidden:isAdd];
    [_finishBt setTitle:finishText forState:UIControlStateNormal];
}

#pragma mark - Click bt
- (IBAction)_cancelAction:(UIButton *)sender
{
    [self _hideView:NO];
}

- (IBAction)_finishAction:(UIButton *)sender
{
    NSInteger row = [_pickerView selectedRowInComponent:0];
    if (row < [_list count])
    {
        NSString *key = _list[row];
        if ([key isEqualToString:_addText])
        {
            [self _showAddView];
            
//            [self _showAddView];
            return;
        }
    }
    [self _hideView:YES];
}

//- (IBAction)_hideAddAction:(UIButton *)sender
//{
//    [self _hideAddView];
//}
//
//- (IBAction)_addAction:(UIButton *)sender
//{
//    NSString *key = [_addTF text];
//    if ([key length ] > 0)
//    {
//        [_list addObject:key];
//        if (_delegate && [_delegate respondsToSelector:@selector(pickerAddView:didAddText:key:)])
//        {
//            [_delegate pickerAddView:self didAddText:key key:_key];
//        }
//        [self _hideAddView];
//        [_pickerView reloadAllComponents];
//        [self _checkFinishBt:key];
//
//        [_pickerView selectRow:[_list count] - 1 inComponent:0 animated:true];
//    }
//    else
//    {
//        [AppUtils showAlert:@"请输入内容" inView:self];
//    }
//}

- (IBAction)_deleteKeyAction:(UIButton *)sender
{
    NSInteger row = [_pickerView selectedRowInComponent:0];
    if ([_list count] <= row)
    {
        return;
    }
    NSString *text = _list[row];
    if (_delegate && [_delegate respondsToSelector:@selector(pickerAddView:deleteText:key:)])
    {
        [_delegate pickerAddView:self deleteText:text key:_key];
    }
}

- (void) deleteText
{
    NSInteger row = [_pickerView selectedRowInComponent:0];
    if ([_list count] <= row)
    {
        return;
    }
    NSString *text = _list[row];
    [_list removeObject:text];
    [_pickerView reloadAllComponents];
    
    row = [_pickerView selectedRowInComponent:0];
    text = _list[row];
    [self _checkFinishBt:text];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger) pickerView:(UIPickerView *)pickerView
 numberOfRowsInComponent:(NSInteger)component
{
    return [_list count];
}

- (UIView *) pickerView:(UIPickerView *)pickerView
             viewForRow:(NSInteger)row
           forComponent:(NSInteger)component
            reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (pickerLabel == nil)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setFont:FontSize(18 * SCREEN_WIDTH_RATIO)];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

#pragma mark - UIPickerViewDelegate
- (NSString*) pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    NSString *text = _list[row];
    return text;
}

- (void) pickerView:(UIPickerView *)pickerView
       didSelectRow:(NSInteger)row
        inComponent:(NSInteger)component
{
    NSString *text = @"";
    if ([_list count] > row)
    {
        text = _list[row];
    }
    
    [self _checkFinishBt:text];
    
    if (_delegate && [_delegate respondsToSelector:@selector(pickerAddView:didText:inComponent:)])
    {
        [_delegate pickerAddView:self didText:text inComponent:component];
    }
}
@end
