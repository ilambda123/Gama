//
//  InputViewController.h
//  Gama
//
//  Created by Paul on 16/1/4.
//  Copyright © 2016年 Paul. All rights reserved.
//

#import "GamaBaseViewController.h"

typedef void (^InputBlock)(NSString *text, NSString *key);
@interface InputViewController : GamaBaseViewController
{
    __weak IBOutlet UITextView *_textView;
    NSString *_text;
}
@property (nonatomic, copy) InputBlock block;
@property (nonatomic, copy) NSString *key;

- (void) loadText:(NSString *)text finish:(InputBlock)finish;
@end
