//
//  TextCell.m
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "TextCell.h"

@implementation TextCellData
@synthesize text = _text;
@synthesize subText = _subText;
@end

@interface TextCell ()
- (IBAction)_removeAction:(UIButton *)sender;
@end


@implementation TextCell
@synthesize block = _block;
- (void) awakeFromNib
{
    [super awakeFromNib];
    [_removeBt setHidden:true];
}

#pragma mark - load
- (void) loadText:(NSString *)text
{
    [_textLabel setText:text];
}

- (void) loadData:(TextCellData *)data
{
    [_textLabel setText:data.text];
    [_leftLabel setText:data.subText];
}

- (void) loadText:(NSString *)text remove:(BtnClickBlock)block
{
    _block = block;
    [self loadText:text];
    [_removeBt setHidden:true];
    [_arrowIV setHidden:true];
}

#pragma mark - Click bt
- (IBAction)_removeAction:(UIButton *)sender
{
    [_removeBt setEnabled:false];
    if (_block)
    {
        _block();
        _block = nil;
    }
}

+ (NSInteger) cellHeight
{
    return 40;
}
@end
