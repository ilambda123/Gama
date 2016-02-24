//
//  SearchHeadView.h
//  Gama
//
//  Created by Paul on 16/1/15.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseView.h"

typedef void (^SearchBlock)(NSString *key);

@interface SearchHeadView : BaseView
{
    __weak IBOutlet UITextField *_searchTF;
}
@property (nonatomic, copy) SearchBlock block;
- (void) search:(SearchBlock)block;
- (void) hideKeyBoard;


@end
