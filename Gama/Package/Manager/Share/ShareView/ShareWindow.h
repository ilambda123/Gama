//
//  ShareWindow.h
//  XianGu
//
//  Created by Paul on 15/12/8.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareViewType.h"
#import "ShareData.h"

@class ShareContentData;
typedef void (^ShareWindowBlock)(ShareViewType type);
@interface ShareWindow : UIWindow
@property (nonatomic, copy) ShareWindowBlock block;

+ (instancetype) showShareWindow:(ShareContentData *)data
                          finish:(ShareWindowBlock)block;
@end
