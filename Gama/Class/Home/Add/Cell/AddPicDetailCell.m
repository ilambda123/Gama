//
//  AddPicDetailCell.m
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "AddPicDetailCell.h"
#import "GamaBaseViewController.h"
#import "InputViewController.h"
#import "BaseViewController+ImagePicker.h"

#import "MZ+UIImage.h"
#import "MZ+UIImageView.h"
#import "TextData.h"
#import "ProductData.h"
#import "BrandManager.h"
#import "UrlImageView.h"
#import "PreviewWindow.h"
#import "AFViewShaker.h"


@interface AddPicDetailCell()
<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_labelHeightLc;
}
- (IBAction)_addTextAction:(UIButton *)sender;
- (IBAction)addCoverAction:(UIButton *)sender;
@end

@implementation AddPicDetailCell
@synthesize rootVC = _rootVC;
+ (NSInteger) cellHeight
{
    return 130;
}

- (void) awakeFromNib
{
    [super awakeFromNib];
    [_decLabel setNumberOfLines:10];
    _canEdit = true;
}

- (void) uploadFail:(AddViewType)type
{
    NSArray *list = @[];
    if (type == addDec)
    {
        list = @[_decTF];
    }
    else if (type == addImage)
    {
        list = @[_imageView];
    }
    AFViewShaker *shaker = [[AFViewShaker alloc] initWithViewsArray:list];
    [shaker shake];
}

#pragma mark - 
- (void) loadData:(ProductDecData *)data
{
    _data = data;
    if ([_data.dec length] > 0)
    {
        [self _inputDec:_data.dec];
    }

    NSString *imagePath = [data imagePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        [_coverIV loadImage:nil save:imagePath];
    }
}

- (void) previewData:(ProductDecData *)data
{
    [self loadData:data];
    _canEdit = false;
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
- (IBAction)_addTextAction:(UIButton *)sender
{
    if (_canEdit)
    {
        __weak AddPicDetailCell *weadSelf = self;
        InputViewController *vc = (InputViewController *)
        [_rootVC goToStoryBoard:kStoryMain key:@"InputViewController"];
        [vc setTitle:@"描述"];
        [vc setKey:kDec];
        [vc loadText:_decLabel.text finish:^(NSString *text, NSString *key)
         {
             if ([key isEqualToString:kDec])
             {
                 ProductData *data = [BrandManager shareInstance].productData;
                 _data.dec = text;
                 [data updateProductDecData:_data];
                 [weadSelf _inputDec:text];
             }
         }];
    }
}

- (IBAction)addCoverAction:(UIButton *)sender
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
        ProductData *data = [[BrandManager shareInstance] previewData];
        NSInteger index = [data decDatasIndex:_data.decId];
        NSArray *list = [data previewDecDatas];
        if ([list count] == 2)
        {
            CGRect rc = [self convertRect:_imageView.frame toView:[UIView rootView]];
            [PreviewWindow showPreview:list[0]
                                 texts:list[1]
                              curIndex:index
                              showRect:rc];
        }
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
    [data saveImage:image name:_data.picName];

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
@end