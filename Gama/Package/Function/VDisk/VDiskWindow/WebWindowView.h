//
//  WebWindowView.h
//  Gama
//
//  Created by Paul on 16/1/8.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"
#import "WebBlock.h"

@interface WebWindowView : BaseView
{
    __weak IBOutlet UIImageView *_bgIV;
    __weak IBOutlet UIView *_contentView;
    __weak IBOutlet UIWebView *_webView;
    __weak IBOutlet UIActivityIndicatorView *_activity;
}
@property (nonatomic, copy) WebBlock blcok;
- (void) loadData:(NSString *)url block:(WebBlock)block;
@end
