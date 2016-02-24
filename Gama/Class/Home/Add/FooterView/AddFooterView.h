//
//  AddFooterView.h
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"
@class AddFooterView;
@protocol AddFooterViewDelegate <NSObject>
- (void) addFooterView:(AddFooterView *)view adjust:(BOOL)adjust;
- (void) addFooterViewDidAddCell:(AddFooterView *)view;
@end

@interface AddFooterView : BaseView
{
    BOOL _isAdjust;
    __weak IBOutlet UIButton *_adjustBt;
    __weak IBOutlet UIButton *_addBt;
    __weak IBOutlet UILabel *_tipLabel;
}
- (void) preview:(BOOL)hasData;
@property (nonatomic, weak) id <AddFooterViewDelegate> delegate;
@end
