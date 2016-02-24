//
//  EditFooterView.h
//  Gama
//
//  Created by Paul on 16/1/14.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"
#import "ConfigType.h"

typedef void (^EditBlock)(BOOL adjust);

@interface EditFooterView : BaseView
{
    __weak IBOutlet UIButton *_editBt;
    BOOL _isAdjust;
}
@property (nonatomic, copy) EditBlock block;
- (void) loadConfig:(ConfigType) type edit:(EditBlock)block;
@end
