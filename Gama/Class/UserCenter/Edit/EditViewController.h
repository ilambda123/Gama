//
//  EditViewController.h
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "GamaBaseViewController.h"
#import "BrandManager.h"

@interface EditViewController : GamaBaseViewController
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIButton *_addBt;
    BOOL _isAdjust;
}
@property (nonatomic) ConfigType type;
@end
