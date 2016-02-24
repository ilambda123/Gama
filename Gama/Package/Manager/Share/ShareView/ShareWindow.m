//
//  ShareWindow.m
//  XianGu
//
//  Created by Paul on 15/12/8.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "ShareWindow.h"
#import "ShareView.h"
#import "Masonry.h"

@interface ShareWindow () <ShareViewDelegate>
@end

static ShareWindow *s_pwWindow = nil;
@implementation ShareWindow
@synthesize block = _block;

+ (ShareWindow *)shareInstance
{
    @synchronized(self)
    {
        if (!s_pwWindow)
        {
            s_pwWindow = [[self alloc] init];
        }
        else
        {
            [s_pwWindow setHidden:false];
        }
    }
    return s_pwWindow;
}

+ (instancetype) showShareWindow:(ShareContentData *)data finish:(ShareWindowBlock)block
{
    ShareWindow *window = [self shareInstance];
    window.block = block;
    [window _createShareView:data];
    return window;
}

- (void) removeFromSuperview
{
    [super removeFromSuperview];
}

- (void) _createShareView:(ShareContentData *)data
{
    [self setFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
    [self setHidden:NO];
    [self setWindowLevel:UIWindowLevelAlert];
    [self setBackgroundColor:[UIColor clearColor]];

    ShareView *view = [ShareView nodeFormClass];
    [view loadData:data];
    [view setDelegate:self];
    [self addSubview:view];
    [view showChannalView];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make)
     {
        make.edges.equalTo(self);
    }];
}

#pragma mark - ShareViewDelegate
- (void) shareViewDid:(ShareView *)view type:(ShareViewType)type
{
    [self setHidden:true];
    if (_block)
    {
        _block(type);
    }
}
@end