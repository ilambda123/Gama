//
//  EditFooterView.m
//  Gama
//
//  Created by Paul on 16/1/14.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "EditFooterView.h"
#import "BrandManager.h"
@interface EditFooterView ()
{
    NSString *_title;
}
- (IBAction)_editAction:(UIButton *)sender;

@end


@implementation EditFooterView
@synthesize block = _block;
- (void) loadConfig:(ConfigType)type edit:(EditBlock)block
{
    _block = block;
    NSString *key = [[BrandManager shareInstance] configName:type];
    _title = [NSString stringWithFormat:@"调整%@",key];
    [_editBt setTitle:_title forState:UIControlStateNormal];
}

#pragma mark - Click bt
- (IBAction)_editAction:(UIButton *)sender
{
    if (_isAdjust == false)
    {
        [sender setTitle:@"结束调整" forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitle:_title forState:UIControlStateNormal];
    }
    _isAdjust = !_isAdjust;

    if (_block)
    {
        _block(_isAdjust);
    }
}
@end
