//
//  AddView.m
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "AddView.h"
#import "AppUtils.h"

@interface AddView ()
- (IBAction)_addAction:(UIButton *)sender;
- (IBAction)_cancelAction:(UIButton *)sender;
@end

@implementation AddView
@synthesize list = _list;
@synthesize block = _block;

- (void) finish:(ClickBlock)block
{
    _block = block;
    [_centerYLc setConstant:[UIScreen mainScreen].bounds.size.height * 1.5];
    [self showView:CGPointZero];
}

#pragma mark - Click
- (IBAction)_addAction:(UIButton *)sender
{
    NSString *text = _addTF.text;
    if ([text length] <= 0)
    {
        [AppUtils showAlert:@"请输入内容" inView:self];
        return;
    }
    
    if ([_list containsObject:text])
    {
        [AppUtils showAlert:@"列表中已经存在相同内容" inView:self];
        return;
    }
    
    if (_block)
    {
        _block(text);
    }
    [self hideView:CGPointZero];
}

- (IBAction)_cancelAction:(UIButton *)sender
{
    [self hideView:CGPointZero];
}
@end