//
//  AddHeadView.h
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"

@class ProductData;
@class AddHeadView;
@protocol AddHeadViewDelegate <NSObject>
@optional
- (void) addHeadView:(AddHeadView *)view uploadError:(UIView *)moveView;
@end

@class UrlImageView;
@class GamaBaseViewController;
@interface AddHeadView : BaseView
{
    __weak IBOutlet UrlImageView *_coverIV;
    __weak IBOutlet UITextField *_titleTF;
    __weak IBOutlet UITextField *_decTF;
    __weak IBOutlet UIView *_tipView;
    __weak IBOutlet UIView *_titleView;
    
    __weak IBOutlet UILabel *_decLabel;
    __weak IBOutlet UIView *_detailView;
    
    __weak IBOutlet UIImageView *_editTItleIV;
    BOOL _canEdit;
}
@property (nonatomic, weak) id <AddHeadViewDelegate> delegate;
@property (nonatomic) GamaBaseViewController *rootVC;
- (void) loadData;
- (BOOL) checkFinish;

- (void) previewData:(ProductData *)data;
@end
