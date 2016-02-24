//
//  HomeToolView.m
//  Gama
//
//  Created by Paul on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "HomeToolView.h"
@interface HomeToolView ()
{
    UIButton *_selectBt;
}
- (IBAction)_toolAction:(UIButton *)bt;
@end
@implementation HomeToolView
- (void) awakeFromNib
{
    [super awakeFromNib];
    [self resetFont];
    
    _selectBt = (UIButton *)[self viewWithTag:(NSInteger)Home];
    [self _toolAction:_selectBt];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(_showToolNote:)
//                                                 name:kNoteShowToolVC
//                                               object:nil];
}

- (void) removeFromSuperview
{
    [super removeFromSuperview];
//    [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                    name:kNoteShowToolVC
//                                                  object:nil];
}

- (void) reloadBounds:(CGRect)bounds
{
    [self setFrame:bounds];
//    _foodCenterXLc.constant = -47 *SCREEN_WIDTH_RATIO;
//    _surCenterXLc.constant = 47 * SCREEN_WIDTH_RATIO;
}

#pragma mark -
- (void) selectType:(ToolType)type
{
    NSInteger tag = (NSInteger)type;
    UIButton *bt = (UIButton *)[self viewWithTag:tag];
    [_selectBt setEnabled:true];
    _selectBt = bt;
    [_selectBt setEnabled:false];
}

- (void) _showToolNote:(NSNotification *)note
{
    NSObject *object = note.object;
    if ([object isKindOfClass:[NSString class]])
    {
        NSString *key = (NSString *)object;
        ToolType type = (ToolType)[key integerValue];
        [_selectBt setEnabled:true];
        _selectBt = (UIButton *)[self viewWithTag:(NSInteger)type];
        [self _toolAction:_selectBt];
    }
}

#pragma mark - Click bt
- (IBAction)_toolAction:(UIButton *)bt
{
    [_selectBt setEnabled:true];
    _selectBt = bt;
    [_selectBt setEnabled:false];
    
    ToolType type = (ToolType)bt.tag;
    if (_delegate && [_delegate respondsToSelector:@selector(homeToolView:didClick:)])
    {
        [_delegate homeToolView:self didClick:type];
    }
}
@end