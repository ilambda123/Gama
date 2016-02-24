//
//  PickerView.h
//  Gama
//
//  Created by Paul on 16/1/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"

@class PickerAddView;
@protocol PickerAddViewDelegate <NSObject>
@optional
- (void) pickerAddView:(PickerAddView *)view didBack:(NSString *)text;
- (void) pickerAddView:(PickerAddView *)view
               didText:(NSString *)text
           inComponent:(NSInteger)component;

- (void) pickerAddView:(PickerAddView *)view
            didAddText:(NSString *)text
                   key:(NSString *)key;
- (void) pickerAddView:(PickerAddView *)view
            deleteText:(NSString *)test
                   key:(NSString *)key;
@end


@interface PickerAddView : BaseView
{
    __weak IBOutlet UIPickerView *_pickerView;
    __weak IBOutlet UIView *_mainView;
    __weak IBOutlet UIButton *_finishBt;
    __weak IBOutlet UIImageView *_bgIV;
    __weak IBOutlet UIView *_addView;
    
    __weak IBOutlet UITextField *_addTF;
    __weak IBOutlet UIButton *_deleteBt;
    
    NSMutableArray *_list;
    NSString *_addText;
}
@property (nonatomic, weak) id <PickerAddViewDelegate> delegate;
@property (nonatomic, copy) NSString *key;

+ (instancetype) createPickView:(UIViewController *)vc;
- (void) loadData:(NSArray *)arr addText:(NSString *)text;

- (void) resetList:(NSArray *)list inComponent:(NSInteger)component;
- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void) selectRowObject:(NSString *)object
             inComponent:(NSInteger)component;

- (void) deleteText;

@end
