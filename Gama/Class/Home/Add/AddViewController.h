//
//  AddViewController.h
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "GamaBaseViewController.h"

@interface AddViewController : GamaBaseViewController
{
    __weak IBOutlet UITableView *_tableView;
    BOOL _isAdjust;
}
@property (nonatomic, copy) NSString *dataId;
@property (nonatomic) BOOL editProduct;
@end
