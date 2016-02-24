//
//  TextCell.h
//  Gama
//
//  Created by Paul on 16/1/6.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MZ+Block.h"

@interface TextCellData : NSObject
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *subText;
@end


@interface TextCell : BaseTableViewCell
{
    __weak IBOutlet UILabel *_textLabel;
    __weak IBOutlet UILabel *_leftLabel;
    __weak IBOutlet UIImageView *_arrowIV;
    __weak IBOutlet UIButton *_removeBt;
}
@property (nonatomic, copy) BtnClickBlock block;

- (void) loadData:(TextCellData *)data;

- (void) loadText:(NSString *)text;
- (void) loadText:(NSString *)text remove:(BtnClickBlock)block;
@end
