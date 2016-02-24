//
//  AddPicDetailCell.h
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef NS_ENUM(NSInteger, AddViewType)
{
    none = 0,
    addDec,
    addImage,
};

@class ProductDecData;
@class GamaBaseViewController;
@class UrlImageView;
@interface AddPicDetailCell : BaseTableViewCell
{
    __weak IBOutlet UrlImageView *_coverIV;
    __weak IBOutlet UILabel *_decLabel;
    __weak IBOutlet UITextField *_decTF;
    __weak IBOutlet UIView *_imageView;
    ProductDecData *_data;
    
    BOOL _canEdit;
}
@property (nonatomic) GamaBaseViewController *rootVC;
- (void) loadData:(ProductDecData *)data;
- (void) previewData:(ProductDecData *)data;

- (void) uploadFail:(AddViewType)type;

@end
