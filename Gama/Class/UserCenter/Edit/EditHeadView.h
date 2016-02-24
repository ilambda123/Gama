//
//  EditHeadView.h
//  Gama
//
//  Created by Paul on 16/1/14.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"
#import "ConfigType.h"

@interface EditHeadView : BaseView
{
    __weak IBOutlet UILabel *_tipLabel;
}
- (void) loadType:(ConfigType)type;
@end
