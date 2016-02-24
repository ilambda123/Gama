//
//  PreviewProductViewController.h
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "GamaBaseViewController.h"
@class ProductData;
@interface PreviewProductViewController : GamaBaseViewController
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIView *_editView;
    ProductData *_data;
}
@property (nonatomic) BOOL edit;

@end

