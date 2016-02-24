//
//  SearchHeadView.m
//  Gama
//
//  Created by Paul on 16/1/15.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "SearchHeadView.h"
#import "SearchHistoryCell.h"


@interface SearchHeadView ()<UITextFieldDelegate>
- (IBAction)_cancelAction:(UIButton *)sender;
@end

@implementation SearchHeadView
@synthesize block = _block;

- (void) awakeFromNib
{
    [super awakeFromNib];
    [_searchTF setEnablesReturnKeyAutomatically:true];
    [_searchTF becomeFirstResponder];
}

- (void) layoutSubviews
{
    [super layoutSubviews];
    if (isIOS7)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        [self setFrame:CGRectMake(0, 0, size.width, 80 * SCREEN_WIDTH_RATIO)];
        [self layoutIfNeeded];
    }
}

- (void) hideKeyBoard
{
    if ([_searchTF isEditing])
    {
        [_searchTF resignFirstResponder];
    }
}

- (void) search:(SearchBlock)block
{
    _block = block;
}

#pragma mark - Click bt
- (IBAction)_cancelAction:(UIButton *)sender
{
    [self hideKeyBoard];
}

#pragma mark - UITextFieldDelegate
- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return true;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    NSString *text = [textField text];
    if ([text length] > 0)
    {
        if (_block)
        {
            _block(text);
        }
    }
}

- (BOOL) textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
 replacementString:(NSString *)string
{
    BOOL unable = (range.length == 1) && (range.location == 0);
    [_searchTF setEnablesReturnKeyAutomatically:unable];
    return true;
}

@end
