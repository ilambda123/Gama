//
//  HomeTypeView.h
//  Gama
//
//  Created by Paul on 16/1/13.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"
#import "HomeType.h"

typedef void (^TypeBlock)(HomeType type);

@interface HomeTypeView : BaseView
{
    HomeType _curType;
    __weak IBOutlet UIView *_contentView;
}
@property (nonatomic, copy) TypeBlock blcok;
- (void) loadConfig:(HomeType)type
                  y:(NSInteger)y
             finish:(TypeBlock)block;
@end
