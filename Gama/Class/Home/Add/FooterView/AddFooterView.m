//
//  AddFooterView.m
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "AddFooterView.h"
@interface AddFooterView ()
{
    
}
- (IBAction)_rejustAction:(UIButton *)sender;
- (IBAction)_addDetailAction:(UIButton *)sender;
@end;


@implementation AddFooterView
@synthesize delegate = _delegate;
- (void) awakeFromNib
{
    [super awakeFromNib];
    _isAdjust = false;
}

- (void) preview:(BOOL)hasData
{
    [_tipLabel setHidden:false];
    [_addBt setHidden:true];
    [_adjustBt setHidden:true];
    [self setHidden:hasData];
}

#pragma mark - Click bt
- (IBAction)_rejustAction:(UIButton *)sender
{
    if (_isAdjust == false)
    {
        [sender setTitle:@"结束调整" forState:UIControlStateNormal];
    }
    else
    {
        [sender setTitle:@"调整描述" forState:UIControlStateNormal];
    }
    _isAdjust = !_isAdjust;
    
    if (_delegate && [_delegate respondsToSelector:@selector(addFooterView:adjust:)])
    {
        [_delegate addFooterView:self adjust:_isAdjust];
    }
}

- (IBAction)_addDetailAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(addFooterViewDidAddCell:)])
    {
        [_delegate addFooterViewDidAddCell:self];
    }
}
@end
