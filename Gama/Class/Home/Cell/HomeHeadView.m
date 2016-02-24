//
//  HomeHeadView.m
//  Gama
//
//  Created by Paul on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "HomeHeadView.h"
#import "GamaBaseViewController.h"

@interface HomeHeadView ()
- (IBAction)_searchAction:(UIButton *)sender;
@end

@implementation HomeHeadView
@synthesize rootVC = _rootVC;

- (void) layoutSubviews
{
    [super layoutSubviews];
    if (isIOS7)
    {
        CGSize size = [UIScreen mainScreen].bounds.size;
        [self setFrame:CGRectMake(0, 0, size.width, 40 * SCREEN_WIDTH_RATIO)];
        [self layoutIfNeeded];
    }
}

#pragma mark - Click bt
- (IBAction)_searchAction:(UIButton *)sender
{
    [_rootVC goToStoryBoard:kStoryMain key:kShowSearchVC];
}

@end