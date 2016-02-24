//
//  InputViewController.m
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "InputViewController.h"

@interface InputViewController () <UITextFieldDelegate>

@end

@implementation InputViewController
@synthesize block = _block;
@synthesize key = _key;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self _createObject];
    [_textView setText:_text];
    [_textView becomeFirstResponder];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void) _createObject
{
    UIBarButtonItem *leftItem = [self createItem:@"item_back"
                                          action:@selector(_backAction:)];
    [self.navigationItem setLeftBarButtonItem:leftItem];
    
    UIBarButtonItem *rightItem = [self createTextItem:@"完成  "
                                               action:@selector(_finishAction)];
    [self.navigationItem setRightBarButtonItem:rightItem];
}

#pragma mark - 
- (void) loadText:(NSString *)text finish:(InputBlock)finish
{
    _text = text;
    _block = finish;
}

#pragma mark - Click bt
- (IBAction)_backAction:(UIButton *)bt
{
    [super _backAction:bt];
}

- (void) _finishAction
{
    if (_block)
    {
        _block(_textView.text, _key);
    }
    [super _backAction:nil];
}

@end
