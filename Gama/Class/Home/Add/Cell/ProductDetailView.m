//
//  ProductDetailView.m
//  Gama
//
//  Created by Paul on 16/1/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "ProductDetailView.h"
#import "PickerAddView.h"
#import "InputViewController.h"

#import "BrandManager.h"
#import "ProductData.h"
#import "TextData.h"
#import "AFViewShaker.h"
#import "AppUtils.h"

#define kButtonTag 10
#define kAlertDeleteTag 234

#define kDefaultBrand @"请选择品牌"
#define kDefaultType @"请选择产品类型"
#define kDefaultSkin @"请选择适合肤质"

@interface ProductDetailView ()
<UITextFieldDelegate, PickerAddViewDelegate, UIAlertViewDelegate>
{
    NSString *_deleteText;
    ConfigType _deleteType;

    PickerAddView *_pickerView;
    __weak IBOutlet NSLayoutConstraint *_lineWidthLc;
    __weak IBOutlet NSLayoutConstraint *_labelHeightLc;
}
- (IBAction)_choiceAction:(UIButton *)sender;
- (IBAction)_effectAction:(UIButton *)sender;
@end

@implementation ProductDetailView
@synthesize rootVC = _rootVC;

- (void) awakeFromNib
{
    [super awakeFromNib];
    [_lineWidthLc setConstant:1];
    [_effectLabel setNumberOfLines:100];
}

- (void) loadData
{
    BrandManager *manager = [BrandManager shareInstance];
    ProductData *data = manager.productData;
    [_brandBt setTitle:data.brand forState:UIControlStateNormal];
    [_typeBt setTitle:data.cosmeticsType forState:UIControlStateNormal];
    [_suitableSkinBt setTitle:data.skin forState:UIControlStateNormal];
    
    if ([data.does length] >0)
    {
        [_doseTF setText:data.does];
    }
    
    if ([data.effect length] > 0)
    {
        [self _inputDec:data.effect];
    }
}

- (void) previewData:(ProductData *)data
{
    [_brandBt setEnabled:false];
    [_typeBt setEnabled:false];
    [_suitableSkinBt setEnabled:false];
    
    [_brandBt setTitle:data.brand forState:UIControlStateNormal];
    [_typeBt setTitle:data.cosmeticsType forState:UIControlStateNormal];
    [_suitableSkinBt setTitle:data.skin forState:UIControlStateNormal];
    
    [_effectTF setHidden:true];
    [_effectBt setEnabled:false];
    NSString *effect = ([data.effect length] <= 0) ? @"没有填写功效": data.effect;
    [self _inputDec:effect];
    
    NSString *does = ([data.does length] <= 0) ? @"没有填写净容量": data.does;
    [_doseTF setUserInteractionEnabled:false];
    [_doseTF setText:does];
}

- (BOOL) checkFinish
{
    UIView *view = nil;
    NSString *alert = @"";
    BOOL isFinish = true;
    ProductData *data = [BrandManager shareInstance].productData;
    if ([data.brand length] <= 0 ||
        [data.brand isEqualToString:kDefaultBrand])
    {
        view = _brandBt;
        alert = kDefaultBrand;
        isFinish = false;
    }
    else if ([data.cosmeticsType length] <= 0 ||
             [data.cosmeticsType isEqualToString:kDefaultType])
    {
        view = _typeBt;
        alert = kDefaultType;
        isFinish = false;
    }
    
    if (view)
    {
        AFViewShaker *shaker = [[AFViewShaker alloc] initWithView:view];
        [shaker shake];
    }
    
    if ([alert length] > 0)
    {
        [AppUtils showAlert:alert inView:_rootVC.view];
    }
    return isFinish;
}

