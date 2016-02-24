//
//  HomeTypeView.m
//  Gama
//
//  Created by Paul on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "HomeTypeView.h"
@interface HomeTypeView ()
{
    __weak IBOutlet NSLayoutConstraint *_topLc;
    UIButton *_selectBt;
}
- (IBAction)_backAction:(UIButton *)sender;
- (IBAction)_typeAction:(UIButton *)sender;
@end

@implementation HomeTypeView
@synthesize blcok = _blcok;
- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) loadConfig:(HomeType)type y:(NSInteger)y finish:(TypeBlock)block
{
    [_topLc setConstant:y + 5 * SCREEN_WIDTH_RATIO];
    _curType = type;
    _blcok = block;
    
    if (type == BrandSort || type == TypeSort)
    {
        UIButton *bt = [_contentView viewWithTag:type];
        if (bt)
        {
            _selectBt = bt;
            [_selectBt setEnabled:false];
        }
    }
}

#pragma mark - Click bt
- (IBAction)_backAction:(UIButton *)sender
{
    [sender setEnabled:false];
    if (_blcok)
    {
        _blcok(None);
    }
    [self removeFromSuperview];
}

- (IBAction)_typeAction:(UIButton *)sender
{
    HomeType type = (HomeType)sender.tag;
    if (type == BrandSort || type == TypeSort)
    {
        [_selectBt setEnabled:true];
        _selectBt = sender;
    }
    [sender setEnabled:false];

    if (_blcok)
    {
        _blcok(type);
    }
    [self removeFromSuperview];
}
@end
