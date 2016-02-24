//
//  WebWindow.m
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "WebWindow.h"
#import "WebWindowView.h"
#import "Masonry.h"

static WebWindow *s_webWindow = nil;
@implementation WebWindow
@synthesize block = _block;

+ (WebWindow *)shareInstance
{
    @synchronized(self)
    {
        if (!s_webWindow)
        {
            s_webWindow = [[self alloc] init];
        }
        else
        {
            [s_webWindow setHidden:false];
        }
    }
    return s_webWindow;
}

- (void) removeFromSuperview
{
    [super removeFromSuperview];
}

+ (instancetype) showWebWindow:(NSString *)url finish:(WebBlock)block
{
    WebWindow *window = [self shareInstance];
    window.block = block;
    [window _createWebView:url];
    return window;
}

- (void) _createWebView:(NSString *)url
{
    [self setFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
    [self setHidden:NO];
    [self setWindowLevel:UIWindowLevelAlert];
    [self setBackgroundColor:[UIColor clearColor]];
    
    __weak WebWindow *weakSelf = self;
    WebWindowView *view = [WebWindowView nodeFormClass];
    [view loadData:url block:^(NSString *code,
                               BOOL finish)
     {
         [weakSelf _finish:code finish:finish];
    }];
    [self addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(self);
     }];
}

- (void) _finish:(NSString *)code finish:(BOOL)finish
{
    [self setHidden:true];
    if (_block)
    {
        _block(code, finish);
    }
}
@end