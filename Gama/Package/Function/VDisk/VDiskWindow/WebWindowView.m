//
//  WebWindowView.m
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "WebWindowView.h"
@interface WebWindowView () <UIWebViewDelegate>
{
    NSString *_code;
}
- (IBAction)_backAction:(UIButton *)sender;
@end


@implementation WebWindowView
@synthesize blcok = _blcok;
- (void) awakeFromNib
{
    [super awakeFromNib];
}

- (void) loadData:(NSString *)url block:(WebBlock)block
{
    _blcok = block;
    
    NSURL *nsurl = [[NSURL alloc] initWithString:url];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:nsurl];
    [_webView loadRequest:request];
    
    [_activity startAnimating];
    
    [self _show];
}

#pragma mark - Show
- (void) _show
{
    [_contentView setAlpha:0];
    CGAffineTransform transform = CGAffineTransformIdentity;
    [_contentView setTransform:CGAffineTransformScale(transform, 0.3, 0.3)];
    [UIView animateWithDuration:0.2 animations:^
    {
        [_contentView setTransform:CGAffineTransformScale(transform, 1.1, 1.1)];
        [_contentView setAlpha:0.5];
    }completion:^(BOOL finished){
        [self _bounceOutAnimationStopped];
    }];
    
    [UIView animateWithDuration:.3 animations:^
    {
        [_bgIV setAlpha:0.7];
    }];
}

- (void) _bounceOutAnimationStopped
{
    [UIView animateWithDuration:0.13 animations:^{
        [_contentView setAlpha:0.8];
        [_contentView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9)];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.13
                         animations:^{
            [_contentView setAlpha:1.0];
            [_contentView setTransform:CGAffineTransformScale(CGAffineTransformIdentity, 1.0, 1.0)];
                         }];
    }];
}

- (void) _hide:(NSString *)code
{
    _code = code;
    [UIView animateWithDuration:.3 animations:^
    {
        [self setAlpha:0];
    } completion:^(BOOL finished)
     {
        if (_blcok)
        {
            _blcok(code, (code != nil));
        }
        [self removeFromSuperview];
    }];
}

#pragma mark - Click bt
- (IBAction)_backAction:(UIButton *)sender
{
    [self _hide:nil];
}

#pragma mark - UIWebViewDelegate
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [_activity startAnimating];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [_activity stopAnimating];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [_activity stopAnimating];
}

- (BOOL)webView:(UIWebView *)aWebView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString rangeOfString:@"thebox.sinaapp.com/weibo/reg.php"].location != NSNotFound)
    {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    NSRange range = [request.URL.absoluteString rangeOfString:@"?"];
    if (range.location != NSNotFound)
    {
        NSString *uri = [request.URL.absoluteString substringFromIndex:range.location + range.length];
        NSArray *items = [uri componentsSeparatedByString:@"&"];
        for (NSString *item in items)
        {
            NSArray *param = [item componentsSeparatedByString:@"="];
            if ([param count] == 2 && [(NSString *)[param objectAtIndex:0] isEqualToString:@"code"])
            {
                NSString *code = [param objectAtIndex:1];
                [self _hide:code];
                return NO;
                break;
            }
        }
    }
    return YES;
}
@end