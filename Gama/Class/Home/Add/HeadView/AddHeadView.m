//
//  AddHeadView.m
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "AddHeadView.h"
#import "GamaBaseViewController.h"
#import "InputViewController.h"
#import "BaseViewController+ImagePicker.h"

#import "MZ+UIImage.h"
#import "MZ+UIImageView.h"
#import "TextData.h"
#import "ProductDetailView.h"
#import "BrandManager.h"
#import "ProductData.h"
#import "AFViewShaker.h"
#import "AppUtils.h"

#import "PreviewWindow.h"
#import "UrlImageView.h"

#define kTitle @"title"
#define kDec @"dec"

@interface AddHeadView()
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    ProductDetailView *_productDetailView;
    __weak IBOutlet NSLayoutConstraint *_labelHeightLc;
}

- (IBAction)_addBigCoverAction:(UIButton *)sender;
- (IBAction)_decAction:(UIButton *)sender;
@end;

@implementation AddHeadView
@synthesize delegate = _delegate;
@synthesize rootVC = _rootVC;

- (void) awakeFromNib
{
    [super awakeFromNib];
    [_decLabel setNumberOfLines:10];
    _canEdit = true;
}

- (void) loadData
{
    if (_productDetailView == nil)
    {
        _productDetailView = [ProductDetailView nodeFormClass];
        [_productDetailView setRootVC:_rootVC];
        [_detailView addSubview:_productDetailView];
    }
    [_productDetailView loadData];
    
    ProductData *data = [BrandManager shareInstance].productData;
    if ([data.name length] > 0)
    {
        [_titleTF setText:data.name];
    }
    
    if ([data.dec length] > 0)
    {
        [self _inputDec:data.dec];
    }
    
    NSString *path = [data imagePath:data.cover];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path])
    {
        [_coverIV loadImage:@"" save:path];
    }
}

- (void) previewData:(ProductData *)data
{
    if (_productDetailView == nil)
    {
        _productDetailView = [ProductDetailView nodeFormClass];
        [_productDetailView setRootVC:_rootVC];
        [_detailView addSubview:_productDetailView];
    }
    [_productDetailView previewData:data];
    
    _canEdit = false;
    [_titleTF setUserInteractionEnabled:false];
    [_titleTF setText:data.name];
    
    [_decTF setUserInteractionEnabled:false];
    [_editTItleIV setHidden:true];
    NSString *dec = ([data.dec length] <= 0) ? @"没有填写详细描述": data.dec;
    [self _inputDec:dec];
    
    [_tipView setHidden:true];
    NSString *path = [data imagePath:data.cover];
    [_coverIV loadImage:@"" save:path];
}

#pragma mark -
- (BOOL) checkFinish
{
    UIView *view = nil;
    NSString *alert = @"";
    BOOL isFinish = true;
    ProductData *data = [BrandManager shareInstance].productData;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[data imagePath:kCover]])
    {
        view = _tipView;
        alert = @"请点击记录图片";
        [self _errorTip:@[view]];
        isFinish = false;
    }
    else if ([data.name length] <= 0)
    {
        view = _titleView;
        alert = @"请输入产品名称";
        [self _errorTip:@[view]];
        isFinish = false;
    }
    else if (![_productDetailView checkFinish])
    {
        view = _detailView;
        isFinish = false;
    }
    
    if (view)
    {
        if (_delegate && [_delegate respondsToSelector:@selector(addHeadView:uploadError:)])
        {
            [_delegate addHeadView:self uploadError:view];
        }
    }

    if ([alert length] > 0)
    {
        [AppUtils showAlert:alert inView:_rootVC.view];
    }
    return isFinish;
}

- (void) _errorTip:(NSArray *)views
{
    AFViewShaker *shaker = [[AFViewShaker alloc] initWithViewsArray:views];
    [shaker shake];
}

#pragma mark -
- (void) _goToTextView:(NSString *)text
                   key:(NSString *)key
                 title:(NSString *)title
{
    __weak AddHeadView *weadSelf = self;
    InputViewController *vc = (InputViewController *)
        [_rootVC goToStoryBoard:kStoryMain key:@"InputViewController"];
    [vc setTitle:title];
    [vc setKey:key];
    [vc loadText:text finish:^(NSString *text, NSString *key)
    {
        if ([key isEqualToString:kTitle])
        {
            [BrandManager shareInstance].productData.name = text;
            [_titleTF setText:text];
        }
        else if ([key isEqualToString:kDec])
        {
            [BrandManager shareInstance].productData.dec = text;
            [weadSelf _inputDec:text];
        }
    }];
}

- (void) _inputDec:(NSString *)text
{
    [_decTF setHidden:![text isEqualToString:@""]];
    [_decLabel setText:text];
    
    MultiLineData *data = [[MultiLineData alloc] init];
    [data loadData:text
              font:FontSize(15 * SCREEN_WIDTH_RATIO)
             width:_decLabel.bounds.size.width];
    [_labelHeightLc setConstant:data.textHeight + data.eachHeight];
    [self layoutIfNeeded];
}

#pragma mark - Click bt
- (IBAction)_addBigCoverAction:(UIButton *)sender
{
    if (_canEdit)
    {
        [_rootVC sheetName:@[@"相册",@"相机",@"取消"]
                    action:^(NSInteger index)
         {
             switch (index)
             {
                 case 0:
                 {
                     UIImagePickerController *imagePicker = [_rootVC openPhoto];
                     [imagePicker setDelegate:self];
                 } break;
                 case 1:
                 {
                     UIImagePickerController *imagePicker = [_rootVC openCamera];
                     [imagePicker setDelegate:self];
                 }break;
                 default:
                     break;
             }
         }];
    }
    else
    {
        UIImage *image = [_coverIV image];
        CGRect rc = [self convertRect:sender.frame toView:[UIView rootView]];
        [PreviewWindow showPreview:@[image] texts:@[_titleTF.text] curIndex:0 showRect:rc];
    }
}

- (IBAction)_decAction:(UIButton *)sender
{
    if (_canEdit)
    {
        [self _goToTextView:_decLabel.text key:kDec title:@"描述"];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    image = [image changeToScreenWidthSize];
    [_coverIV setImage:image];
    
    ProductData *data = [BrandManager shareInstance].productData;
    [data saveImage:image name:kCover];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _titleTF)
    {
        [self _goToTextView:_titleTF.text key:kTitle title:@"标题"];
    }
    return false;
}
@end