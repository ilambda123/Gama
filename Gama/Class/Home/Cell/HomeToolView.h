//
//  HomeToolView.h
//  Gama
//
//  Created by Paul on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"
#import "HomeToolType.h"


@class HomeToolView;
@protocol HomeToolViewDelegate <NSObject>
@optional
- (void) homeToolView:(HomeToolView *)view didClick:(ToolType)type;
@end

@interface HomeToolView : UIView
@property (nonatomic, weak) id <HomeToolViewDelegate> delegate;
- (void) selectType:(ToolType)type;
- (void) reloadBounds:(CGRect)bounds;

@end
