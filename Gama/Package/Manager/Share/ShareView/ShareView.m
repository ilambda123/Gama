//
//  ShareView.m
//  XianGu
//
//  Created by Paul on 15/12/8.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "ShareView.h"
#import "ShareManager.h"

#import "TextData.h"
#import "FileUtils.h"
#import "AppUtils.h"

#import "NSNotificationKey.h"

@interface ShareView ()
<ShareManagerDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet NSLayoutConstraint *_channelBottomLc;
    ShareContentData *_data;
    
}
- (IBAction)_backAction:(UIButton *)sender;
- (IBAction)_channelAction:(UIButton *)sender;
@end


@implementation ShareView
@synthesize delegate = _delegate;

- (void) awakeFromNib
{
    [super awakeFromNib];
    
    ShareManager *manager = [ShareManager shareInstance];
    [manager setDelegate:self];
    [manager regShareSDK];
    [manager setAlertInView:self];
    
    [_viewBackBt setEnabled:false];
}

- (void) removeFromSuperview
{
    [super removeFromSuperview];
}

- (void) loadData:(ShareContentData *)data
{
    _data = data;
}

#pragma mark - ShowCannel
- (void) showChannalView
{
    _channelBottomLc.constant = -_channelView.frame.size.height;
    [self performSelector:@selector(_showChannelView)
               withObject:nil
               afterDelay:0.01];
}

- (void) _showChannelView
{
    _channelBottomLc.constant = 0;
    [UIView animateWithDuration:.3 animations:^{
        [_bgView setAlpha:0.8];
        [_channelView layoutIfNeeded];
    } completion:^(BOOL finished)
    {
        [_viewBackBt setEnabled:true];
    }];
}

- (void) _backChannelView
{
    _channelBottomLc.constant = -_channelView.frame.size.height;
    [UIView animateWithDuration:.3 animations:^{
        [_bgView setAlpha:0.0];
        [_channelView layoutIfNeeded];
    } completion:^(BOOL finished)
     {
         [self _cannel];
    }];
}

#pragma mark - Show Share
- (void) _cannel
{
    if (_delegate && [_delegate respondsToSelector:@selector(shareViewDid:type:)])
    {
        [_delegate shareViewDid:self type:ShareViewType_Cannel];
    }
    [self removeFromSuperview];
}

#pragma mark - click bt
- (IBAction)_backAction:(UIButton *)sender
{
    [sender setEnabled:false];
    [self _backChannelView];
}

- (IBAction)_channelAction:(UIButton *)sender
{
    ShareType tag = sender.tag;
    [[NSNotificationCenter defaultCenter] postNotificationName:kNoteShareChannel object:nil];
    
    if (tag == ShareType_Copy)
    {
        [[UIPasteboard generalPasteboard] setString:_data.shareUrl];
        [AppUtils showAlert:@"复制连接成功" inView:self];
    }
    else
    {
        [[ShareManager shareInstance] shareType:tag shareContentData:_data];
    }
}

#pragma mark - ShareManagerDelegate
- (void) shareManagerShareSuccess:(ShareManager *)manager
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"分享成功"
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil, nil];
    [alert show];
}

#pragma mark - UIAlertViewDelegate
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self _backAction:nil];
}
@end