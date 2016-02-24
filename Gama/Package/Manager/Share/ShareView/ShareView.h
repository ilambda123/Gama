//
//  ShareView.h
//  XianGu
//
//  Created by Paul on 15/12/8.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "BaseView.h"
#import "ShareViewType.h"

@class ShareView;
@protocol ShareViewDelegate <NSObject>
- (void) shareViewDid:(ShareView *)view type:(ShareViewType)success;
@end

@class UrlImageView;
@class ShareContentData;
@interface ShareView : BaseView
{
    __weak IBOutlet UIButton *_viewBackBt;
    __weak IBOutlet UIImageView *_bgView;
    __weak IBOutlet UIView *_channelView;
}
@property (nonatomic, weak) id <ShareViewDelegate> delegate;

- (void) showChannalView;
- (void) loadData:(ShareContentData *)data;
@end
