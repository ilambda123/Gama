//
//  HomeTypeWindow.m
//  Gama
//
//  Created by Paul on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "HomeTypeWindow.h"
#import "HomeTypeView.h"
#import "Masonry.h"

static HomeTypeWindow *s_homeTypeWindow = nil;
@implementation HomeTypeWindow
@synthesize block = _block;

+ (HomeTypeWindow *)shareInstance
{
    @synchronized(self)
    {
        if (!s_homeTypeWindow)
        {
            s_homeTypeWindow = [[self alloc] init];
        }
        else
        {
            [s_homeTypeWindow setHidden:false];
        }
    }
    return s_homeTypeWindow;
}

+ (instancetype) showWebWindow:(HomeType)curType
                             y:(NSInteger)y
                        finish:(TypeBlock)block
{
    HomeTypeWindow *window = [self shareInstance];
    window.block = block;
    [window _createTypeView:curType y:y];
    return window;
}

- (void) _createTypeView:(HomeType)curType y:(NSInteger)y
{
    [self setFrame:(CGRect) {{0.f,0.f}, [[UIScreen mainScreen] bounds].size}];
    [self setHidden:NO];
    [self setWindowLevel:UIWindowLevelAlert];
    [self setBackgroundColor:[UIColor clearColor]];
    
    __weak HomeTypeWindow *weakSelf = self;
    HomeTypeView *view = [HomeTypeView nodeFormClass];
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make)
     {
         make.edges.equalTo(self);
     }];
    
    [view loadConfig:curType y:y finish:^(HomeType type)
     {
         [weakSelf _finish:type];
    }];
}

- (void) _finish:(HomeType)type
{
    [self setHidden:true];
    if (_block)
    {
        _block(type);
    }
}
@end