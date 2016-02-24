//
//  SearchHistoryCell.h
//  XianGu
//
//  Created by Paul on 15/12/17.
//  Copyright © 2015年 Paul. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void (^KeyBlock)(NSString *key);
@interface SearchHistoryCell : BaseTableViewCell
{
    __weak IBOutlet UILabel *_titleLabel;
    __weak IBOutlet UIButton *_deleteBt;
}
@property (nonatomic, copy) KeyBlock block;
- (void) setTitle:(NSString *)key removeAction:(KeyBlock)block;



@end
