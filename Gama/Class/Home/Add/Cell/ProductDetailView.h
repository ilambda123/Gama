//
//  ProductDetailView.h
//  Gama
//
//  Created by Paul on 16/1/5.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"

@class ProductData;
@class GamaBaseViewController;
@interface ProductDetailView : BaseView
{
    __weak IBOutlet UIButton *_brandBt;
    __weak IBOutlet UIButton *_typeBt;
    __weak IBOutlet UIButton *_suitableSkinBt;
    __weak IBOutlet UITextField *_doseTF;
    __weak IBOutlet UILabel *_effectLabel;
    __weak IBOutlet UITextField *_effectTF;
    __weak IBOutlet UIButton *_effectBt;
}
@property (nonatomic) GamaBaseViewController *rootVC;
- (void) loadData;
- (BOOL) checkFinish;

- (void) previewData:(ProductData *)data;
@end
