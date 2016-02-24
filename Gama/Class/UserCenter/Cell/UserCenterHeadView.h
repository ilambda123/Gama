//
//  UserCenterHeadView.h
//  Gama
//
//  Created by Paul on 16/1/10.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"

@interface UserCenterHeadView : BaseView
{
    __weak IBOutlet UILabel *_titleLabel;
}
- (void) loadData:(NSString *)text;
@end
