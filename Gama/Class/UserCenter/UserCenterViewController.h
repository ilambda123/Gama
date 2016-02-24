//
//  UserCenterViewController.h
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "GamaBaseViewController.h"

@interface UserCenterViewController : GamaBaseViewController
{
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_centerList;
    
    NSArray *_rootList;
    NSMutableArray *_backUpList;
}
- (void) reloadBackUp;
@end
