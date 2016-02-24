//
//  HomeCell.m
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "HomeCell.h"
#import "ProductData.h"
#import "MZ+UIImageView.h"
#import "TextData.h"
#import "ShareWindow.h"
#import "ShareData.h"

#import "BrandManager.h"
#import "UrlImageView.h"
#import "MZ+UIImage.h"
#import "AppUtils.h"
#import "StatisticManager.h"

@interface HomeCell ()
{
    __weak IBOutlet NSLayoutConstraint *_decHeightLc;
}
- (IBAction)_editAction:(UIButton *)sender;
- (IBAction)_shareAction:(UIButton *)sender;
@end

@implementation HomeCell
@synthesize rootVC = _rootVC;
@synthesize block = _block;

- (void) awakeFromNib
{
    [super awakeFromNib];
    [_decLabel setNumberOfLines:10];
}

+ (NSInteger) cellHeight
{
    return 100;
}

- (void) loadData:(NSString *)dataId
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self _editEnable];
    
    BrandManager *manager = [BrandManager shareInstance];
    _data = [manager productData:dataId];
    
    [_titleLabel setText:[NSString stringWithFormat:@"%@ %@",_data.brand, _data.name]];
    [_decLabel setText:_data.dec];
    [_typeLabel setText:_data.cosmeticsType];
    
    NSString *imagePath = [_data imagePath:_data.cover];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        [_coverIV loadImage:nil save:imagePath];
    }
    
    if ([_data.dec length])
    {
        MultiLineData *lineData = [[MultiLineData alloc] init];
        [lineData loadData:_data.dec
                      font:FontSize(12 * SCREEN_WIDTH_RATIO)
                     width:_decLabel.bounds.size.width];
        [_decHeightLc setConstant:MIN(lineData.eachHeight * 3, lineData.textHeight) + 4];
    }
}

- (void) _editEnable
{
    [_editBt setEnabled:true];
}

- (void) editAction:(EditBlock)block
{
    _block = block;
}

#pragma mark - Click bt
- (IBAction)_editAction:(UIButton *)sender
{
    [sender setEnabled:false];
    if (_block)
    {
        _block(_data.dataId);
        [[StatisticManager shareInstance] onceEvent:kHomeEdit];
    }
    [self performSelector:@selector(_editEnable)
               withObject:nil
               afterDelay:1];
}

- (IBAction)_shareAction:(UIButton *)sender
{
    ShareContentData *data = [[ShareContentData alloc] init];
    data.title = _data.name;
    data.dec = _data.dec;
    data.shareUrl = @"http://www.baidu.com";
    data.style = Style_Image;
    NSString *imagePath = [_data imagePath:_data.cover];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imagePath])
    {
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        if (image)
        {
            data.iconImage = image;
            [data setThumbImage:image];
        }
    }
    
    [ShareWindow showShareWindow:data finish:^(ShareViewType type)
     {
    }];
    
    [[StatisticManager shareInstance] onceEvent:kHomeShare];
}

- (void) hideBts:(BOOL)hide
{
    [_editBt setHidden:hide];
}
@end