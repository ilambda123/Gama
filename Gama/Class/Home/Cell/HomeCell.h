//
//  HomeCell.h
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void (^EditBlock)(NSString *dataId);

@class UrlImageView;
@class ProductData;
@class GamaBaseViewController;
@interface HomeCell : BaseTableViewCell
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UILabel *_decLabel;
    __weak IBOutlet UrlImageView *_coverIV;
    __weak IBOutlet UILabel *_typeLabel;
    ProductData *_data;
    __weak IBOutlet UIButton *_editBt;
    __weak IBOutlet UIButton *_shareBt;
}
@property (nonatomic) GamaBaseViewController *rootVC;
@property (nonatomic, copy) EditBlock block;

- (void) loadData:(NSString *)dataId;
- (void) editAction:(EditBlock)block;
- (void) hideBts:(BOOL)hide;
@end