#pragma mark -
- (void) _goToTextView:(NSString *)text
                   key:(NSString *)key
                 title:(NSString *)title
{
    __weak ProductDetailView *weadSelf = self;
    InputViewController *vc = (InputViewController *)
    [_rootVC goToStoryBoard:kStoryMain key:@"InputViewController"];
    [vc setTitle:title];
    [vc setKey:key];
    [vc loadText:text finish:^(NSString *text, NSString *key)
     {
         if ([key isEqualToString:kDoes])
         {
             [BrandManager shareInstance].productData.does = text;
             [_doseTF setText:text];
         }
         else if ([key isEqualToString:kEffect])
         {
             [BrandManager shareInstance].productData.effect = text;
             [weadSelf _inputDec:text];
         }
     }];
}

- (void) _inputDec:(NSString *)text
{
    [_effectTF setHidden:![text isEqualToString:@""]];
    [_effectLabel setText:text];
    
    MultiLineData *data = [[MultiLineData alloc] init];
    [data loadData:text
              font:FontSize(15 * SCREEN_WIDTH_RATIO)
             width:_effectLabel.bounds.size.width];
    [_labelHeightLc setConstant:data.textHeight + data.eachHeight];
    [self layoutIfNeeded];
}

- (NSString *) _choiceText:(ConfigType)type
{
    NSArray *texts = @[@"添加品牌",@"添加类型",@"添加肤质"];
    if (type < [texts count])
    {
        return texts[type];
    }
    return @"";
}

#pragma mark - Click bt
- (IBAction)_choiceAction:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    ConfigType type = tag - kButtonTag;
    BrandManager *manager = [BrandManager shareInstance];
    NSArray *list = [manager configListRemoveDefault:type];
    
    if (_pickerView == nil)
    {
        _pickerView = [PickerAddView createPickView:_rootVC];
        [_pickerView setKey:[NSString stringWithFormat:@"%ld",(long)type]];
        [_pickerView setDelegate:self];
    }
    
    [_pickerView loadData:list addText:[self _choiceText:type]];
}

- (IBAction)_effectAction:(UIButton *)sender
{
    [self _goToTextView:_effectLabel.text key:kEffect title:@"功效"];
}

#pragma mark - PickerViewDelegate
- (void) pickerAddView:(PickerAddView *)view didBack:(NSString *)text
{
    if (![text isEqualToString:@""])
    {
        NSArray *bts = @[_brandBt, _typeBt , _suitableSkinBt];
        NSArray *title = @[@"品牌：", @"类型：" , @"肤质："];
        ConfigType type = (ConfigType)[view.key integerValue];
        if ([bts count] > type)
        {
            NSString *btTitle = [NSString stringWithFormat:@"%@%@",title[type],text];
            UIButton *bt = bts[type];
            [bt setTitle:btTitle forState:UIControlStateNormal];
            
            [[BrandManager shareInstance].productData saveConfig:type text:text];
        }
    }
    _pickerView = nil;
}

- (void) pickerAddView:(PickerAddView *)view
            didAddText:(NSString *)text
                   key:(NSString *)key
{
    ConfigType type = (ConfigType)[key integerValue];
    [[BrandManager shareInstance] updateConfig:type config:text];
}

- (void) pickerAddView:(PickerAddView *)view
            deleteText:(NSString *)text
                   key:(NSString *)key
{
    ConfigType type = (ConfigType)[key integerValue];
    _deleteText = text;
    _deleteType = type;
    NSArray *title = @[@"品牌：", @"类型：" , @"肤质："];
    NSString *alert = [NSString stringWithFormat:@"删除 %@%@?",title[type],text];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alert
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"删除", nil];
    [alertView setTag:kAlertDeleteTag];
    [alertView show];
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    [self _goToTextView:_doseTF.text key:kDoes title:@"净容量"];
    return false;
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSInteger tag = alertView.tag;
    switch (tag)
    {
        case kAlertDeleteTag:
        {
            if (buttonIndex == 1 && [_deleteText length] > 0)
            {
                [_pickerView deleteText];
                [[BrandManager shareInstance] deleteConfig:_deleteType
                                                    config:_deleteText];
                
                _deleteText = @"";
                _deleteType = Max;
            }
        }break;
            
        default:
            break;
    }
}
@end