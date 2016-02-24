//
//  AddView.h
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseShowView.h"

typedef void (^ClickBlock)(NSString *text);
@interface AddView : BaseShowView
{
    __weak IBOutlet UITextField *_addTF;
}
@property (nonatomic, copy) ClickBlock block;
@property (nonatomic, copy) NSArray *list;
- (void) finish:(ClickBlock)block;
@end
