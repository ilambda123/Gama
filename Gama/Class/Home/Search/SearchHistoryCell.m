//
//  SearchHistoryCell.m
//  XianGu
//
//  Created by Paul on 15/12/17.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "SearchHistoryCell.h"
@interface SearchHistoryCell()
{
}
- (IBAction)_removeAction:(UIButton *)sender;
@end


@implementation SearchHistoryCell
@synthesize block = _block;

- (void) setTitle:(NSString *)key removeAction:(KeyBlock)block
{
    _block = block;
    [_titleLabel setText:key];
    [_deleteBt setEnabled:true];
}

#pragma mark - Click bt
- (IBAction)_removeAction:(UIButton *)sender
{
    if (_block)
    {
        _block(_titleLabel.text);
        [_deleteBt setEnabled:false];
    }
}

+ (NSInteger) cellHeight
{
    return 30;
}
@end
