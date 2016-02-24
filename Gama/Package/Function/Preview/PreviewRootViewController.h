//
//  PreviewRootViewController.h
//  XianGu
//
//  Created by Paul on 16/1/29.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseViewController.h"

@class PreviewRootViewController;
@protocol PreviewRootViewControllerDelegate <NSObject>
- (void) previewRootViewControllerDidBack:(PreviewRootViewController *)vc;
@end

@interface PreviewRootViewController : BaseViewController
@property (nonatomic, weak) id<PreviewRootViewControllerDelegate> delegate;
@property (nonatomic) id data;

- (void) createView:(NSArray *)images
              texts:(NSArray *)texts
           curIndex:(NSInteger)index
           showRect:(CGRect)rect;
@end
