//
//  HomeViewController.h
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "GamaBaseViewController.h"

@interface HomeViewController : GamaBaseViewController
{
    __weak IBOutlet UITableView *_tableView;
    __weak IBOutlet UIButton *_addBt;
}
@end
