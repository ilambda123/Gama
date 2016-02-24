//
//  EditHeadView.m
//  Gama
//
//  Created by Paul on 16/1/14.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "EditHeadView.h"
#import "BrandManager.h"

@implementation EditHeadView
- (void) loadType:(ConfigType)type
{
    NSString *key = [[BrandManager shareInstance] configName:type];
    NSString *text = [NSString stringWithFormat:@"调整%@的顺序可以调整首页相应产品排序",key];
    [_tipLabel setText:text];
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
@end
